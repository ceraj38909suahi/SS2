-- Silent Slayer 2 Lobby Generator (core structure only)
local lobby = Instance.new("Folder")
lobby.Name = "LobbyStructure"
lobby.Parent = workspace

local function part(name, size, pos, color, parent, material)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Anchored = true
	p.BrickColor = color or BrickColor.new("Medium stone grey")
	p.Material = material or Enum.Material.SmoothPlastic
	p.Parent = parent or lobby
	return p
end

-- Floor (ground)
part("GroundFloor", Vector3.new(120, 2, 80), Vector3.new(0, 0, 0), BrickColor.new("Dark stone grey"), lobby, Enum.Material.Concrete)

-- Upper floor / balcony ring (leaves open atrium in the middle)
local upperY = 16
part("UpperFloor_Back", Vector3.new(120, 2, 20), Vector3.new(0, upperY, -30), BrickColor.new("Dark stone grey"), lobby, Enum.Material.Concrete)
part("UpperFloor_Left", Vector3.new(30, 2, 40), Vector3.new(-45, upperY, 0), BrickColor.new("Dark stone grey"), lobby, Enum.Material.Concrete)
part("UpperFloor_Right", Vector3.new(30, 2, 40), Vector3.new(45, upperY, 0), BrickColor.new("Dark stone grey"), lobby, Enum.Material.Concrete)

-- Outer walls
part("Wall_Back", Vector3.new(120, 32, 2), Vector3.new(0, 16, -40), BrickColor.new("Institutional white"), lobby, Enum.Material.SmoothPlastic)
part("Wall_Left", Vector3.new(2, 32, 80), Vector3.new(-60, 16, 0), BrickColor.new("Institutional white"), lobby, Enum.Material.SmoothPlastic)
part("Wall_Right", Vector3.new(2, 32, 80), Vector3.new(60, 16, 0), BrickColor.new("Institutional white"), lobby, Enum.Material.SmoothPlastic)
part("Wall_Front", Vector3.new(120, 32, 2), Vector3.new(0, 16, 40), BrickColor.new("Institutional white"), lobby, Enum.Material.SmoothPlastic)

-- Ceiling
part("Ceiling", Vector3.new(120, 2, 80), Vector3.new(0, 32, 0), BrickColor.new("Really black"), lobby, Enum.Material.Metal)

-- Central staircase (stepped blocks going up to upper floor)
local stairFolder = Instance.new("Folder")
stairFolder.Name = "Staircase"
stairFolder.Parent = lobby
local steps = 16
for i = 1, steps do
	local stepY = (i / steps) * upperY
	local stepZ = -2 + (i / steps) * -14
	part("Step"..i, Vector3.new(14, 1, 2), Vector3.new(0, stepY, stepZ), BrickColor.new("Brown"), stairFolder, Enum.Material.Wood)
end

-- Railing posts along staircase (simple)
for i = 1, steps, 2 do
	local stepY = (i / steps) * upperY
	local stepZ = -2 + (i / steps) * -14
	part("RailL"..i, Vector3.new(0.5, 3, 0.5), Vector3.new(-7, stepY + 1.5, stepZ), BrickColor.new("Really black"), stairFolder, Enum.Material.Metal)
	part("RailR"..i, Vector3.new(0.5, 3, 0.5), Vector3.new(7, stepY + 1.5, stepZ), BrickColor.new("Really black"), stairFolder, Enum.Material.Metal)
end

-- Balcony railings (upper floor edge facing atrium)
part("BalconyRail_Left", Vector3.new(1, 3, 40), Vector3.new(-30, upperY + 1.5, 0), BrickColor.new("Really black"), lobby, Enum.Material.Metal)
part("BalconyRail_Right", Vector3.new(1, 3, 40), Vector3.new(30, upperY + 1.5, 0), BrickColor.new("Really black"), lobby, Enum.Material.Metal)
part("BalconyRail_Back", Vector3.new(60, 3, 1), Vector3.new(0, upperY + 1.5, -20), BrickColor.new("Really black"), lobby, Enum.Material.Metal)

-- Shop stall bases (simple block placeholders, ground floor)
local shopFolder = Instance.new("Folder")
shopFolder.Name = "ShopStalls"
shopFolder.Parent = lobby

local shopData = {
	{name = "WeaponSmithy", pos = Vector3.new(-45, 4, -20), color = "Reddish brown"},
	{name = "VanityVestments", pos = Vector3.new(20, 4, -25), color = "Brown"},
	{name = "GearGarage", pos = Vector3.new(45, 4, -20), color = "Dark stone grey"},
}
for _, shop in ipairs(shopData) do
	local base = part(shop.name.."_Counter", Vector3.new(12, 6, 3), shop.pos, BrickColor.new(shop.color), shopFolder, Enum.Material.Wood)
	local sign = Instance.new("Part")
	sign.Name = shop.name.."_Sign"
	sign.Size = Vector3.new(10, 2, 0.5)
	sign.Position = shop.pos + Vector3.new(0, 5, 0)
	sign.Anchored = true
	sign.BrickColor = BrickColor.new("Really black")
	sign.Material = Enum.Material.SmoothPlastic
	sign.Parent = shopFolder

	local gui = Instance.new("SurfaceGui")
	gui.Face = Enum.NormalId.Front
	gui.Parent = sign
	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = shop.name
	label.TextScaled = true
	label.TextColor3 = Color3.new(1, 1, 1)
	label.Font = Enum.Font.GothamBold
	label.Parent = gui
end

-- Seating area (couches as simple blocks, right side ground floor)
local seatFolder = Instance.new("Folder")
seatFolder.Name = "SeatingArea"
seatFolder.Parent = lobby
part("Couch1", Vector3.new(10, 3, 4), Vector3.new(40, 2.5, 15), BrickColor.new("Reddish brown"), seatFolder, Enum.Material.Fabric)
part("Couch2", Vector3.new(4, 3, 10), Vector3.new(46, 2.5, 5), BrickColor.new("Reddish brown"), seatFolder, Enum.Material.Fabric)
part("CoffeeTable", Vector3.new(4, 1.5, 4), Vector3.new(40, 1.75, 6), BrickColor.new("Really black"), seatFolder, Enum.Material.Wood)

-- Central logo placeholder (billboard-style part where "SILENT SLAYER 2" sign would go)
local logoPart = part("LogoSign", Vector3.new(30, 10, 1), Vector3.new(0, 22, -39), BrickColor.new("Really black"), lobby, Enum.Material.Metal)
local logoGui = Instance.new("SurfaceGui")
logoGui.Face = Enum.NormalId.Front
logoGui.Parent = logoPart
local logoLabel = Instance.new("TextLabel")
logoLabel.Size = UDim2.new(1, 0, 1, 0)
logoLabel.BackgroundTransparency = 1
logoLabel.Text = "SILENT SLAYER 2"
logoLabel.TextScaled = true
logoLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
logoLabel.Font = Enum.Font.GothamBlack
logoLabel.Parent = logoGui

-- Spawn locations
local spawnFolder = Instance.new("Folder")
spawnFolder.Name = "Spawns"
spawnFolder.Parent = lobby
for i = 1, 6 do
	local sp = Instance.new("SpawnLocation")
	sp.Name = "Spawn"..i
	sp.Size = Vector3.new(6, 1, 6)
	sp.Position = Vector3.new(-30 + (i * 10), 1.5, 25)
	sp.Anchored = true
	sp.CanCollide = true
	sp.Transparency = 0.7
	sp.BrickColor = BrickColor.new("Bright blue")
	sp.Parent = spawnFolder
end

print("[gh-sync] Lobby core structure generated: floors, walls, staircase, balcony, stalls, seating, spawns")