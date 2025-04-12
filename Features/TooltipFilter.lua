local PVP = PVP

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and not lineData.isGuildLine then
        if lineData.leftText == PVP then
            return true
        end
        if UnitIsPlayer(unit) then
            local _, localizedFaction = UnitFactionGroup(unit)
            if lineData.leftText == localizedFaction then
                return true
            end
        end
    end
end)