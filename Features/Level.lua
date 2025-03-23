local CreateColor = CreateColor
local GetContentDifficultyCreatureForPlayer = C_PlayerInfo.GetContentDifficultyCreatureForPlayer
local GetDifficultyColor = GetDifficultyColor
local UnitIsPlayer = UnitIsPlayer
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitLevel = UnitLevel

local LEVEL = LEVEL

local LEVEL1_FORMAT = "|cff%s%d|r"
local LEVEL2_FORMAT = "|cff%s%d|r (%d)"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) and not lineData.isGuildLine then
        if lineData.leftText:find(LEVEL) then
            local difficulty = GetContentDifficultyCreatureForPlayer(unit)
            local diffColor = GetDifficultyColor(difficulty)
            local diffHexColor = CreateColor(diffColor.r, diffColor.g, diffColor.b, 1):GenerateHexColorNoAlpha()
            local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)
            local levelText = level > 0 and level or "??"

            if level < realLevel then
                levelText = LEVEL2_FORMAT:format(diffHexColor, levelText, realLevel)
            else
                levelText = LEVEL1_FORMAT:format(diffHexColor, levelText)
            end

            lineData.leftText = lineData.leftText:gsub(level, levelText)
        end
    end
end)