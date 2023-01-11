local path = ...

local m = {}

local function ReplaceModDir(str)
    return str:gsub("%%ModDir%%", path)
end

m.RemoveAll = function (root, name)
    while (true) do
        local element = root.Element(name) or root.Element(string.lower(name))
        if element == nil then break end
        element.Remove()
    end
end

m.Add = function (root, xml)
    xml = XDocument.Parse(ReplaceModDir(xml))

    for element in xml.Root.Elements() do
        root.Add(element)
    end
end

m.ReplaceWithOwnPath = function (element)
    local file = element.Attribute("originalfile") or element.Attribute("file")
    file = file.Value
    element.SetAttributeValue("originalfile", file)
    element.SetAttributeValue("file", path .. "/" .. file)
end

m.Replace = function (element, arg1, arg2)
    if arg2 == nil then
        arg2 = arg1
        arg1 = "file"
    end

    if arg1 == "file" then
        arg2 = path .. "/" .. arg2
    end

    element.SetAttributeValue(arg1, arg2)
end

return m