-- Silent Slayer 2 Lobby - Refined Detail Pass
local lobby = workspace:WaitForChild("LobbyStructure")

local detailFolder = Instance.new("Folder")
detailFolder.Name = "LobbyDetails"
detailFolder.Parent = lobby

local function part(name, size, pos, color, parent, material, transparency)
	local p = Instance.new("Part")
	p.Name = name
	p.Size = size
	p.Position = pos
	p.Anchored = true
	p.BrickColor = color or BrickColor.new("Medium stone grey")
	p.Material = material or Enum.Material.SmoothPlastic
	if transparency then p.Transparency = transparency end
	p.Parent = parent or detailFolder
	return p
end

-- Wood wall paneling (lower wall band, warm tone like reference)
part("Panel_Back", Vector3.new(120, 10, 0.5), Vector3.new(0, 5, -39.7), BrickColor.new("Cork"), detailFolder, Enum.Material.Wood)
part("Panel_Left", Vector3.new(0.5, 10, 80), Vector3.new(-59.7, 5, 0), BrickColor.new("Cork"), detailFolder, Enum.Material.Wood)
part("Panel_Right", Vector3.new(0.5, 10, 80), Vector3.new(59.7, 5, 0), BrickColor.new("Cork"), detailFolder, Enum.Material.Wood)

-- Hanging pendant light clusters (glass box style, like reference chandeliers)
local pendantSpots = {
	Vector3.new(-25, 27, -22),
	Vector3.new(25, 27, -22),
	Vector3.new(-45, 27, 5),
	Vector3.new(45, 27, 5),
}
for i, spot in ipairs(pendantSpots) do
	local rig = Instance.new("Model")
	rig.Name = "Pendant"..i
	rig.Parent = detailFolder

	local wire = part("Wire", Vector3.new(0.2, 4, 0.2), spot + Vector3.new(0, 2, 0), BrickColor.new("Really black"), rig, Enum.Material.Metal)

	-- cluster of 3 glass boxes per fixture, staggered height
	for j = 1, 3 do
		local off = Vector3.new((j - 2) * 1.5, -math.random(0, 15) / 10, 0)
		local glass = part("GlassBox"..j, Vector3.new(1.2, 1.5, 1.2), spot + off, BrickColor.new("Cyan"), rig, Enum.Material.Glass, 0.4)
		local light = Instance.new("PointLight")
		light.Range = 14
		light.Brightness = 1.5
		light.Color = Color3.fromRGB(150, 220, 255)
		light.Parent = glass
	end
end

-- Potted plants (scattered near walls and shop areas, like reference)
local plantSpots = {
	Vector3.new(-55, 3, -30), Vector3.new(55, 3, -30),
	Vector3.new(-55, 3, 10), Vector3.new(55, 3, 10),
	Vector3.new(-15, 3, -30), Vector3.new(30, 3, -32),
	Vector3.new(-50, 15, -25), Vector3.new(50, 15, -25), -- upper floor plants
}
for i, spot in ipairs(plantSpots) do
	local pot = part("PlantPot"..i, Vector3.new(2, 2, 2), spot, BrickColor.new("Reddish brown"), detailFolder, Enum.Material.Wood)
	local leaves = part("PlantLeaves"..i, Vector3.new(3, 3.5, 3), spot + Vector3.new(0, 2.5, 0), BrickColor.new("Forest green"), detailFolder, Enum.Material.Grass)
	leaves.Shape = Enum.PartType.Ball
end

-- Wooden crates near shop stalls (matches reference clutter)
local cratePositions = {
	Vector3.new(-38, 3, -14), Vector3.new(-36, 5, -14),
	Vector3.new(52, 3, -14), Vector3.new(15, 3, -18),
}
for i, pos in ipairs(cratePositions) do
	part("Crate"..i, Vector3.new(2.5, 2.5, 2.5), pos, BrickColor.new("Cork"), detailFolder, Enum.Material.Wood)
end

-- Rugs under seating area
local rug = part("Rug", Vector3.new(14, 0.2, 12), Vector3.new(42, 2.1, 10), BrickColor.new("Maroon"), detailFolder, Enum.Material.Fabric)

-- Glass panel inserts on staircase railings (upgrade from bare posts)
local stairFolder = lobby:FindFirstChild("Staircase")
if stairFolder then
	for i = 2, 16, 4 do
		local stepY = (i / 16) * 16
		local stepZ = -2 + (i / 16) * -14
		part("GlassPanelL"..i, Vector3.new(0.2, 2.5, 3), Vector3.new(-7, stepY + 1.25, stepZ), BrickColor.new("Institutional white"), stairFolder, Enum.Material.Glass, 0.6)
		part("GlassPanelR"..i, Vector3.new(0.2, 2.5, 3), Vector3.new(7, stepY + 1.25, stepZ), BrickColor.new("Institutional white"), stairFolder, Enum.Material.Glass, 0.6)
	end
end

-- Wall art frames (simple flat plates on back wall, like reference posters)
local frameSpots = {
	Vector3.new(-50, 20, -39.4), Vector3.new(-20, 20, -39.4),
	Vector3.new(20, 20, -39.4), Vector3.new(50, 20, -39.4),
}
for i, pos in ipairs(frameSpots) do
	part("ArtFrame"..i, Vector3.new(6, 4, 0.3), pos, BrickColor.new("Really black"), detailFolder, Enum.Material.Wood)
end

print("[gh-sync] Refined lobby details added: pendant lights, plants, crates, rugs, glass panels, wall art")