local _, addon = ...

local GetContentDifficultyCreatureForPlayer = C_PlayerInfo.GetContentDifficultyCreatureForPlayer
local UnitIsPlayer = UnitIsPlayer
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitLevel = UnitLevel

local LEVEL = LEVEL
local TOOLTIP_UNIT_LEVEL = TOOLTIP_UNIT_LEVEL

local LEVEL_TW_FORMAT = "%d " .. WHITE_FONT_COLOR:WrapTextInColorCode("(%d)")

local DIFFICULTY_COLOR = addon.DIFFICULTY_COLOR

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and not lineData.isGuildLine then
        if lineData.leftText:find(LEVEL) and not lineData.isLevelLine then
            lineData.isLevelLine = true

            local difficulty = GetContentDifficultyCreatureForPlayer(unit)
            local diffColor = DIFFICULTY_COLOR[difficulty]
            local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)
            local levelText = level > 0 and level or "??"

            if UnitIsPlayer(unit) and level < realLevel then
                levelText = LEVEL_TW_FORMAT:format(levelText, realLevel)
            end

            lineData.leftText = diffColor:WrapTextInColorCode(TOOLTIP_UNIT_LEVEL:format(levelText))
        end
    end
end)