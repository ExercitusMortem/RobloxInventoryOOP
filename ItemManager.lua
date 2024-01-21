local Database = require(game.ReplicatedStorage.Database)
local Item = require(game.ReplicatedStorage.Item)
local Events = game.ReplicatedStorage.Events

local ItemManager = {}
local Items = {}


function ItemManager.newItem(item_id, item_qt, pos)
	local item = Item.new(item_id, item_qt, pos)
	Items[item.UID] = item 
	return 
end

function ItemManager.removeItem(UID)
	if Items[UID] and Items[UID].item_qt then
		Items[UID].remove()
	end
end

function ItemManager.fetchItem(UID)
	return Items[UID]
end

Events.ItemManager.Event:Connect(function(...)
	local args = {...}

	local command = table.remove(args,1)
	
	ItemManager[command](table.unpack(args))
end)

return ItemManager
