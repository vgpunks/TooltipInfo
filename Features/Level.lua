local CreateColor = CreateColor
local GetContentDifficultyCreatureForPlayer = C_PlayerInfo.GetContentDifficultyCreatureForPlayer
local GetDifficultyColor = GetDifficultyColor
local UnitIsPlayer = UnitIsPlayer
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitLevel = UnitLevel

local LEVEL = LEVEL

local LEVEL_TW_FORMAT = "%d (%d)"

local DIFFICULTY_COLOR = {}

for _, difficulty in pairs(Enum.RelativeContentDifficulty) do
    local diffColor = GetDifficultyColor(difficulty)
    DIFFICULTY_COLOR[difficulty] = CreateColor(diffColor.r, diffColor.g, diffColor.b, 1)
end

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    if unit and not lineData.isGuildLine then
        if lineData.leftText:find(LEVEL) then
            local difficulty = GetContentDifficultyCreatureForPlayer(unit)
            local diffColor = DIFFICULTY_COLOR[difficulty]
            local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)
            local levelText = level > 0 and level or "??"

            if level < realLevel then
                levelText = diffColor:WrapTextInColorCode(LEVEL_TW_FORMAT:format(levelText, realLevel))
            else
                levelText = diffColor:WrapTextInColorCode(levelText)
            end

            lineData.leftText = lineData.leftText:gsub(level, levelText)
        end
    end
end)