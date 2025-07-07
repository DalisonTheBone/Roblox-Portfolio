--[[--
 -- Name: BadgeHandler
 -- Created By: DalaisonTheBone
 -- Status: Completed
 -- If something breaks please contact me.

 -- Module Documentation --

Description:
	This module aims to make awarding badges easier.

Methods:
	CanAwardBadge(BadgeId: number): boolean
	-- Checks if a badge can be awarded via badgeid and returns a boolean.
	 
	PlayerHasBadge(Player: Player, BadgeId: number): boolean
	-- Checks if a specified player has a badge and returns a boolean.

	AwardPlayer(Player: Player, BadgeId: number): nil
	-- Awards a badge to a given player.
	 
	AwardServer(BadgeId: number): nil
	-- Awards a badge to every player in the server.

--]]--

local Badge = {}

-- Services
local Players      = game:GetService("Players")
local BadgeService = game:GetService("BadgeService")

-- Module Functions
function Badge:CanAwardBadge(BadgeId: number): boolean
	
	local S, BadgeInfo = pcall(function()
		
		return BadgeService:GetBadgeInfoAsync(BadgeId)
		
	end)
	
	if S then
		
		return BadgeInfo.IsEnabled
		
	else
		
		return false
		
	end
	
end

function Badge:PlayerHasBadge(Player: Player, BadgeId: number): boolean
	
	local S, HasBadge = pcall(function()
		
		return BadgeService:UserHasBadgeAsync(Player.UserId, BadgeId)
		
	end)
	
	if S then
		
		return HasBadge
		
	else
		
		return false

	end
	
end

function Badge:AwardPlayer(Player: Player, BadgeId: number): nil
	
	if Badge:CanAwardBadge(BadgeId) and not Badge:PlayerHasBadge(Player, BadgeId) then
		
		local S, E = pcall(function()
			
			BadgeService:AwardBadge(Player.UserId, BadgeId)
			
		end)
		
		if S then
			
			print("Awarded BadgeId: " .. BadgeId .. " To: " .. Player.Name)
			
		else
			
			warn(E)
			
		end
		
	end
	
end

function Badge:AwardServer(BadgeId: number): nil
	
	task.spawn(function()
		
		if Badge:CanAwardBadge(BadgeId) then
			
			for i, v in pairs(Players:GetChildren()) do
				
				Badge:AwardPlayer(v, BadgeId)
				task.wait()
				
			end
			
		else
			
			warn("Could Not Award Server Badge: " .. BadgeId)
			
		end
		
	end)
	
end

return Badge
