local _, addon = ...
local Player = addon.Player

local UnitIsPlayer = UnitIsPlayer
local UnitRace = UnitRace

local LEVEL_RACE_FORMAT = "%s %s"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) and not lineData.isGuildLine then
        local race = UnitRace(unit)

        if not race then
            return
        end

        if lineData.isLevelLine then
            local reactionColor = Player:GetReactionColor(unit)
            lineData.leftText = LEVEL_RACE_FORMAT:format(lineData.leftText, reactionColor:WrapTextInColorCode(race))
        end
    end
end)