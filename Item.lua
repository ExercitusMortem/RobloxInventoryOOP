local Interactable = require(game.ReplicatedStorage.Interactable)

local InstanceFolder = workspace:FindFirstChild('InstanceFolder') or Instance.new('Folder', workspace) InstanceFolder.Name = 'InstanceFolder'

local i = 0
local function UID()
	i += 1
	return i
end
local ItemInstances = {}

function ItemInstances.Get(UID_or_Model)
	local object_UID = typeof(UID_or_Model)=='number' and UID_or_Model or UID_or_Model:GetAttribute('UID')
	return ItemInstances[object_UID]
end

local ItemInstance = {}

function ItemInstance.new(item, quantity)
	local self = {}
	
	self._item = item
	self._UID = UID()
	self.quantity = quantity
	
	local is_spawned = false
	
	local viewModel = item._model:Clone()
	viewModel:SetAttribute('UID', self._UID)

	function self:ToggleSpawned(is_toggled : boolean?)
		if is_toggled ~= nil then
			is_spawned = is_toggled
		else
			is_spawned = not is_spawned
		end
		viewModel.Parent = is_spawned and InstanceFolder or nil
	end
	
	function self:PivotTo(cfr : CFrame)
		viewModel:PivotTo(cfr)
	end
	
	local interact = Interactable.new(self,viewModel,function(itemInstance, player)
		print(player.Name .. ' interacted with ' .. self._item._name .. '[' .. self._UID .. ']')
		self:ToggleSpawned(false)
	end)
	
	ItemInstances[self._UID]=self
	
	return self
end

local Items = {}
function Items.Get(name)
	return Items[name]
end

local Item = {}

function Item.new(name, desc, model)
	if Items[name] then warn("Item of _name \'" .. name .. '\' already exists, returning it..' ) return Items[name] end
	local self = setmetatable({},Item)
	self._name = name
	self._desc = desc
	self._model = model

	function self:Create(quantity, cfr : CFrame)
		local instance = ItemInstance.new(self, quantity)
		instance:PivotTo(cfr)
		instance:ToggleSpawned(true)
		return Instance
	end
	

	Items[name] = self

		
	return self
end

return Item
