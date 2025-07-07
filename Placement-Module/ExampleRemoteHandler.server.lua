
-- Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

-- Paths
local Remotes         = ReplicatedStorage.Remotes
local RemoteEvents    = Remotes.RemoteEvents
local PlacedObjects   = workspace.PlacedObjects
local Temp            = workspace.ServerTemp

-- Remotes
local PlaceRemote = RemoteEvents.Place


-- Functions
local function IsColliding(Part: Part, ColideFolders: {Folder})

	-- Params
	local OP = OverlapParams.new()
	OP.FilterType = Enum.RaycastFilterType.Include
	OP.FilterDescendantsInstances = ColideFolders

	local ColidingParts = workspace:GetPartsInPart(Part, OP)
	--print(ColidingParts)
	if #ColidingParts > 0 then

		return true

	end

	return false

end	

function GetModelPlacementY(ObjectModel: Model, Plot: Part)

	local Hitbox = ObjectModel.PrimaryPart

	local PlotYPos    = Plot.Position.Y
	local PlotHeight  = Plot.Size.Y
	local ModelHeight = Hitbox.Size.Y

	local YPos = PlotYPos + (PlotHeight / 2) + (ModelHeight / 2)

	return YPos

end

function GetModelXZOffsetFromPlot(ObjectModel: Model, Plot: Part)

	local HitBox = ObjectModel.PrimaryPart

	local HitBoxLocation = {["X"] = HitBox.Position.X, ["Z"] = HitBox.Position.Z}
	local PlotLocation   = {["X"] = Plot.Position.X, ["Z"] = Plot.Position.Z}

	local OffsetXZ = {["X"] = HitBoxLocation.X - PlotLocation.X, ["Z"] = HitBoxLocation.Z - PlotLocation.Z}

	--print(OffsetXZ)
	return OffsetXZ

end

function ConvertOffsetXZToLocation(Offset: {}, Plot: Part)

	local OffsetX: number = Offset.X
	local OffsetZ: number = Offset.Z

	local PlotX: number = Plot.Position.X
	local PlotZ: number = Plot.Position.Z

	local Location = {["X"] = PlotX + OffsetX, ["Z"] = PlotZ + OffsetZ}

	return Location

end

--print(ConvertOffsetXZToLocation({X = 50, Z = 47}, workspace.Plots.Plot1.Plot))

function IsModelInBounds(ObjectModel: Model, Plot: Part)

	local Offset  = GetModelXZOffsetFromPlot(ObjectModel, Plot)
	local RadiusX = Plot.Size.X / 2
	local RadiusZ = Plot.Size.Z / 2

	if math.abs(Offset.X) > RadiusX or math.abs(Offset.Z) > RadiusZ then

		return false

	else

		return true

	end

end

function Place(Player: Player, ObjectName: string, CurrentLocation: CFrame, CurrentRotation: number)

	local PlaceableObjects = ReplicatedStorage.PlaceableObjects.Objects
	local ObjectModelFolder: Folder = PlaceableObjects[ObjectName]
	local ObjectModel = ObjectModelFolder:FindFirstChildOfClass("Model"):Clone()
	local PlayerFolder = PlacedObjects[Player.Name]
	local Plot: Part = workspace.Plots.Plot1.Plot

	local S, E = pcall(function()

		ObjectModel.Parent = Temp
		ObjectModel:PivotTo(CurrentLocation)


		if IsColliding(ObjectModel.PrimaryPart, {PlacedObjects}) == true then

			ObjectModel:Destroy()

		else

			ObjectModel.Parent = PlayerFolder
			ObjectModel.PrimaryPart.Transparency = 1
			local SettingsFolder = Instance.new("Folder", ObjectModel)
			SettingsFolder.Name = "SettingsFolder"

			local Offset = GetModelXZOffsetFromPlot(ObjectModel, Plot)

			local ObjectNameStringValue = Instance.new("StringValue", SettingsFolder)
			ObjectNameStringValue.Name = "ObjectName"
			ObjectNameStringValue.Value = ObjectName
			local RotationValue = Instance.new("StringValue", SettingsFolder)
			RotationValue.Name = "Rotation"
			RotationValue.Value = CurrentRotation

			local OffsetX = Instance.new("IntValue", SettingsFolder)
			OffsetX.Name = "OffsetX"
			OffsetX.Value = Offset.X
			local OffsetZ = Instance.new("IntValue", SettingsFolder)
			OffsetZ.Name = "OffsetZ"
			OffsetZ.Value = Offset.Z


		end


		print(IsModelInBounds(ObjectModel, workspace.Plots.Plot1.Plot))
		-- print(CurrentLocation.LookVector)

	end)

	if not S then

		ObjectModel:Destroy()

	end

end


-- Connections
PlaceRemote.OnServerEvent:Connect(Place)
