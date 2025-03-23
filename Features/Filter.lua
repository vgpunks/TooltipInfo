local PVP = PVP

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    
    if unit and UnitIsPlayer(unit) and not lineData.isGuildLine then
        if lineData.leftText == PVP then
            lineData.leftText = ""
        end
    end
end)