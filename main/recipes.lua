GLOBAL.setfenv(1, GLOBAL)

local function SortRecipe(a, b, filter_name, offset)
    local filter = CRAFTING_FILTERS[filter_name]
    if filter and filter.recipes then
        for sortvalue, product in ipairs(filter.recipes) do
            if product == a then
                table.remove(filter.recipes, sortvalue)
                break
            end
        end

        local target_position = #filter.recipes + 1
        for sortvalue, product in ipairs(filter.recipes) do
            if product == b then
                target_position = sortvalue + offset
                break
            end
        end
        table.insert(filter.recipes, target_position, a)
    end
end

local function SortBefore(a, b, filter_name)  -- a before b
    SortRecipe(a, b, filter_name, 0)
end

local function SortAfter(a, b, filter_name)  -- a after b
    SortRecipe(a, b, filter_name, 1)
end

TravelCore.SortRecipe = SortRecipe
TravelCore.SortBefore = SortBefore
TravelCore.SortAfter = SortAfter
