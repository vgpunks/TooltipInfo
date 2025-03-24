local UnitIsPlayer = UnitIsPlayer
local UnitHonorLevel = UnitHonorLevel
local UnitFactionGroup = UnitFactionGroup

local HONOR_LEVEL_TOOLTIP = HONOR_LEVEL_TOOLTIP

local HONOR_LEVEL_LABEL = HONOR_LEVEL_TOOLTIP:gsub(" %%d", ":")

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    
    if unit and UnitIsPlayer(unit) then
        local honorLevel = UnitHonorLevel(unit)

		if honorLevel <= 0 then
            return
		end

        tooltip:AddDoubleLine(HONOR_LEVEL_LABEL, honorLevel, nil, nil, nil, 1, 1, 1)
    end
end)