-- Silent Slayer 2 - Map Voting Pads (Real Parts version, replaces old UI-based one)
local old = workspace:FindFirstChild("MapVoting")
if old then old:Destroy() end

local votingFolder = Instance.new("Folder")
votingFolder.Name = "MapVoting"
votingFolder.Parent = workspace

local mapData = {
	{name = "MOTEL", color = Color3.fromRGB(255, 220, 0)},
	{name = "BANK", color = Color3.fromRGB(0, 200, 255)},
	{name = "WORKSPACE", color = Color3.fromRGB(0, 255, 120)},
	{name = "ECO LAB", color = Color3.fromRGB(255, 60, 60)},
}

local votes = {}
local playerVotes = {}
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

	local base = Instance.new("Part")
	base.Name = "Base"
	base.Size = Vector3.new(6, 1, 6)
	base.Position = pos
	base.Anchored = true
	base.Material = Enum.Material.Metal
	base.Color = Color3.fromRGB(60, 60, 65)
	base.Parent = padModel

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

	-- Real physical sign part (upright), text painted onto its surface, not a floating billboard
	local sign = Instance.new("Part")
	sign.Name = "Sign"
	sign.Size = Vector3.new(5, 3.5, 0.4)
	sign.Position = pos + Vector3.new(0, 4.5, -3)
	sign.Anchored = true
	sign.Material = Enum.Material.SmoothPlastic
	sign.Color = Color3.fromRGB(20, 25, 35)
	sign.Parent = padModel

	local stroke = Instance.new("SelectionBox")
	stroke.Adornee = sign
	stroke.Color3 = map.color
	stroke.LineThickness = 0.08
	stroke.Transparency = 0
	stroke.SurfaceTransparency = 1
	stroke.Parent = sign

	local signGui = Instance.new("SurfaceGui")
	signGui.Face = Enum.NormalId.Back
	signGui.Parent = sign
	signGui.LightInfluence = 0

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(1, 0, 0.4, 0)
	nameLabel.Position = UDim2.new(0, 0, 0.05, 0)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = map.name
	nameLabel.TextScaled = true
	nameLabel.Font = Enum.Font.GothamBlack
	nameLabel.TextColor3 = Color3.new(1, 1, 1)
	nameLabel.Parent = signGui

	local voteLabel = Instance.new("TextLabel")
	voteLabel.Name = "VoteCountLabel"
	voteLabel.Size = UDim2.new(1, 0, 0.3, 0)
	voteLabel.Position = UDim2.new(0, 0, 0.65, 0)
	voteLabel.BackgroundTransparency = 1
	voteLabel.Text = "VOTES: 0"
	voteLabel.TextScaled = true
	voteLabel.Font = Enum.Font.GothamBold
	voteLabel.TextColor3 = map.color
	voteLabel.Parent = signGui

	local debounce = {}
	base.Touched:Connect(function(hit)
		local character = hit.Parent
		local player = game.Players:GetPlayerFromCharacter(character)
		if not player then return end
		if debounce[player.UserId] then return end
		debounce[player.UserId] = true

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

	pads[map.name] = {VoteCountLabel = voteLabel}

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

print("[gh-sync] Real-part voting signs created (old UI version replaced)")