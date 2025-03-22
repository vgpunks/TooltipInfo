local CreateColor = CreateColor
local GetContentDifficultyCreatureForPlayer = C_PlayerInfo.GetContentDifficultyCreatureForPlayer
local GetDifficultyColor = GetDifficultyColor
local UnitIsPlayer = UnitIsPlayer
local UnitEffectiveLevel = UnitEffectiveLevel
local UnitLevel = UnitLevel
local GetGuildInfo = GetGuildInfo

local LEVEL1_FORMAT = "|cff%s%d|r"
local LEVEL2_FORMAT = "|cff%s%d|r (%d)"

local PLAYER_PATTERN = "%(" .. PLAYER .. "%)"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) then
        local guildName = GetGuildInfo(unit)

        if guildName and lineData.leftText:find(guildName) then
            return
        end

        local difficulty = GetContentDifficultyCreatureForPlayer(unit)
        local diffColor = GetDifficultyColor(difficulty)
		local diffHexColor = CreateColor(diffColor.r, diffColor.g, diffColor.b, 1):GenerateHexColorNoAlpha()
		local level, realLevel = UnitEffectiveLevel(unit), UnitLevel(unit)

        if lineData.leftText:find(LEVEL) then
            -- Removes the (Player) bit from the level line.
            lineData.leftText = lineData.leftText:gsub(PLAYER_PATTERN, "")

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