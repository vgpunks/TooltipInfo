local PVP = PVP

local lineNumber = 2

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    lineNumber = lineNumber > tooltip:NumLines() and 2 or lineNumber + 1
    
    if unit and UnitIsPlayer(unit) and lineNumber > 2 then 
        if lineData.leftText == PVP then
            lineData.leftText = ""
        end
    end
end)