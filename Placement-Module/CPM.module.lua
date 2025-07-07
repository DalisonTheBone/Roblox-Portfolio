local CPM = {}

--[[--

 -- CPM Added Fetures Tracker --

Main Functions | 4/4
 - Start Placement Function = true
 - End Placement Function   = true
 - Rotate Function          = true
 - Place Function           = true

Tween Animations | 2/2
 - Move Animation   = true
 - Rotate Animation = true

SFX | 2/2
 - Move/Rotate SFX = true
 - Place SFX       = true

Color Change | 3/3
 - Have Green Outline When Placeable   = true
 - Have Red Outline When Not Placeable = true
 - Turn Red Before Ending Placement    = true
 
Other | 3/3
 - Snap To Grid = true
 - Plot System  = true
 - Collison     = true

Total | 14/14

--]]--


-- Services
local Players           = game:GetService("Players")
local Workspace         = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")

-- Variables
local PlacementSettings = {
	
	["PlacementModeActive"] = false;
	["PlacementObject"]     = ""   ;
	
}

local LocalPlayer      = Players.LocalPlayer
local PlaceableObjects = ReplicatedStorage.PlaceableObjects
local Objects          = PlaceableObjects.Objects
local Temp             = Workspace.Temp
local PlacedObjects    = Workspace.PlacedObjects
local Camera           = Workspace.CurrentCamera
local Modules          = ReplicatedStorage.Modules
local CurrentRotation  = 0
local Remotes          = ReplicatedStorage.Remotes
local Sounds           = ReplicatedStorage.SFX
local SoundNotPlaying  = true

local ObjectModel: Model
local CurrentLocation
local CurrentLocation2

-- Remotes
local PlaceRemote = Remotes.RemoteEvents.Place

-- Modules
local TweenModel = require(Modules.TweenModel)

-- Functions
function CPM:StartPlacement(ObjectName: string, Grid: number, Plot: Instance) 
	task.spawn(function()
		
		PlacementSettings.PlacementModeActive = true
		PlacementSettings.PlacementObject = ObjectName

		local ObjectFolder: Folder = Objects[ObjectName]
		ObjectModel = ObjectFolder:FindFirstChildOfClass("Model"):Clone()
		ObjectModel.Parent = Temp
		ObjectModel:PivotTo(CFrame.new(0, -10, 0))
		local HitBox = ObjectModel.PrimaryPart
		local AmmountOfCollisions = 0
		
		task.spawn(function()
			
			for i,v in pairs(ObjectModel:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
				if i%25 == 0 then
					
					task.wait()
					
				end
			end
			
		end)
		

		function IsColliding(Part: Part, ColideFolders: {Folder})

			-- Params
			local OP = OverlapParams.new()
			OP.FilterType = Enum.RaycastFilterType.Include
			OP.FilterDescendantsInstances = ColideFolders

			local ColidingParts = workspace:GetPartsInPart(Part, OP)

			if #ColidingParts > 0 then

				return true

			end

			return false

		end	

		-- Functions
		local function AlignToGrid(Grid: number, X: number, Z: number)

			return X - X%Grid, Z - Z%Grid

		end

		local function GetPlacementXYZ(Grid: number, Object: Model, Plot: Part) -- require(game.StarterGui.CPM):StartPlacement("TestName", 1, workspace.Plots.Plot1.Plot)

			local HitBox: Part = Object.PrimaryPart

			-- Raycast
			local ScreenMouseLocation = UserInputService:GetMouseLocation()
			local UnitRay = Camera:ViewportPointToRay(ScreenMouseLocation.X, ScreenMouseLocation.Y)
			local CastParams = RaycastParams.new()
			if Plot then

				CastParams.FilterType = Enum.RaycastFilterType.Include
				CastParams.FilterDescendantsInstances = {
					Plot.Parent;
				}

			else

				CastParams.FilterType = Enum.RaycastFilterType.Exclude
				CastParams.FilterDescendantsInstances = {
					Temp;
					LocalPlayer.Character;
				}

			end

			local RayCast = Workspace:Raycast(UnitRay.Origin, UnitRay.Direction * 1000, CastParams)

			if RayCast then

				local MousePos = RayCast.Position


				local Y = RayCast.Instance.Position.Y + (RayCast.Instance.Size.Y / 2) + (HitBox.Size.Y / 2 )
				local X, Z = AlignToGrid(Grid, MousePos.X, MousePos.Z)
				if CurrentLocation2 ~= CFrame.new(X, Y, Z) then
					task.spawn(function()
						if SoundNotPlaying then
							SoundNotPlaying = false
							Sounds.Move:Play()
							Sounds.Move.Ended:Connect(function()

								SoundNotPlaying = true

							end)

						end
					end)
				end
				CurrentLocation2 = CFrame.new(X, Y, Z)
				return CFrame.new(X, Y, Z)

			end

		end


		local function Move(AnimationSpeed: number)

			if ObjectModel:GetPivot() ~= GetPlacementXYZ(Grid, ObjectModel, Plot) then

				local cf = GetPlacementXYZ(Grid, ObjectModel, Plot)

				if cf then

					local Info = TweenInfo.new(AnimationSpeed)
					TweenModel:Tween(ObjectModel, Info, cf * CFrame.Angles(0, math.rad(CurrentRotation), 0))


					CurrentLocation = cf * CFrame.Angles(0, math.rad(CurrentRotation), 0)

				end



			end

		end

		function EndPlacement()

			ObjectModel.PrimaryPart.Color = Color3.fromRGB(255, 0, 4)
			task.wait(0.2)
			ObjectModel:Destroy()
			PlacementSettings.PlacementObject = ""
			print("Ended")

		end
		
		local function NotHoveringInGui()
			
			local PlayerGui = Players.LocalPlayer.PlayerGui
			local ScreenMousePos = UserInputService:GetMouseLocation()
			local GuiAtPos = PlayerGui:GetGuiObjectsAtPosition(ScreenMousePos.X, ScreenMousePos.Y)
			
			if #GuiAtPos < 2 then
				
				return true
				
			end
			
			return false
			
		end

		while task.wait() do
			
			--task.spawn(function()
			if PlacementSettings.PlacementModeActive then
				
				if NotHoveringInGui() then
					
					Move(0.3)

					if IsColliding(HitBox, {PlacedObjects}) then

						HitBox.Color = Color3.fromRGB(255, 0, 4)

					else

						HitBox.Color = Color3.fromRGB(0, 255, 17)

					end
					
				end
					
			else
					
				break
					
			end

			--end)

		end
		
	end)
	
end

function CPM:Place()
	
	if not IsColliding(ObjectModel.PrimaryPart, {PlacedObjects}) then
		
		PlaceRemote:FireServer(PlacementSettings.PlacementObject, CurrentLocation, CurrentRotation)
		
		task.spawn(function()
			
			Sounds.Place:Play()
			
		end)
		
	end
	
end

function CPM:Rotate(Plot: Part)
	
	CurrentRotation = ((CurrentRotation + 90)%360)
	--print(CurrentRotation)
	
end

function CPM:EndPlacement()
	print(2)
	PlacementSettings.PlacementModeActive = false
	pcall(function()
		
		EndPlacement()
		
	end)
	
	
end

return CPM
-- workspace.Chair:PivotTo(workspace.Chair:GetPivot() * CFrame.Angles(0, math.rad(90), 0))
