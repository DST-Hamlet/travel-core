local map_tags = {Tag = {}, TagData = {}}

local function AddMapTags(_map_tags, add_tags)
    _map_tags = _map_tags or map_tags
    add_tags = add_tags or map_tags

    for tag, fn in pairs(add_tags.Tag) do
        map_tags.Tag[tag] = fn
    end

    for tag, data in pairs(add_tags.TagData) do
        map_tags.TagData[tag] = data
    end
end

return AddMapTags
