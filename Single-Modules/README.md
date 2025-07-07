# Single Modules
A colection of modules that work by them selves.

# Docs
Documentation for the modules.

## BadgeHandler
```lua
local BadgeHandler = require(Path.To.BadgeHandler.Module)

BadgeHandler:CanAwardBadge(BadgeId: number): boolean
-- Checks if a badge can be awarded via badgeid and returns a boolean.
	 
BadgeHandler:PlayerHasBadge(Player: Player, BadgeId: number): boolean
-- Checks if a specified player has a badge and returns a boolean.

BadgeHandler:AwardPlayer(Player: Player, BadgeId: number): nil
-- Awards a badge to a given player.
	 
BadgeHandler:AwardServer(BadgeId: number): nil
-- Awards a badge to every player in the server.
```
