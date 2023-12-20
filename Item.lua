local UID = require(game.ReplicatedStorage.UID)
local Object = require(game.ReplicatedStorage.Object)
local Interactable = require(game.ReplicatedStorage.Interactable)
local Item = {}

local Item = {}

Item.new = function(item_id : string, pos : Vector3)
	local self = {}
	
	local OBJECT = Object.new(pos)
	local INTERACTABLE = Interactable.new(OBJECT)
	
	local function pickup()
		OBJECT:SetSpawned(false)
	end
	
	local function drop()
		OBJECT:SetSpawned(true)
	end
	
	INTERACTABLE:SetCallback(pickup)
	return self
end

return Item
