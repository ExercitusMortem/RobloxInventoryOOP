local Interactable = {}
Interactable.__index = Interactable

local function generate(part)
	local proximityPrompt = Instance.new("ProximityPrompt",part)
	proximityPrompt.RequiresLineOfSight = false
	
	return proximityPrompt
end

Interactable.new = function(part : Part, callbackFunction)
	local self = setmetatable({},Interactable)
	
	local proximityPrompt = generate(part)

	local callback = callbackFunction or function() print("Default callback") end
	
	local function interacted(player_who_triggered)
		print("Interacted!")
		callback(player_who_triggered, self)
	end
	
	function self:setCallback(callbackFunction)
		callback = callbackFunction
		print("Set callback")
	end
	
	proximityPrompt.Triggered:Connect(interacted)
	
	return self	
end

return Interactable
