local PVP = PVP
local LEVEL = LEVEL
local PLAYER = PLAYER

local PLAYER_PATTERN = "%(" .. PLAYER .. "%)"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    
    if unit and not lineData.isGuildLine then
        if UnitIsPlayer(unit) then
            if lineData.leftText:find(LEVEL) then
                lineData.leftText = lineData.leftText:gsub(PLAYER_PATTERN, "")
            else
                local _, localizedFaction = UnitFactionGroup(unit)
                if lineData.leftText == localizedFaction then
                    lineData.leftText = ""
                end
            end
        end
        if lineData.leftText == PVP then
            lineData.leftText = ""  
        end
    end
end)