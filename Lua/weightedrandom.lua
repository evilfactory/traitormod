local weightedRandom = {}

local function Depth0(subjects)
    local total = 0
    for key, value in pairs(subjects) do
        total = total + value
    end

    local rng = Random.Range(0, total)

    local step = 0
    for key, value in pairs(subjects) do
        step = step + value

        if rng > step - value and rng < step then
            return key
        end
    end
end

local function Depth1(subjects, variable)
    local total = 0
    for key, value in pairs(subjects) do
        total = total + value[variable]
    end

    local rng = Random.Range(0, total)

    local step = 0
    for key, value in pairs(subjects) do
        step = step + value[variable]

        if rng > step - value[variable] and rng < step then
            return key
        end
    end
end

local function Depth2(subjects, variable, subVariable)
    local total = 0
    for key, value in pairs(subjects) do
        total = total + value[variable][subVariable]
    end

    local rng = Random.Range(0, total)

    local step = 0
    for key, value in pairs(subjects) do
        step = step + value[variable][subVariable]

        if rng > step - value[variable][subVariable] and rng < step then
            return key
        end
    end
end

weightedRandom.Choose = function (subjects, variable, subVariable)

    local res = nil
    if variable == nil then 
        res = Depth0(subjects) 
    elseif variable ~= nil and subVariable ~= nil then 
        res = Depth2(subjects, variable, subVariable)
    elseif variable ~= nil then 
        res = Depth1(subjects, variable) 
    end

    if res == nil then
        for key, value in pairs(subjects) do
            return key
        end
    else
        return res
    end
end

return weightedRandom