-- Silent Slayer 2 - Eco Lab Map v4 (expanded: 12 small rooms + 2 big rooms, MM2-style layout, particle FX)
local old = workspace:FindFirstChild("EcoLabMap")
if old then old:Destroy() end

local map = Instance.new("Folder")
map.Name = "EcoLabMap"
map.Parent = workspace

local MAP_OFFSET = Vector3.new(0, 0, 1200)

local function part(name, size, pos, color, parent, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos + MAP_OFFSET
	p.Anchored = true
	p.Color = color or Color3.fromRGB(40, 45, 40)
	p.Material = material or Enum.Material.Metal
	if transparency then p.Transparency = transparency end
	p.Parent = parent or map
	return p
end

-- ===== GROUND FLOOR (much bigger) =====
part("GroundFloor", Vector3.new(220, 2, 220), Vector3.new(0, 0, 0), Color3.fromRGB(26, 30, 28), map, Enum.Material.Concrete)

-- Outer walls (expanded)
part("Wall_N", Vector3.new(220, 40, 2), Vector3.new(0, 20, -110), Color3.fromRGB(20, 24, 22), map, Enum.Material.Metal)
part("Wall_S", Vector3.new(220, 40, 2), Vector3.new(0, 20, 110), Color3.fromRGB(20, 24, 22), map, Enum.Material.Metal)
part("Wall_E", Vector3.new(2, 40, 220), Vector3.new(110, 20, 0), Color3.fromRGB(20, 24, 22), map, Enum.Material.Metal)
part("Wall_W", Vector3.new(2, 40, 220), Vector3.new(-110, 20, 0), Color3.fromRGB(20, 24, 22), map, Enum.Material.Metal)
part("Ceiling", Vector3.new(220, 2, 220), Vector3.new(0, 40, 0), Color3.fromRGB(10, 12, 11), map, Enum.Material.Metal)

-- Raised octagonal platform under tower
local platformFolder = Instance.new("Folder")
platformFolder.Name = "CenterPlatform"
platformFolder.Parent = map
part("PlatformCore", Vector3.new(26, 0.6, 26), Vector3.new(0, 1.3, 0), Color3.fromRGB(48, 52, 48), platformFolder, Enum.Material.DiamondPlate)

-- ===== CENTRAL CONTAINMENT TOWER =====
local towerFolder = Instance.new("Folder")
towerFolder.Name = "ContainmentTower"
towerFolder.Parent = map

local towerRadius = 9
local towerHeight = 30
local towerBase = Instance.new("Part")
towerBase.Name = "TowerGlass"
towerBase.Shape = Enum.PartType.Cylinder
towerBase.Size = Vector3.new(2, towerRadius * 2, towerRadius * 2)
towerBase.Orientation = Vector3.new(0, 0, 90)
towerBase.Position = Vector3.new(0, 2 + towerHeight/2, -6) + MAP_OFFSET
towerBase.Anchored = true
towerBase.Material = Enum.Material.Glass
towerBase.Color = Color3.fromRGB(130, 255, 210)
towerBase.Transparency = 0.5
towerBase.Parent = towerFolder

local towerLight = Instance.new("PointLight")
towerLight.Range = 55
towerLight.Brightness = 6
towerLight.Color = Color3.fromRGB(100, 255, 180)
towerLight.Parent = towerBase

local trunk = part("TreeTrunk", Vector3.new(2.2, 20, 2.2), Vector3.new(0, 12, -6), Color3.fromRGB(55, 42, 32), towerFolder, Enum.Material.Wood)
for i = 1, 8 do
	local angle = (i / 8) * math.pi * 2
	local bx = math.cos(angle) * 2.5
	local bz = -6 + math.sin(angle) * 2.5
	part("Branch"..i, Vector3.new(0.8, 5.5, 0.8), Vector3.new(bx, 13 + i * 0.8, bz), Color3.fromRGB(55, 42, 32), towerFolder, Enum.Material.Wood)
end
local canopy = part("Canopy", Vector3.new(8, 8, 8), Vector3.new(0, 24, -6), Color3.fromRGB(70, 230, 130), towerFolder, Enum.Material.Neon)
canopy.Shape = Enum.PartType.Ball
canopy.Transparency = 0.15
local canopyLight = Instance.new("PointLight")
canopyLight.Range = 30
canopyLight.Brightness = 4
canopyLight.Color = Color3.fromRGB(90, 255, 160)
canopyLight.Parent = canopy

-- Spore/glow particles rising from the canopy (real particle effect)
local canopyAttach = Instance.new("Attachment")
canopyAttach.Parent = canopy
local spores = Instance.new("ParticleEmitter")
spores.Texture = "rbxasset://textures/particles/sparkles_main.dds"
spores.Color = ColorSequence.new(Color3.fromRGB(140, 255, 190))
spores.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.3), NumberSequenceKeypoint.new(1, 0.05)})
spores.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.2), NumberSequenceKeypoint.new(1, 1)})
spores.Lifetime = NumberRange.new(3, 6)
spores.Rate = 15
spores.Speed = NumberRange.new(1, 3)
spores.SpreadAngle = Vector2.new(180, 180)
spores.Acceleration = Vector3.new(0, 2, 0)
spores.Parent = canopyAttach

-- Spiral staircases hugging tower
local function buildSpiral(name, side)
	local stairFolder = Instance.new("Folder")
	stairFolder.Name = name
	stairFolder.Parent = towerFolder
	local steps = 24
	local radius = towerRadius + 4
	for i = 1, steps do
		local angle = (i / steps) * math.pi * 1.7 * side + (side > 0 and 0 or math.pi)
		local sx = math.cos(angle) * radius
		local sz = -6 + math.sin(angle) * radius
		local sy = 2 + (i / steps) * 20
		part("Step"..i, Vector3.new(2.6, 0.4, 2.6), Vector3.new(sx, sy, sz), Color3.fromRGB(40, 44, 42), stairFolder, Enum.Material.DiamondPlate)
	end
end
buildSpiral("SpiralStairs_Left", 1)
buildSpiral("SpiralStairs_Right", -1)

-- Banner
local banner = part("EcoLabBanner", Vector3.new(4, 18, 0.3), Vector3.new(0, 24, -20), Color3.fromRGB(12, 35, 24), map, Enum.Material.Fabric)
local bannerGui = Instance.new("SurfaceGui")
bannerGui.Face = Enum.NormalId.Front
bannerGui.Parent = banner
local bannerLabel = Instance.new("TextLabel")
bannerLabel.Size = UDim2.new(1, 0, 1, 0)
bannerLabel.BackgroundTransparency = 1
bannerLabel.Text = "ECO\nLAB"
bannerLabel.TextScaled = true
bannerLabel.TextColor3 = Color3.fromRGB(150, 255, 200)
bannerLabel.Font = Enum.Font.GothamBlack
bannerLabel.Parent = bannerGui

-- ===== UPPER CATWALK RING (MM2-style: small rooms branch off it) =====
local catwalkY = 20
local catwalkRadius = 55
local catwalkFolder = Instance.new("Folder")
catwalkFolder.Name = "Catwalk"
catwalkFolder.Parent = map

local catwalkSegments = 16
for i = 1, catwalkSegments do
	local angle = (i / catwalkSegments) * math.pi * 2
	local cx = math.cos(angle) * catwalkRadius
	local cz = math.sin(angle) * catwalkRadius
	part("CatwalkSeg"..i, Vector3.new(14, 1, 14), Vector3.new(cx, catwalkY, cz), Color3.fromRGB(32, 36, 34), catwalkFolder, Enum.Material.DiamondPlate)
end

-- Connector bridges from tower area up to catwalk (4 access points)
local bridgeAngles = {0, math.pi/2, math.pi, math.pi*1.5}
for i, angle in ipairs(bridgeAngles) do
	local steps = 10
	for s = 1, steps do
		local t = s / steps
		local radius = t * catwalkRadius
		local bx = math.cos(angle) * radius
		local bz = math.sin(angle) * radius
		local by = 2 + t * (catwalkY - 2)
		part("Bridge"..i.."_"..s, Vector3.new(6, 0.5, 6), Vector3.new(bx, by, bz), Color3.fromRGB(35, 39, 37), catwalkFolder, Enum.Material.DiamondPlate)
	end
end

-- ===== 12 SMALL ROOMS branching off the catwalk ring =====
local smallRoomFolder = Instance.new("Folder")
smallRoomFolder.Name = "SmallRooms"
smallRoomFolder.Parent = map

local smallRoomThemes = {
	{name = "StorageA", color = Color3.fromRGB(70, 65, 40)},
	{name = "StorageB", color = Color3.fromRGB(70, 65, 40)},
	{name = "SampleRoom", color = Color3.fromRGB(40, 70, 60)},
	{name = "ServerRoom", color = Color3.fromRGB(40, 50, 70)},
	{name = "BreakRoom", color = Color3.fromRGB(70, 50, 40)},
	{name = "Greenhouse1", color = Color3.fromRGB(40, 80, 45)},
	{name = "Greenhouse2", color = Color3.fromRGB(40, 80, 45)},
	{name = "ChemLab", color = Color3.fromRGB(70, 40, 70)},
	{name = "Office1", color = Color3.fromRGB(55, 55, 55)},
	{name = "Office2", color = Color3.fromRGB(55, 55, 55)},
	{name = "VentRoom", color = Color3.fromRGB(45, 45, 50)},
	{name = "Observation", color = Color3.fromRGB(45, 65, 70)},
}

for i, theme in ipairs(smallRoomThemes) do
	local angle = (i / #smallRoomThemes) * math.pi * 2
	local roomRadius = catwalkRadius + 18
	local rx = math.cos(angle) * roomRadius
	local rz = math.sin(angle) * roomRadius

	local roomModel = Instance.new("Model")
	roomModel.Name = "Room_"..theme.name
	roomModel.Parent = smallRoomFolder

	part("Floor", Vector3.new(16, 1, 16), Vector3.new(rx, catwalkY, rz), theme.color, roomModel, Enum.Material.Concrete)
	part("WallBack", Vector3.new(16, 10, 1), Vector3.new(rx + math.cos(angle)*8, catwalkY + 5, rz + math.sin(angle)*8), theme.color, roomModel, Enum.Material.Metal)
	part("WallLeft", Vector3.new(1, 10, 16), Vector3.new(rx - math.sin(angle)*8, catwalkY + 5, rz + math.cos(angle)*8), theme.color, roomModel, Enum.Material.Metal)
	part("WallRight", Vector3.new(1, 10, 16), Vector3.new(rx + math.sin(angle)*8, catwalkY + 5, rz - math.cos(angle)*8), theme.color, roomModel, Enum.Material.Metal)
	part("Ceiling", Vector3.new(16, 1, 16), Vector3.new(rx, catwalkY + 10, rz), theme.color, roomModel, Enum.Material.Metal)

	local light = Instance.new("PointLight")
	light.Range = 16
	light.Brightness = 2
	light.Color = theme.color
	local lightPart = part("Light", Vector3.new(1,1,1), Vector3.new(rx, catwalkY + 8, rz), Color3.new(1,1,1), roomModel, Enum.Material.Neon, 0.3)
	light.Parent = lightPart

	-- connector segment linking room to catwalk ring
	part("Connector", Vector3.new(6, 1, 8), Vector3.new(rx - math.cos(angle)*10, catwalkY, rz - math.sin(angle)*10), theme.color, roomModel, Enum.Material.DiamondPlate)
end

-- ===== 2 BIG ROOMS at ground level, opposite ends =====
local bigRoomFolder = Instance.new("Folder")
bigRoomFolder.Name = "BigRooms"
bigRoomFolder.Parent = map

local function buildBigRoom(name, centerZ, color)
	local model = Instance.new("Model")
	model.Name = name
	model.Parent = bigRoomFolder

	part("Floor", Vector3.new(60, 1, 50), Vector3.new(0, 1, centerZ), color, model, Enum.Material.Concrete)
	part("WallFar", Vector3.new(60, 22, 1), Vector3.new(0, 11, centerZ + (centerZ > 0 and 25 or -25)), color, model, Enum.Material.Metal)
	part("WallLeft", Vector3.new(1, 22, 50), Vector3.new(-30, 11, centerZ), color, model, Enum.Material.Metal)
	part("WallRight", Vector3.new(1, 22, 50), Vector3.new(30, 11, centerZ), color, model, Enum.Material.Metal)
	part("Ceiling", Vector3.new(60, 1, 50), Vector3.new(0, 22, centerZ), color, model, Enum.Material.Metal)

	-- wide walkway connecting back to tower/platform
	local steps = 12
	for s = 1, steps do
		local t = s / steps
		local z = t * centerZ
		part("Walkway"..s, Vector3.new(10, 0.5, 10), Vector3.new(0, 1.5, z), color, model, Enum.Material.DiamondPlate)
	end

	for i = 1, 4 do
		local lightPart = part("Light"..i, Vector3.new(1.5,1,1.5), Vector3.new(-20 + i*13, 18, centerZ), Color3.new(1,1,1), model, Enum.Material.Neon, 0.2)
		local light = Instance.new("SpotLight")
		light.Range = 30
		light.Brightness = 3
		light.Angle = 70
		light.Color = Color3.fromRGB(150, 255, 200)
		light.Face = Enum.NormalId.Bottom
		light.Parent = lightPart
	end
end

buildBigRoom("MainLab", 90, Color3.fromRGB(35, 60, 45))
buildBigRoom("StorageBay", -90, Color3.fromRGB(45, 50, 40))

-- Large crate stacks in the big rooms
local crateFolder = Instance.new("Folder")
crateFolder.Name = "Crates"
crateFolder.Parent = map
for i = 1, 10 do
	local x = -20 + (i % 5) * 10
	local z = -90 + math.floor((i-1)/5) * 8
	part("StorageCrate"..i, Vector3.new(3, 3, 3), Vector3.new(x, 3, z), Color3.fromRGB(85, 95, 45), crateFolder, Enum.Material.Metal)
end

-- ===== SPAWN =====
local ecoSpawn = Instance.new("SpawnLocation")
ecoSpawn.Name = "EcoLabSpawn"
ecoSpawn.Size = Vector3.new(6, 1, 6)
ecoSpawn.Position = Vector3.new(0, 2, 20) + MAP_OFFSET
ecoSpawn.Anchored = true
ecoSpawn.CanCollide = true
ecoSpawn.Transparency = 0.6
ecoSpawn.Color = Color3.fromRGB(90, 255, 160)
ecoSpawn.Parent = map

for _, obj in ipairs(workspace:GetDescendants()) do
	if obj:IsA("SpawnLocation") and obj ~= ecoSpawn then
		obj.Enabled = false
	end
end

-- ===== ATMOSPHERE: mist + floating dust particles across the map =====
local mistSpots = {
	Vector3.new(0, 2, 0), Vector3.new(-40, 2, 40), Vector3.new(40, 2, -40),
	Vector3.new(0, 2, 90), Vector3.new(0, 2, -90),
}
for i, spot in ipairs(mistSpots) do
	local mistAnchor = part("MistAnchor"..i, Vector3.new(1,1,1), spot, Color3.new(1,1,1), map, Enum.Material.Neon, 1)
	mistAnchor.CanCollide = false
	local attach = Instance.new("Attachment")
	attach.Parent = mistAnchor
	local mist = Instance.new("ParticleEmitter")
	mist.Texture = "rbxasset://textures/particles/smoke_main.dds"
	mist.Color = ColorSequence.new(Color3.fromRGB(60, 90, 75))
	mist.Size = NumberSequence.new({NumberSequenceKeypoint.new(0, 4), NumberSequenceKeypoint.new(1, 10)})
	mist.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.75), NumberSequenceKeypoint.new(1, 1)})
	mist.Lifetime = NumberRange.new(8, 14)
	mist.Rate = 4
	mist.Speed = NumberRange.new(0.3, 1)
	mist.SpreadAngle = Vector2.new(360, 360)
	mist.Parent = attach
end

-- Floating dust motes throughout the main hall
local dustAnchor = part("DustAnchor", Vector3.new(1,1,1), Vector3.new(0, 15, 0), Color3.new(1,1,1), map, Enum.Material.Neon, 1)
dustAnchor.CanCollide = false
local dustAttach = Instance.new("Attachment")
dustAttach.Parent = dustAnchor
local dust = Instance.new("ParticleEmitter")
dust.Texture = "rbxasset://textures/particles/sparkles_main.dds"
dust.Color = ColorSequence.new(Color3.fromRGB(150, 200, 180))
dust.Size = NumberSequence.new(0.08)
dust.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.5), NumberSequenceKeypoint.new(1, 1)})
dust.Lifetime = NumberRange.new(10, 20)
dust.Rate = 20
dust.Speed = NumberRange.new(0.2, 0.6)
dust.SpreadAngle = Vector2.new(180, 180)
dust.Parent = dustAttach

-- Global fog/ambient
game.Lighting.FogColor = Color3.fromRGB(14, 32, 24)
game.Lighting.FogStart = 20
game.Lighting.FogEnd = 180
game.Lighting.Brightness = 0.75
game.Lighting.Ambient = Color3.fromRGB(10, 24, 16)
game.Lighting.OutdoorAmbient = Color3.fromRGB(10, 24, 16)

print("[gh-sync] EcoLabMap_v4 loaded - 12 small rooms + 2 big rooms, catwalk ring, particle FX active")
