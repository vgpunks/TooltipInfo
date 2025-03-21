local UnitIsPlayer = UnitIsPlayer
local UnitHonorLevel = UnitHonorLevel
local UnitFactionGroup = UnitFactionGroup

local HONOR_LEVEL_TOOLTIP = HONOR_LEVEL_TOOLTIP

local HONOR_LEVEL_LABEL = HONOR_LEVEL_TOOLTIP:gsub(" %%d", ":")

local lineNumber = 2

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    lineNumber = lineNumber > tooltip:NumLines() and 2 or lineNumber + 1

    if unit and UnitIsPlayer(unit) and lineNumber > 2 then
        local honorLevel = UnitHonorLevel(unit)
		local _, localizedFaction = UnitFactionGroup(unit)
		if honorLevel <= 0 or not localizedFaction then
            return
		end
        if lineData.leftText == localizedFaction then
            lineData.leftText = ""
            tooltip:AddDoubleLine(HONOR_LEVEL_LABEL, honorLevel, nil, nil, nil, 1, 1, 1)
        end
    end
end)