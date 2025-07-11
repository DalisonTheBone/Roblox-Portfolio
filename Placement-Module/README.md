# Simple Placement Module
A simple-to-use module for placing objects in Roblox with animations and sound effects.

## Features
- Animations
- Sound Effects
- Plot System
- Grid System
- Collision System
- Ease of use

## Setup
**NOTE**: if your having problems check out the example place file.
1. **Setup Directory Locations**: Change the directorys of each variable that has this comment to have proper directorys.
  ```lua
  -- (Folder, Remote, Module) location
  ```
  - The TweenModel module must have its path properly set.
  - Under the SFX folder must have to sounds (Move, Place). These are the sound effects used for the movement and placement of objects.
2. **Setup Server Remote Handler**: Setup a script to actualy place things on the server (see ExampleRemoteHandler).
```lua
PlaceRemote.OnServerEvent:Connect(function(Player: Player, ObjectName: string, CurrentLocation: CFrame, CurrentRotation: number))
```
  - Script should be now set up

3. **Setting Up Player Folder**: Setting up the folder in the placed objects folder for the player.
   - in a server script write this code:
  ```lua
    
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
```
  - Replace the PlacedObjects directory with the path to the folder you have it in.
  - this script will add and remove the player folder witch contains the players placed objects.

    
5. **Adding a Model**: on line 53 of CPM where the objects folder is specified, go to that folder and do the following.
  - Add a folder
  - The name will be the ObjectName that will be used to place it
  - under that folder put the model of the object.
  - the name of the model can be anything
  - in the model you must add a part called "HitBox"
  - Size it so that the rest of the model fits inside of it
  - Set thaat part to be the models primary part.
  - The Model is now placeable.
  - Example File Structure:
```md
  --// File Structure \\--
  Objects: Folder/
  └── ObjectName: Folder/
      └── Model: Model/
          └── HitBox: PrimaryPart
```


## Usage
- Require The Module:
```lua
local CPM = require(Path.To.CPM.Module)
```
- Start Placment:
```lua
CPM:StartPlacement(ObjectName: string, Grid: number, Plot: Instance)
```
- Rotate, Place, EndPlacement:
```lua
CPM:Rotate()
CPM:Place()
CPM:EndPlacement()
```
- Example Script:
```lua
-- Module
local CPM = require(Path.To.CPM.Module)

-- Start placement of 'ObjectName' on grid 4 in the 'Plot' workspace
CPM:StartPlacement("ObjectName", 4, workspace.Plot)

-- Rotate the object
CPM:Rotate()

-- Place the object
CPM:Place()

-- End the placement
CPM:EndPlacement()

```
