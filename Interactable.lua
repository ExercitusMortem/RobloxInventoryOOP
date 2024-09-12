local Interactable = {}

Interactable.new = function(itemInstance, callback)
	local self = {}
	
	local proxPrompt = Instance.new('ProximityPrompt')
	proxPrompt.RequiresLineOfSight = false
	
	proxPrompt.Parent = itemInstance.Model
	
	proxPrompt.Triggered:Connect(function(player)
		callback(itemInstance, player)
	end)
end

return Interactable
