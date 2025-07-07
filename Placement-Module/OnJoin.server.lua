
-- Services
local Players = game:GetService("Players")

-- Paths
local PlacedObjects = workspace.PlacedObjects

-- Functions
function OnPlayerJoin(Player: Player)
	
	local PlayerFolder = Instance.new("Folder")
	PlayerFolder.Name = Player.Name
	PlayerFolder.Parent = PlacedObjects
	
end

function OnPlayerLeave(Player: Player)
	
	PlacedObjects[Player.Name]:Destroy()
	
end

-- Events
Players.PlayerAdded:Connect(OnPlayerJoin)
Players.PlayerRemoving:Connect(OnPlayerLeave)
