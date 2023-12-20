local Item = require(game.ReplicatedStorage.Item)
local Items = {}

local ItemManager = {}

function ItemManager:GetItems()
	return Items
end

function ItemManager:CreateItem(...)
	local item = Item.new(...)
	ItemManager[item._UID]=item
end

function ItemManager:DestroyItem(UID)
	Items[UID]=nil
end

function ItemManager:GetItemFromUID(UID)
	return Items[UID]
end

return ItemManager
