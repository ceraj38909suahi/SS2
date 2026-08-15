-- Silent Slayer 2 - Eco Lab Map (layout-accurate rebuild)
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
part("GroundFloor", Vector3.new(120, 2, 120), Vector3.new(0, 0, 0), Color3.fromRGB(28, 32, 30), map, Enum.Material.Concrete)

-- Raised octagonal platform under the tower (distinct floor ring seen in reference)
local platformFolder = Instance.new("Folder")
platformFolder.Name = "CenterPlatform"
platformFolder.Parent = map
local octRadius = 18
for i = 1, 8 do
	local a1 = (i / 8) * math.pi * 2
	local a2 = ((i + 1) / 8) * math.pi * 2
	local mx = math.cos((a1 + a2) / 2) * (octRadius * 0.6)
	local mz = math.sin((a1 + a2) / 2) * (octRadius * 0.6)
	part("PlatformWedge"..i, Vector3.new(14, 0.6, 14), Vector3.new(mx, 1.3, mz), Color3.fromRGB(45, 50, 46), platformFolder, Enum.Material.DiamondPlate)
end
part("PlatformCore", Vector3.new(20, 0.6, 20), Vector3.new(0, 1.3, 0), Color3.fromRGB(50, 55, 50), platformFolder, Enum.Material.DiamondPlate)

-- Outer walls (wider room)
part("Wall_N", Vector3.new(120, 32, 2), Vector3.new(0, 16, -60), Color3.fromRGB(22, 26, 24), map, Enum.Material.Metal)
part("Wall_S", Vector3.new(120, 32, 2), Vector3.new(0, 16, 60), Color3.fromRGB(22, 26, 24), map, Enum.Material.Metal)
part("Wall_E", Vector3.new(2, 32, 120), Vector3.new(60, 16, 0), Color3.fromRGB(22, 26, 24), map, Enum.Material.Metal)
part("Wall_W", Vector3.new(2, 32, 120), Vector3.new(-60, 16, 0), Color3.fromRGB(22, 26, 24), map, Enum.Material.Metal)
part("Ceiling", Vector3.new(120, 2, 120), Vector3.new(0, 32, 0), Color3.fromRGB(12, 15, 13), map, Enum.Material.Metal)

-- Upper walkway: two side catwalks near ceiling height + back connector (not a full ring)
local walkY = 24
part("Walkway_Left", Vector3.new(36, 1, 14), Vector3.new(-42, walkY, -25), Color3.fromRGB(30, 34, 32), map, Enum.Material.DiamondPlate)
part("Walkway_Right", Vector3.new(36, 1, 14), Vector3.new(42, walkY, -25), Color3.fromRGB(30, 34, 32), map, Enum.Material.DiamondPlate)
part("Walkway_Back", Vector3.new(24, 1, 40), Vector3.new(0, walkY, -40), Color3.fromRGB(30, 34, 32), map, Enum.Material.DiamondPlate)
-- railings on catwalks
part("WalkRail_Left", Vector3.new(36, 3, 0.3), Vector3.new(-42, walkY + 1.5, -18), Color3.fromRGB(15, 18, 16), map, Enum.Material.Metal)
part("WalkRail_Right", Vector3.new(36, 3, 0.3), Vector3.new(42, walkY + 1.5, -18), Color3.fromRGB(15, 18, 16), map, Enum.Material.Metal)

-- Central containment tower: narrow, tall, 2 visible levels via divider
local towerFolder = Instance.new("Folder")
towerFolder.Name = "ContainmentTower"
towerFolder.Parent = map

local towerRadius = 8
local towerHeight = 26
local towerBase = Instance.new("Part")
towerBase.Name = "TowerGlass"
towerBase.Shape = Enum.PartType.Cylinder
towerBase.Size = Vector3.new(2, towerRadius * 2, towerRadius * 2)
towerBase.Orientation = Vector3.new(0, 0, 90)
towerBase.Position = Vector3.new(0, 2 + towerHeight/2, -6)
towerBase.Anchored = true
towerBase.Material = Enum.Material.Glass
towerBase.Color = Color3.fromRGB(130, 255, 210)
towerBase.Transparency = 0.5
towerBase.Parent = towerFolder

local towerLight = Instance.new("PointLight")
towerLight.Range = 45
towerLight.Brightness = 5
towerLight.Color = Color3.fromRGB(100, 255, 180)
towerLight.Parent = towerBase

-- tower cap (metal rim at top and mid divider matching reference bands)
part("TowerCapTop", Vector3.new(2, towerRadius * 2 + 1, towerRadius * 2 + 1), Vector3.new(0, 2 + towerHeight, -6), Color3.fromRGB(20, 24, 22), towerFolder, Enum.Material.Metal).Orientation = Vector3.new(0,0,90)
local divider = part("TowerDivider", Vector3.new(2, towerRadius * 2 + 1, towerRadius * 2 + 1), Vector3.new(0, 2 + towerHeight * 0.52, -6), Color3.fromRGB(20, 24, 22), towerFolder, Enum.Material.Metal)
divider.Shape = Enum.PartType.Cylinder
divider.Orientation = Vector3.new(0, 0, 90)
part("TowerCapBase", Vector3.new(2, towerRadius * 2 + 2, towerRadius * 2 + 2), Vector3.new(0, 2, -6), Color3.fromRGB(20, 24, 22), towerFolder, Enum.Material.Metal).Orientation = Vector3.new(0,0,90)

-- Tree trunk + canopy centered in tower
local trunk = part("TreeTrunk", Vector3.new(2, 18, 2), Vector3.new(0, 11, -6), Color3.fromRGB(55, 42, 32), towerFolder, Enum.Material.Wood)
for i = 1, 7 do
	local angle = (i / 7) * math.pi * 2
	local bx = math.cos(angle) * 2.2
	local bz = -6 + math.sin(angle) * 2.2
	part("Branch"..i, Vector3.new(0.8, 5, 0.8), Vector3.new(bx, 12 + i * 0.8, bz), Color3.fromRGB(55, 42, 32), towerFolder, Enum.Material.Wood)
end
local canopy = part("Canopy", Vector3.new(7, 7, 7), Vector3.new(0, 21, -6), Color3.fromRGB(70, 230, 130), towerFolder, Enum.Material.Neon)
canopy.Shape = Enum.PartType.Ball
canopy.Transparency = 0.15
local canopyLight = Instance.new("PointLight")
canopyLight.Range = 26
canopyLight.Brightness = 3
canopyLight.Color = Color3.fromRGB(90, 255, 160)
canopyLight.Parent = canopy

-- Spiral staircases hugging tight to tower on both sides
local function buildSpiral(name, side)
	local stairFolder = Instance.new("Folder")
	stairFolder.Name = name
	stairFolder.Parent = towerFolder
	local steps = 22
	local radius = towerRadius + 3.5
	for i = 1, steps do
		local angle = (i / steps) * math.pi * 1.6 * side + (side > 0 and 0 or math.pi)
		local sx = math.cos(angle) * radius
		local sz = -6 + math.sin(angle) * radius
		local sy = 2 + (i / steps) * walkY
		part("Step"..i, Vector3.new(2.5, 0.4, 2.5), Vector3.new(sx, sy, sz), Color3.fromRGB(40, 44, 42), stairFolder, Enum.Material.DiamondPlate)
	end
end
buildSpiral("SpiralStairs_Left", 1)
buildSpiral("SpiralStairs_Right", -1)

-- Hanging ECO LAB banner directly behind tower
local banner = part("EcoLabBanner", Vector3.new(3.5, 16, 0.3), Vector3.new(0, 20, -18), Color3.fromRGB(12, 35, 24), map, Enum.Material.Fabric)
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

-- Terminal cluster: left-foreground group
local termFolder = Instance.new("Folder")
termFolder.Name = "Terminals"
termFolder.Parent = map
local function buildTerminal(name, pos, rotY)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = termFolder
	local desk = part("Desk", Vector3.new(4, 3, 2), pos, Color3.fromRGB(28, 32, 30), model, Enum.Material.Metal)
	desk.Orientation = Vector3.new(0, rotY, 0)
	local screen = Instance.new("Part")
	screen.Name = "Screen"
	screen.Size = Vector3.new(3, 2, 0.2)
	screen.CFrame = desk.CFrame * CFrame.new(0, 1.6, -0.9)
	screen.Anchored = true
	screen.Color = Color3.fromRGB(18, 22, 20)
	screen.Material = Enum.Material.SmoothPlastic
	screen.Parent = model
	local screenGui = Instance.new("SurfaceGui")
	screenGui.Face = Enum.NormalId.Front
	screenGui.Parent = screen
	local screenLabel = Instance.new("TextLabel")
	screenLabel.Size = UDim2.new(1, 0, 1, 0)
	screenLabel.BackgroundTransparency = 1
	screenLabel.Text = "ECO LAB
SECTOR"
	screenLabel.TextScaled = true
	screenLabel.TextColor3 = Color3.fromRGB(100, 255, 200)
	screenLabel.Font = Enum.Font.Code
	screenLabel.Parent = screenGui
end
-- left-foreground cluster
buildTerminal("Term_L1", Vector3.new(-40, 3, 15), 20)
buildTerminal("Term_L2", Vector3.new(-42, 3, 20), -10)
-- right-background cluster
buildTerminal("Term_R1", Vector3.new(35, 3, -8), -15)
buildTerminal("Term_R2", Vector3.new(38, 3, -3), 10)

-- Large stacked crates, right side (prominent industrial storage)
local crateFolder = Instance.new("Folder")
crateFolder.Name = "Crates"
crateFolder.Parent = map
local crateStack = {
	{Vector3.new(50, 3, 10), Vector3.new(3, 3, 3)},
	{Vector3.new(50, 6.2, 10), Vector3.new(3, 3, 3)},
	{Vector3.new(46, 3, 8), Vector3.new(3, 3, 3)},
	{Vector3.new(50, 3, 15), Vector3.new(3, 3, 3)},
	{Vector3.new(50, 6.2, 15), Vector3.new(3, 3, 3)},
	{Vector3.new(46, 3, 18), Vector3.new(3, 3, 3)},
	{Vector3.new(46, 6.2, 18), Vector3.new(3, 3, 3)},
}
for i, data in ipairs(crateStack) do
	part("Crate"..i, data[2], data[1], Color3.fromRGB(85, 95, 45), crateFolder, Enum.Material.Metal)
end

-- Small crate cluster near left terminals (matches reference foreground)
local smallCrates = {Vector3.new(-30, 3, 22), Vector3.new(-27, 5, 22)}
for i, pos in ipairs(smallCrates) do
	part("SmallCrate"..i, Vector3.new(2.5, 2.5, 2.5), pos, Color3.fromRGB(60, 55, 40), crateFolder, Enum.Material.Wood)
end

-- Hanging lamp fixtures over the platform
local lampSpots = {
	Vector3.new(-14, 28, -2), Vector3.new(14, 28, -2),
}
for i, spot in ipairs(lampSpots) do
	local lamp = part("HangLamp"..i, Vector3.new(1.5, 1, 1.5), spot, Color3.fromRGB(8, 8, 8), map, Enum.Material.Metal)
	local lampLight = Instance.new("SpotLight")
	lampLight.Range = 22
	lampLight.Brightness = 3
	lampLight.Angle = 55
	lampLight.Color = Color3.fromRGB(190, 255, 215)
	lampLight.Face = Enum.NormalId.Bottom
	lampLight.Parent = lamp
end

-- Ambient fog/lighting to match reference mood
game.Lighting.FogColor = Color3.fromRGB(15, 35, 25)
game.Lighting.FogStart = 15
game.Lighting.FogEnd = 130
game.Lighting.Brightness = 0.8
game.Lighting.Ambient = Color3.fromRGB(10, 25, 16)
game.Lighting.OutdoorAmbient = Color3.fromRGB(10, 25, 16)
game.Lighting.ColorShift_Bottom = Color3.fromRGB(20, 60, 40)

print("[gh-sync] Eco Lab map rebuilt with accurate layout: platform, tight spirals, catwalks, terminal clusters, crate stacks")