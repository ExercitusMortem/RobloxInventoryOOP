local Interactable = {}

local function generatePart(pos)
	local part = Instance.new("Part")
	part.Anchored = true
	part.Size = Vector3.new(1,1,1)
	part.Position = pos or Vector3.new(0,0,0)
	
	local proximityPrompt = Instance.new("ProximityPrompt",part)
	proximityPrompt.RequiresLineOfSight = false
	
	return part, proximityPrompt
end

Interactable.new = function(callback, pos)
	local self = {}
	
	self.part, self.proximityPrompt = generatePart(pos)
	
	local function fireCallback(...)
		callback(...)
	end
	
	self.proximityPrompt.Triggered:Connect(function(playerWhoClicked)
		fireCallback(self, playerWhoClicked)
	end)
	
	return self
end

return Interactable
