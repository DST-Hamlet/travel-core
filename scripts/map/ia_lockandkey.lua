require("map/lockandkey")

local function AddSimpleKeyLock(name)
    if KEYS[name] then
        return
    end

    table.insert(KEYS_ARRAY, name)
    KEYS[name] = #KEYS_ARRAY
    table.insert(LOCKS_ARRAY, name)
    LOCKS[name] = #KEYS_ARRAY
    LOCKS_KEYS[LOCKS[name]] = {KEYS[name]}
end

return AddSimpleKeyLock