local IAENV = env
GLOBAL.setfenv(1, GLOBAL)

ToolUtil = {}
IAENV.ToolUtil = ToolUtil

local hidefns = {}
function ToolUtil.HideFn(hidefn, realfn)
    hidefns[hidefn] = realfn
end

local _debug_getupvalue = debug.getupvalue
function debug.getupvalue(fn, ...)
    local rets = {_debug_getupvalue(hidefns[fn] or fn, ...)}
    return unpack(rets)
end
ToolUtil.HideFn(debug.getupvalue, _debug_getupvalue)

local _debug_setupvalue = debug.setupvalue
function debug.setupvalue(fn, ...)
    local rets = {_debug_setupvalue(hidefns[fn] or fn, ...)}
    return unpack(rets)
end
ToolUtil.HideFn(debug.setupvalue, _debug_setupvalue)

function ToolUtil.GetUpvalue(fn, name, recurse_levels)
    assert(type(fn) == "function")

    recurse_levels = recurse_levels or 0
    local source_fn = fn
    local i = 1

    while true do
        local _name, value = debug.getupvalue(fn, i)
        if _name == nil then
            return
        elseif _name == name then
            return value, i, source_fn
        elseif type(value) == "function" and recurse_levels > 0 then
            local _value, _i, _source_fn = ToolUtil.GetUpvalue(value, name, recurse_levels - 1)
            if _value ~= nil then
                return _value, _i, _source_fn
            end
        end

        i = i + 1
    end
end

function ToolUtil.SetUpvalue(fn, value, name, recurse_levels)
    local _, i, source_fn = ToolUtil.GetUpvalue(fn, name, recurse_levels)
    debug.setupvalue(source_fn, i, value)
end

function ToolUtil.RegisterImageAtlas(atlas_path)
    local atlas = resolvefilepath(atlas_path)

    local file = io.open(atlas, "r")
    local data = file:read("*all")
    file:close()

    local str = string.gsub(data, "%s+", "")
    local _, _, elements = string.find(str, "<Elements>(.-)</Elements>")

    for s in string.gmatch(elements, "<Element(.-)/>") do
        local _, _, image = string.find(s, "name=\"(.-)\"")
        if image ~= nil then
            RegisterInventoryItemAtlas(atlas, image)
            RegisterInventoryItemAtlas(atlas, hash(image))  -- for client
        end
    end
end

function ToolUtil.is_array(t)
    if type(t) ~= "table" or not next(t) then
        return false
    end

    local n = #t
    for i, v in pairs(t) do
        if type(i) ~= "number" or i <= 0 or i > n then
            return false
        end
    end

    return true
end

function ToolUtil.merge_table(target, add_table, override)
    target = target or {}

    for k, v in pairs(add_table) do
        if type(v) == "table" then
            if not target[k] then
                target[k] = {}
            elseif type(target[k]) ~= "table" then
                if override then
                    target[k] = {}
                else
                    error("Can not override" .. k .. " to a table")
                end
            end

            ToolUtil.merge_table(target[k], v, override)
        else
            if ToolUtil.is_array(target) and not override then
                table.insert(target, v)
            elseif not target[k] or override then
                target[k] = v
            end
        end
    end
end
