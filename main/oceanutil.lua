GLOBAL.setfenv(1, GLOBAL)

function IsOnFlood(x, y, z)
    x, y, z = GetWorldPosition(x, y, z)
    local _flood = TheWorld.components.flooding
    return _flood ~= nil and _flood:OnFlood(x, y, z)
end
