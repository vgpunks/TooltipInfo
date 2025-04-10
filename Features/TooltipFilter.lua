local PVP = PVP
local LEVEL = LEVEL

local LEVEL_PATTERN = "%(.+%)"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and not lineData.isGuildLine then
        if lineData.leftText:find(LEVEL) then
            lineData.leftText = lineData.leftText:gsub(LEVEL_PATTERN, "")
        end
        if lineData.leftText == PVP then
            lineData.leftText = ""  
        end
        if UnitIsPlayer(unit) then
            local _, localizedFaction = UnitFactionGroup(unit)
            if lineData.leftText == localizedFaction then
                lineData.leftText = ""
            end
        end
    end
end)