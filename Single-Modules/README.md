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
## Yen
**Modifying Currencys:**
```lua
 -- To add a currency simply make a new table inside of "Currency" as follows
["CurrencyName"] = {

	["StartingAmmount"] = 0;  -- This is how much of the currency a player will start with
	["Sign"]            = "$" -- This is the sign that will apear at the front of the currency when displayed.

};
 -- To remove a currency, simply remove the table for that currency
 ```
**Methods:**
```lua
 SetupPlayerFolder(Player: Player): Folder
 -- This creates the folder that contains all of the players currencys. It then returns that folder.
 
 GetPlayerFolder(Player: Player): Folder
 -- This simply returns the players currency folder.
 
 
 GetCurrencyAmount(PlayerFolder: Folder, CurrencyName: string): number
 -- This will return the ammount of a currency you have by providing a CurrencyFolder and a CurrencyName
 
 SetPlayerCurrency(CurrencyName: string, Amount: number): string
 -- It will set a players currency to a amount specified
 
 GetDisplayNumber(CurrencyName: string, Amount: number): string
 -- This will return a string containing a number that will be displayed
 -- Ex: GetDisplayNumber("Yen", 12000) = ¥12.00K
```
