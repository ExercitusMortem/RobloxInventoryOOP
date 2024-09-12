local Interactable = {}

Interactable.new = function(itemInstance, proxParent, callback)
	local self = {}
	
	local proxPrompt = Instance.new('ProximityPrompt')
	proxPrompt.RequiresLineOfSight = false
	
	proxPrompt.Parent = proxParent
	
	proxPrompt.Triggered:Connect(function(player)
		callback(itemInstance, player)
	end)
end

return Interactable
