--[[--

 -- Name: Yen
 -- Created By: DalaisonTheBone
 -- Status: Completed
 -- If something breaks please contact me.
 
 -- Documentation --
 
Description: This module handles the game's currency. This module handles getting, setting, displaying and creating new currencys.


Adding / Removing Currencys:
 -- To add a currency simply make a new table inside of "Currency" as follows
["CurrencyName"] = {

	["StartingAmmount"] = 0;  -- This is how much of the currency a player will start with
	["Sign"]            = "$" -- This is the sign that will apear at the front of the currency when displayed.

};
 -- To remove a currency, simply remove the table for that currency
 
 
Methods:
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

--]]--

local Yen = {
	
	["Currency"] = {
		["Yen"] = {
			
			["StartingAmmount"] = 0;
			["Sign"]            = "¥";
			
		};
	};
	
}

-- Functions
function Abbreviate(Number: number): string
	
	local SplitNumber = string.split(tostring(Number), "")
	local Length      = #SplitNumber
	
	local Abbreviations = {
		
		["0"]  = "";
		["3"]  = "K";
		["6"]  = "M";
		["9"]  = "B";
		["12"] = "T";
		["15"] = "Qa";
		
	}
	
	local Abbreviation = Abbreviations[tostring( ((Length - 1) - ((Length - 1)%3)) )]
	
	local AmountToShow = Length - ((Length - 1) - ((Length - 1)%3))
	
	local NewNumber = ""
	
	for i = 1, AmountToShow do
		
		NewNumber = NewNumber .. SplitNumber[i]
		
	end
	
	if Length > 3 then
		
		NewNumber = NewNumber .. "." .. SplitNumber[AmountToShow + 1] .. SplitNumber[AmountToShow + 2]

	end
	
	NewNumber = NewNumber .. Abbreviation 
	
	return NewNumber
	
end


-- Module Functions
function Yen:SetupPlayerFolder(Player: Player): Folder
	
	local CurrencyFolder = Instance.new("Folder")
	CurrencyFolder.Name = "Yen-Folder"
	
	for CurrencyName, CurrencyTable in pairs(Yen.Currency) do
		
		local Currency  = Instance.new("IntValue", CurrencyFolder)
		Currency.Name   = CurrencyName
		Currency.Value  = CurrencyTable.StartingAmmount
		Currency.Parent = CurrencyFolder
		
	end
	
	CurrencyFolder.Parent = Player
	return CurrencyFolder
	
end

function Yen:GetPlayerFolder(Player: Player): Folder
	
	return Player["Yen-Folder"]
	
end

function Yen:GetCurrencyAmount(PlayerFolder: Folder, CurrencyName: string): number
	
	local Currency: IntValue = PlayerFolder[CurrencyName]
	
	return Currency.Value
	
end

function Yen:SetPlayerCurrency(PlayerFolder: Folder, CurrencyName: string, Amount: number): nil
	
	local Currency: IntValue = PlayerFolder[CurrencyName]
	Currency.Value = Amount
	
end

function Yen:GetDisplayNumber(CurrencyName: string, Amount: number): string
	
	local Sign = Yen.Currency[CurrencyName].Sign
	local DisplayNumber = Sign .. Abbreviate(Amount)
	
	return DisplayNumber
	
end

return Yen
