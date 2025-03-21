local UnitIsPlayer = UnitIsPlayer
local UnitRace = UnitRace
local UnitIsFriend = UnitIsFriend

local RACE_FORMAT = "%%s%%s|r"

local lineNumber = 2

local function GetUnitReactionColor(unit)
    if UnitIsFriend(unit, "player") then
        return "|cff49ad4d"
    else
        return "|cffff0000"
    end
end

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    lineNumber = lineNumber > tooltip:NumLines() and 2 or lineNumber + 1
    
    if unit and UnitIsPlayer(unit) and lineNumber > 2 then
        local race = UnitRace(unit)
        if not race then
            return
        end
        if lineData.leftText:find(race) then
            lineData.leftText = lineData.leftText:gsub(race, RACE_FORMAT)
            lineData.leftText = lineData.leftText:format(GetUnitReactionColor(unit), race)
        end
    end
end)