-- Silent Slayer 2 - Map Voting Pads (full rebuild)
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

local basePositions = {
	Vector3.new(-24, 1, 0),
	Vector3.new(-8, 1, 0),
	Vector3.new(8, 1, 0),
	Vector3.new(24, 1, 0),
}

local votes = {}
local playerVotes = {}
local voteLabels = {}

local function buildPad(map, pos)
	votes[map.name] = 0

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
	padModel.PrimaryPart = base

	-- Glowing neon top
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

	-- Edge glow strips
	local edgeOffsets = {
		{Vector3.new(2.6, 0, 0), Vector3.new(0.3, 0.4, 4)},
		{Vector3.new(-2.6, 0, 0), Vector3.new(0.3, 0.4, 4)},
		{Vector3.new(0, 0, 2.6), Vector3.new(4, 0.4, 0.3)},
		{Vector3.new(0, 0, -2.6), Vector3.new(4, 0.4, 0.3)},
	}
	for j, data in ipairs(edgeOffsets) do
		local strip = Instance.new("Part")
		strip.Name = "EdgeGlow"..j
		strip.Size = data[2]
		strip.Position = pos + data[1] + Vector3.new(0, 0.3, 0)
		strip.Anchored = true
		strip.Material = Enum.Material.Neon
		strip.Color = map.color
		strip.Parent = padModel
	end

	-- Physical sign (real part, text on its surface)
	local sign = Instance.new("Part")
	sign.Name = "Sign"
	sign.Size = Vector3.new(5, 3.5, 0.4)
	sign.Position = pos + Vector3.new(0, 4.5, -3)
	sign.Anchored = true
	sign.Material = Enum.Material.SmoothPlastic
	sign.Color = Color3.fromRGB(20, 25, 35)
	sign.Parent = padModel

	local outline = Instance.new("SelectionBox")
	outline.Adornee = sign
	outline.Color3 = map.color
	outline.LineThickness = 0.08
	outline.SurfaceTransparency = 1
	outline.Parent = sign

	local signGui = Instance.new("SurfaceGui")
	signGui.Face = Enum.NormalId.Back
	signGui.LightInfluence = 0
	signGui.Parent = sign

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

	voteLabels[map.name] = voteLabel

	-- Voting logic
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
			if voteLabels[prevVote] then
				voteLabels[prevVote].Text = "VOTES: " .. votes[prevVote]
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

	-- Idle glow pulse
	task.spawn(function()
		while true do
			for t = 0, 1, 0.05 do
				glowTop.Transparency = 0.15 * math.sin(t * math.pi * 2) + 0.1
				task.wait(0.05)
			end
		end
	end)
end

for i, map in ipairs(mapData) do
	buildPad(map, basePositions[i])
end

game.Players.PlayerRemoving:Connect(function(player)
	local prevVote = playerVotes[player.UserId]
	if prevVote then
		votes[prevVote] = math.max(0, votes[prevVote] - 1)
		if voteLabels[prevVote] then
			voteLabels[prevVote].Text = "VOTES: " .. votes[prevVote]
		end
		playerVotes[player.UserId] = nil
	end
end)

print("[gh-sync] Voting pads fully rebuilt: " .. #mapData .. " pads active")