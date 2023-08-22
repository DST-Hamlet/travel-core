local Floodable = Class(function(self, inst)
    self.inst = inst

    self.flooded = false

    self.onStartFlooded = nil
    self.onStopFlooded = nil

    -- self.inst:AddTag("floodable")

    self:SetFX(nil, nil, 10)  -- This starts the update task.
end)

local function Update(inst)
    local self = inst.components.floodable
    local pt = inst:GetPosition()
    local onFlood = IsOnFlood(pt.x, pt.y, pt.z)

    if onFlood and not self.flooded then
        self.flooded = true
        inst:AddTag("flooded")
        if self.onStartFlooded then
            self.onStartFlooded(inst)
        end

    elseif not onFlood and self.flooded then
        self.flooded = false
        inst:RemoveTag("flooded")
        if self.onStopFlooded then
            self.onStopFlooded(inst)
        end
    end

    if self.flooded then
        if self.floodEffect then
            local fx = SpawnPrefab(self.floodEffect)
            if fx then
                fx.Transform:SetPosition(pt.x, pt.y, pt.z)
            end
        end
    end
end

function Floodable:SetFX(floodEffect, fxPeriod)
    self.floodEffect = floodEffect
    if fxPeriod and fxPeriod ~= self.fxPeriod then
        self.fxPeriod = fxPeriod
        if self.updatetask then
            self.updatetask:Cancel()
        end
        self.updatetask = self.inst:DoPeriodicTask(fxPeriod, Update, fxPeriod * math.random())
    end
end

function Floodable:OnRemoveEntity()
    self.inst:RemoveTag("flooded")
    if self.updatetask then
        self.updatetask:Cancel()
        self.updatetask = nil
    end
end

Floodable.OnRemoveFromEntity = Floodable.OnRemoveEntity

return Floodable
