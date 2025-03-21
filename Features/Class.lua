local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local lineNumber = 2

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    lineNumber = lineNumber > tooltip:NumLines() and 2 or lineNumber + 1
    
    if unit and UnitIsPlayer(unit) and lineNumber > 2 then 
        local className, classFilename = UnitClass(unit)
        if not className or not classFilename then
            return
        end
        if lineData.leftText:find(className) then
            local classColor = RAID_CLASS_COLORS[classFilename]
            if classColor then
                lineData.leftText = classColor:WrapTextInColorCode(lineData.leftText)
            end
        end
    end
end)