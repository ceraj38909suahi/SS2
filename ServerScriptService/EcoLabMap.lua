-- Silent Slayer 2 - Eco Lab Map (core structure)
local old = workspace:FindFirstChild("EcoLabMap")
if old then old:Destroy() end

local map = Instance.new("Folder")
map.Name = "EcoLabMap"
map.Parent = workspace

local function part(name, size, pos, color, parent, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Anchored = true
	p.Color = color or Color3.fromRGB(40, 45, 40)
	p.Material = material or Enum.Material.Metal
	if transparency then p.Transparency = transparency end
	p.Parent = parent or map
	return p
end

-- Ground floor
part("GroundFloor", Vector3.new(110, 2, 110), Vector3.new(0, 0, 0), Color3.fromRGB(30, 35, 32), map, Enum.Material.Concrete)

-- Outer walls
part("Wall_N", Vector3.new(110, 30, 2), Vector3.new(0, 15, -55), Color3.fromRGB(25, 30, 28), map, Enum.Material.Metal)
part("Wall_S", Vector3.new(110, 30, 2), Vector3.new(0, 15, 55), Color3.fromRGB(25, 30, 28), map, Enum.Material.Metal)
part("Wall_E", Vector3.new(2, 30, 110), Vector3.new(55, 15, 0), Color3.fromRGB(25, 30, 28), map, Enum.Material.Metal)
part("Wall_W", Vector3.new(2, 30, 110), Vector3.new(-55, 15, 0), Color3.fromRGB(25, 30, 28), map, Enum.Material.Metal)
part("Ceiling", Vector3.new(110, 2, 110), Vector3.new(0, 30, 0), Color3.fromRGB(15, 18, 16), map, Enum.Material.Metal)

-- Upper walkway ring (matches balcony visible in reference)
local walkY = 16
part("Walkway_N", Vector3.new(90, 1, 12), Vector3.new(0, walkY, -40), Color3.fromRGB(35, 40, 38), map, Enum.Material.DiamondPlate)
part("Walkway_S", Vector3.new(90, 1, 12), Vector3.new(0, walkY, 40), Color3.fromRGB(35, 40, 38), map, Enum.Material.DiamondPlate)

-- Central containment tower (glass cylinder, 2 levels)
local towerFolder = Instance.new("Folder")
towerFolder.Name = "ContainmentTower"
towerFolder.Parent = map

local towerBase = Instance.new("Part")
towerBase.Name = "TowerBase"
towerBase.Shape = Enum.PartType.Cylinder
towerBase.Size = Vector3.new(2, 20, 20)
towerBase.Orientation = Vector3.new(0, 0, 90)
towerBase.Position = Vector3.new(0, 11, 0)
towerBase.Anchored = true
towerBase.Material = Enum.Material.Glass
towerBase.Color = Color3.fromRGB(120, 255, 200)
towerBase.Transparency = 0.55
towerBase.Parent = towerFolder

local towerLight = Instance.new("PointLight")
towerLight.Range = 40
towerLight.Brightness = 4
towerLight.Color = Color3.fromRGB(100, 255, 180)
towerLight.Parent = towerBase

-- Tree trunk + canopy inside tower (simple geometric tree)
local trunk = part("TreeTrunk", Vector3.new(2.5, 16, 2.5), Vector3.new(0, 9, 0), Color3.fromRGB(60, 45, 35), towerFolder, Enum.Material.Wood)
for i = 1, 6 do
	local angle = (i / 6) * math.pi * 2
	local bx = math.cos(angle) * 3
	local bz = math.sin(angle) * 3
	part("Branch"..i, Vector3.new(1, 6, 1), Vector3.new(bx, 10 + i, bz), Color3.fromRGB(60, 45, 35), towerFolder, Enum.Material.Wood)
end
local canopy = part("Canopy", Vector3.new(9, 9, 9), Vector3.new(0, 19, 0), Color3.fromRGB(60, 220, 120), towerFolder, Enum.Material.Neon)
canopy.Shape = Enum.PartType.Ball
canopy.Transparency = 0.1
local canopyLight = Instance.new("PointLight")
canopyLight.Range = 30
canopyLight.Brightness = 3
canopyLight.Color = Color3.fromRGB(80, 255, 150)
canopyLight.Parent = canopy

-- Tower floor divider ring (between the two glass levels in the image)
part("TowerDivider", Vector3.new(22, 1, 22), Vector3.new(0, 15, 0), Color3.fromRGB(20, 25, 22), towerFolder, Enum.Material.Metal)

-- Spiral staircases (both sides of the tower, matching reference)
local function buildSpiral(name, centerX, direction)
	local stairFolder = Instance.new("Folder")
	stairFolder.Name = name
	stairFolder.Parent = towerFolder
	local steps = 20
	local radius = 8
	for i = 1, steps do
		local angle = (i / steps) * math.pi * 1.5 * direction
		local sx = centerX + math.cos(angle) * radius
		local sz = math.sin(angle) * radius
		local sy = (i / steps) * walkY
		part("Step"..i, Vector3.new(3, 0.5, 3), Vector3.new(sx, sy, sz), Color3.fromRGB(45, 50, 48), stairFolder, Enum.Material.DiamondPlate)
	end
end
buildSpiral("SpiralStairs_Left", -14, 1)
buildSpiral("SpiralStairs_Right", 14, -1)

-- Hanging ECO LAB banner
local banner = part("EcoLabBanner", Vector3.new(4, 14, 0.3), Vector3.new(0, 22, 8), Color3.fromRGB(15, 45, 30), map, Enum.Material.Fabric)
local bannerGui = Instance.new("SurfaceGui")
bannerGui.Face = Enum.NormalId.Front
bannerGui.Parent = banner
local bannerLabel = Instance.new("TextLabel")
bannerLabel.Size = UDim2.new(1, 0, 1, 0)
bannerLabel.BackgroundTransparency = 1
bannerLabel.Text = "ECO
LAB"
bannerLabel.TextScaled = true
bannerLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
bannerLabel.Font = Enum.Font.GothamBlack
bannerLabel.Parent = bannerGui

-- Terminal/monitor stations scattered on ground floor
local termFolder = Instance.new("Folder")
termFolder.Name = "Terminals"
termFolder.Parent = map
local termSpots = {
	Vector3.new(-30, 3, -20), Vector3.new(-35, 3, 5),
	Vector3.new(30, 3, -15), Vector3.new(20, 3, 15),
}
for i, spot in ipairs(termSpots) do
	local desk = part("TerminalDesk"..i, Vector3.new(4, 3, 2), spot, Color3.fromRGB(30, 35, 32), termFolder, Enum.Material.Metal)
	local screen = part("TerminalScreen"..i, Vector3.new(3, 2, 0.2), spot + Vector3.new(0, 2, -0.9), Color3.fromRGB(20, 25, 22), termFolder, Enum.Material.SmoothPlastic)
	local screenGui = Instance.new("SurfaceGui")
	screenGui.Face = Enum.NormalId.Front
	screenGui.Parent = screen
	local screenLabel = Instance.new("TextLabel")
	screenLabel.Size = UDim2.new(1, 0, 1, 0)
	screenLabel.BackgroundTransparency = 1
	screenLabel.Text = "ECO LAB
REACTOR"
	screenLabel.TextScaled = true
	screenLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
	screenLabel.Font = Enum.Font.Code
	screenLabel.Parent = screenGui
end

-- Crates and clutter
local crateFolder = Instance.new("Folder")
crateFolder.Name = "Crates"
crateFolder.Parent = map
local cratePositions = {
	Vector3.new(45, 3, -40), Vector3.new(42, 5, -40), Vector3.new(45, 3, -35),
	Vector3.new(-45, 3, 30), Vector3.new(-42, 5, 30),
}
for i, pos in ipairs(cratePositions) do
	part("Crate"..i, Vector3.new(2.5, 2.5, 2.5), pos, Color3.fromRGB(50, 55, 40), crateFolder, Enum.Material.Wood)
end

-- Hanging lamp fixtures (matches dim spotlights in reference)
local lampSpots = {
	Vector3.new(-20, 25, -10), Vector3.new(20, 25, -10),
	Vector3.new(-20, 25, 20), Vector3.new(20, 25, 20),
}
for i, spot in ipairs(lampSpots) do
	local lamp = part("HangLamp"..i, Vector3.new(1.5, 1, 1.5), spot, Color3.fromRGB(10, 10, 10), map, Enum.Material.Metal)
	local lampLight = Instance.new("SpotLight")
	lampLight.Range = 20
	lampLight.Brightness = 3
	lampLight.Angle = 60
	lampLight.Color = Color3.fromRGB(200, 255, 220)
	lampLight.Face = Enum.NormalId.Bottom
	lampLight.Parent = lamp
end

-- Ambient fog/lighting adjustment for the map (applied globally when this map is active)
game.Lighting.FogColor = Color3.fromRGB(20, 40, 30)
game.Lighting.FogStart = 20
game.Lighting.FogEnd = 120
game.Lighting.Brightness = 1
game.Lighting.Ambient = Color3.fromRGB(15, 30, 20)
game.Lighting.OutdoorAmbient = Color3.fromRGB(15, 30, 20)

print("[gh-sync] Eco Lab map generated: containment tower, spiral stairs, terminals, crates, fog")