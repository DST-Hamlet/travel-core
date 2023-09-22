local AddClassPostConstruct = AddClassPostConstruct
GLOBAL.setfenv(1, GLOBAL)

local UIAnim = require("widgets/uianim")
local HealthBadge = require("widgets/healthbadge")
local OldAgeBadge = require("widgets/wandaagebadge")

local _OnUpdate = HealthBadge.OnUpdate
function HealthBadge:OnUpdate(dt, ...)
    _OnUpdate(self, dt, ...)

    local ispoison = self.owner.ispoisoned or (self.owner.player_classified and self.owner.player_classified.ispoisoned:value())

    if self.poison ~= ispoison then
        self.poison = ispoison
        if ispoison then
            self.poisonanim:GetAnimState():PlayAnimation("activate")
            self.poisonanim:GetAnimState():PushAnimation("idle", true)
            self.poisonanim:Show()
        else
        	self.owner.SoundEmitter:PlaySound("ia_core/common/HUD_antivenom_use")
            self.poisonanim:GetAnimState():PlayAnimation("deactivate")
        end
    end
end

local OldAgeBadge_OnUpdate = OldAgeBadge.OnUpdate
function OldAgeBadge:OnUpdate(dt, ...)
    OldAgeBadge_OnUpdate(self, dt, ...)

    local ispoison = self.owner.ispoisoned or (self.owner.player_classified and self.owner.player_classified.ispoisoned:value())

    if self.poison ~= ispoison then
        self.poison = ispoison
        if ispoison then
            self.poisonanim:GetAnimState():PlayAnimation("activate")
            self.poisonanim:GetAnimState():PushAnimation("idle", true)
            self.poisonanim:Show()
        else
        	self.owner.SoundEmitter:PlaySound("ia_core/common/HUD_antivenom_use")
            self.poisonanim:GetAnimState():PlayAnimation("deactivate")
        end
    end
end

local postinit = function(self)
    self.poison = false
    self.poisonanim = self.underNumber:AddChild(UIAnim())
    self.poisonanim:GetAnimState():SetBank("poison")
    self.poisonanim:GetAnimState():SetBuild("poison_meter_overlay")
    self.poisonanim:GetAnimState():PlayAnimation("deactivate")
    self.poisonanim:Hide()
    self.poisonanim:SetClickable(false)
end

AddClassPostConstruct("widgets/healthbadge", postinit)
AddClassPostConstruct("widgets/wandaagebadge", postinit)
