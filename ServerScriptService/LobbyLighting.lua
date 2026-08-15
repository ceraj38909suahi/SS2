-- Silent Slayer 2 Lobby - Color Changing Lighting
local lobby = workspace:WaitForChild("LobbyStructure")

local lightFolder = Instance.new("Folder")
lightFolder.Name = "LobbyLighting"
lightFolder.Parent = lobby

-- Fixture positions spread through the lobby (matches chandelier-style spots in the reference layout)
local fixturePositions = {
	Vector3.new(-20, 30, -20),
	Vector3.new(0, 30, -25),
	Vector3.new(20, 30, -20),
	Vector3.new(-40, 30, 10),
	Vector3.new(40, 30, 10),
	Vector3.new(0, 30, 20),
	Vector3.new(-45, 14, -5), -- upper floor left
	Vector3.new(45, 14, -5),  -- upper floor right
}

local colorCycle = {
	Color3.fromRGB(0, 150, 255),   -- blue
	Color3.fromRGB(150, 0, 255),   -- purple
	Color3.fromRGB(255, 0, 120),   -- pink
	Color3.fromRGB(0, 255, 200),   -- cyan
	Color3.fromRGB(255, 80, 0),    -- orange
}

local fixtures = {}

for i, pos in ipairs(fixturePositions) do
	local base = Instance.new("Part")
	base.Name = "LightFixture"..i
	base.Size = Vector3.new(2, 1, 2)
	base.Position = pos
	base.Anchored = true
	base.Material = Enum.Material.Neon
	base.BrickColor = BrickColor.new("White")
	base.Shape = Enum.PartType.Ball
	base.Parent = lightFolder

	local light = Instance.new("PointLight")
	light.Range = 24
	light.Brightness = 3
	light.Color = colorCycle[1]
	light.Parent = base

	table.insert(fixtures, {base = base, light = light, offset = i})
end

-- Smooth color cycling loop (shared hue rotation, offset per fixture for variety)
local speed = 0.15 -- hue units per second

task.spawn(function()
	local t = 0
	while true do
		t = t + speed * task.wait(0.05)
		for _, fx in ipairs(fixtures) do
			local hue = (t + fx.offset * 0.12) % 1
			local color = Color3.fromHSV(hue, 0.85, 1)
			fx.light.Color = color
			fx.base.Color = color
		end
	end
end)

print("[gh-sync] Color-changing lighting added: " .. #fixtures .. " fixtures cycling")