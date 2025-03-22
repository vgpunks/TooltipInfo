local ICON_LIST = ICON_LIST

local UnitExists = UnitExists
local GetRaidTargetIndex = GetRaidTargetIndex

local RAID_ICON_FORMAT = "%s %s"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        local ricon = GetRaidTargetIndex(unit)
        
        if ricon then
            lineData.leftText = RAID_ICON_FORMAT:format(ICON_LIST[ricon] .. "18|t", lineData.leftText)
        end
    end
end)