local Object = {}

local function generatePart(pos)
    local part = Instance.new("Part")
    part.Size = Vector3.new(1,1,1)
    part.Anchored = true
    part.Position = pos
    return part
end

Object.new = function(pos : Vector3)
    local self = {}
    
    local position = pos or Vector3.new(0,0,0)
    local originPart = generatePart(position)

    local is_spawned = false

    function self:SetSpawned(state : boolean)
        if state ~= nil then
            is_spawned = state
        else
            is_spawned = not is_spawned
        end
    end

    function self:SetPosition(position : Vector3)
        originPart.Position = position
    end

    return self
end
return Object
