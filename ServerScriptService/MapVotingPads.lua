-- Silent Slayer 2 - Map Voting Pads
local votingFolder = Instance.new("Folder")
votingFolder.Name = "MapVoting"
votingFolder.Parent = workspace

local mapData = {
	{name = "MOTEL", color = Color3.fromRGB(255, 220, 0), icon = "🏨"},
	{name = "BANK", color = Color3.fromRGB(0, 200, 255), icon = "🏦"},
	{name = "WORKSPACE", color = Color3.fromRGB(0, 255, 120), icon = "💻"},
	{name = "ECO LAB", color = Color3.fromRGB(255, 60, 60), icon = "🧪"},
}

local votes = {}
local playerVotes = {} -- tracks which map each player voted for

local basePositions = {
	Vector3.new(-24, 1, 0),
	Vector3.new(-8, 1, 0),
	Vector3.new(8, 1, 0),
	Vector3.new(24, 1, 0),
}

local pads = {}

for i, map in ipairs(mapData) do
	votes[map.name] = 0
	local pos = basePositions[i]

	local padModel = Instance.new("Model")
	padModel.Name = "VotePad_" .. map.name
	padModel.Parent = votingFolder

	-- Base platform
	local base = Instance.new("Part")
	base.Name = "Base"
	base.Size = Vector3.new(6, 1, 6)
	base.Position = pos
	base.Anchored = true
	base.Material = Enum.Material.Metal
	base.Color = Color3.fromRGB(60, 60, 65)
	base.Parent = padModel

	-- Glowing top surface
	local glowTop = Instance.new("Part")
	glowTop.Name = "GlowSurface"
	glowTop.Size = Vector3.new(5, 0.2, 5)
	glowTop.Position = pos + Vector3.new(0, 0.6, 0)
	glowTop.Anchored = true
	glowTop.Material = Enum.Material.Neon
	glowTop.Color = map.color
	glowTop.Parent = padModel

	local light = Instance.new("PointLight")
	light.Range = 12
	light.Brightness = 2
	light.Color = map.color
	light.Parent = glowTop

	-- Edge glow strips (4 sides)
	local edgeOffsets = {
		Vector3.new(2.6, 0, 0), Vector3.new(-2.6, 0, 0),
		Vector3.new(0, 0, 2.6), Vector3.new(0, 0, -2.6),
	}
	for j, off in ipairs(edgeOffsets) do
		local strip = Instance.new("Part")
		strip.Name = "EdgeGlow"..j
		strip.Size = (j <= 2) and Vector3.new(0.3, 0.4, 4) or Vector3.new(4, 0.4, 0.3)
		strip.Position = pos + off + Vector3.new(0, 0.3, 0)
		strip.Anchored = true
		strip.Material = Enum.Material.Neon
		strip.Color = map.color
		strip.Parent = padModel
	end

	-- Info billboard above pad
	local infoAnchor = Instance.new("Part")
	infoAnchor.Name = "InfoAnchor"
	infoAnchor.Size = Vector3.new(0.1, 0.1, 0.1)
	infoAnchor.Position = pos + Vector3.new(0, 5.5, 0)
	infoAnchor.Anchored = true
	infoAnchor.Transparency = 1
	infoAnchor.CanCollide = false
	infoAnchor.Parent = padModel

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "MapCard"
	billboard.Size = UDim2.new(0, 160, 0, 190)
	billboard.StudsOffset = Vector3.new(0, 0, 0)
	billboard.AlwaysOnTop = true
	billboard.Parent = infoAnchor

	local cardFrame = Instance.new("Frame")
	cardFrame.Size = UDim2.new(1, 0, 1, 0)
	cardFrame.BackgroundColor3 = Color3.fromRGB(20, 25, 35)
	cardFrame.BackgroundTransparency = 0.15
	cardFrame.BorderSizePixel = 0
	cardFrame.Parent = billboard

	local stroke = Instance.new("UIStroke")
	stroke.Color = map.color
	stroke.Thickness = 3
	stroke.Parent = cardFrame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 10)
	corner.Parent = cardFrame

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0, 36)
	nameLabel.Position = UDim2.new(0, 0, 0, 8)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = map.name
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.Parent = cardFrame

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(1, 0, 0, 70)
	iconLabel.Position = UDim2.new(0, 0, 0, 48)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = map.icon
	iconLabel.TextScaled = true
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.Parent = cardFrame

	local voteLabel = Instance.new("TextLabel")
	voteLabel.Name = "VoteCountLabel"
	voteLabel.Size = UDim2.new(1, 0, 0, 30)
	voteLabel.Position = UDim2.new(0, 0, 1, -38)
	voteLabel.BackgroundTransparency = 1
	voteLabel.Text = "VOTES: 0"
	voteLabel.TextScaled = true
	voteLabel.Font = Enum.Font.GothamBold
	voteLabel.TextColor3 = map.color
	voteLabel.Parent = cardFrame

	-- Voting trigger (touch based)
	local debounce = {}
	base.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		if not player then return end
		if debounce[player.UserId] then return end
		debounce[player.UserId] = true

		-- remove previous vote if switching
		local prevVote = playerVotes[player.UserId]
		if prevVote and prevVote ~= map.name then
			votes[prevVote] = math.max(0, votes[prevVote] - 1)
			if pads[prevVote] then
				pads[prevVote].VoteCountLabel.Text = "VOTES: " .. votes[prevVote]
			end
		end

		if prevVote ~= map.name then
			votes[map.name] += 1
			playerVotes[player.UserId] = map.name
			voteLabel.Text = "VOTES: " .. votes[map.name]
		end

		task.wait(1)
		debounce[player.UserId] = nil
	end)

	pads[map.name] = {VoteCountLabel = voteLabel, GlowSurface = glowTop}

	-- Idle pulse animation on glow
	task.spawn(function()
		while true do
			for t = 0, 1, 0.05 do
				glowTop.Transparency = 0.15 * math.sin(t * math.pi * 2) + 0.1
				task.wait(0.05)
			end
		end
	end)
end

game.Players.PlayerRemoving:Connect(function(player)
	local prevVote = playerVotes[player.UserId]
	if prevVote then
		votes[prevVote] = math.max(0, votes[prevVote] - 1)
		if pads[prevVote] then
			pads[prevVote].VoteCountLabel.Text = "VOTES: " .. votes[prevVote]
		end
		playerVotes[player.UserId] = nil
	end
end)

print("[gh-sync] Map voting pads created: " .. table.concat((function() local n={} for _,m in ipairs(mapData) do table.insert(n,m.name) end return n end)(), ", "))