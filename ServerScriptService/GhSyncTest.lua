local part = Instance.new("Part")
part.Name = "GhSyncBlueBox"
part.Size = Vector3.new(4, 4, 4)
part.Position = Vector3.new(0, 10, 0)
part.Anchored = true
part.BrickColor = BrickColor.new("Bright blue")
part.Material = Enum.Material.Plastic
part.Parent = workspace

print("[gh-sync] Blue box spawned via GitHub pipeline")