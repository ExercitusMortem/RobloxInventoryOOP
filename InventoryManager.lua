local Database = require(game.ReplicatedStorage.Database)
local Types = require(game.ReplicatedStorage.Types)


local Events = game.ReplicatedStorage.Events
local InventoryManager = {}
local Inventories = {}
local Inventory = {}

-- Inventory methods



function Inventory.new(owner, size)
	local self = {
		owner = owner,
		content = {},
		size = size,
	}

	local function newSlot()
		local slot : Types.SlotType = {itemInstance=nil}
		return slot
	end
	
	for i = 1,size do
		table.insert(self.content, newSlot())
	end
	function self.returnFirstEmptyIndex()
		for i = 1, self.size do
			if not self.content[i].itemInstance then
				return i
			end
		end
	end

	function self.returnCorrespondingIndex(item)
		for i, slot in ipairs(self.content) do
			if slot.itemInstance and slot.itemInstance.item_id == item.item_id and slot.itemInstance.item_qt ~= Database[item.item_id].max_stack then
				return i
			end
		end
	end

	function self.mergeQuantities(slot_index, item)
	    local maxStack = Database[item.item_id].max_stack
	    local totalQuantity = self.content[slot_index].itemInstance.item_qt + item.item_qt
	    local remainder = math.max(0, totalQuantity - maxStack)

	    self.content[slot_index].itemInstance.item_qt = totalQuantity - remainder
	    
	    print("Remainder:", remainder)

	    return remainder
	end


	function self.addItem(item, optional_slot)
		print(item.item_qt)
		if optional_slot then
			if not self.content[optional_slot].itemInstance then
				self.content[optional_slot].itemInstance = item
				return true
			elseif self.content[optional_slot].itemInstance.item_id == item.item_id then
				local remainder = self.mergeQuantities(optional_slot, item)
				item=item.setQuantity(remainder)
				if remainder > 0 then
					return self.addItem(item)
				else
					return true
				end
			end
		else
			local i = self.returnCorrespondingIndex(item)
			if i then
				local remainder = self.mergeQuantities(i, item)
				item=item.setQuantity(remainder)
				if remainder > 0 then
					return self.addItem(item)
				else
					return true
				end
			else
				i = self.returnFirstEmptyIndex()
				if i then
					self.content[i].itemInstance = item
					return true
				else
					return false
				end
			end
		end
	end

	function self.dropItem(slot_index)
		if self.content[slot_index].itemInstance then
			-- Add logic for dropping item
		end
	end

	return self
end

-- InventoryManager methods

function InventoryManager.newInventory(owner, size)
	Inventories[owner] = Inventory.new(owner, size)
	return owner
end

function InventoryManager.removeInventory(owner)
	Inventories[owner] = nil
end

function InventoryManager.addItemToOwner(owner, item)
	Inventories[owner].addItem(item)
	print(Inventories[owner])
end


Events.InventoryManager.Event:Connect(function(...)
	local args = {...}

	local command = table.remove(args,1)
	InventoryManager[command](table.unpack(args))
	print(command)
end)


return InventoryManager
