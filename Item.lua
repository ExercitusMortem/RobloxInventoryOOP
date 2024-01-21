local Interactable = require(game.ReplicatedStorage.Interactable)
local Database = require(game.ReplicatedStorage.Database)
local UID = require(game.ReplicatedStorage.UID)
local Types = require(game.ReplicatedStorage.Types)

local Events = game.ReplicatedStorage.Events


local Item = {}

Item.new = function(item_id, item_qt, position)
	
	local model = Instance.new("Model")
	
	local self : Types.ItemType = {
		item_id=item_id or 'DEFAULT',
		item_qt=item_qt or 1,
		UID = UID(),
		remove = function() model:Destroy() end,
		setQuantity = function() print(' dumb ') end,
	}
	
	local position = position or Vector3.new(0,0,0)
	
	local is_spawned = false
	
	local update

	local function toggleSpawned(optional_state : boolean)
		if optional_state ~= nil then
			is_spawned = optional_state
		else
			is_spawned = not is_spawned
		end
		update()
	end
	
	local function pickupItem(player)
		print(player.Name .. " is attempting to pick up item with UID " .. self.UID)
		Events.InventoryManager:Fire('addItemToOwner',player,self)
		toggleSpawned(false)
	end
	
	local function dropItem(player)
		print(player.Name .. " is attempting to drop item with UID " .. self.UID)
		position = player.Character.HumanoidRootPart.Position - Vector3.new(0,3,0)
		toggleSpawned(true)
	end
	
	self.setQuantity = function(qt)
		self.item_qt = qt
		print(qt, self.item_qt)
		update()
		if qt == 0 then
			print('oit')
			Events.ItemManager:Fire('removeItem', self.UID)
		end
		return self
	end
	

	local interactable = Interactable.new(function(self, playerWhoClicked) pickupItem(playerWhoClicked) end, position)
	interactable.part.Parent = model
	
	update = function()
		model.Parent = is_spawned and workspace or nil
		model:PivotTo(CFrame.new(position))
		interactable.proximityPrompt.ObjectText = Database[self.item_id].name .. " x" .. self.item_qt
	end
	
	toggleSpawned(true)
	
	return self
end

return Item
