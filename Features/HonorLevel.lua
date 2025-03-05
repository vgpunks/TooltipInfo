if not TooltipDataProcessor.AddLinePreCall then return end

local UnitIsPlayer = UnitIsPlayer
local UnitHonorLevel = UnitHonorLevel
local UnitFactionGroup = UnitFactionGroup

local _G = _G
local HONOR_LEVEL_TOOLTIP = HONOR_LEVEL_TOOLTIP

local HONOR_LEVEL_LABEL = HONOR_LEVEL_TOOLTIP:gsub(" %%d", ":")

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) then
        local honorLevel = UnitHonorLevel(unit)
		local _, localizedFaction = UnitFactionGroup(unit)
		if honorLevel <= 0 or not localizedFaction then
            return
		end
        if lineData.leftText:find(localizedFaction) then
            lineData.leftText = ""
            tooltip:AddDoubleLine(HONOR_LEVEL_LABEL, honorLevel, nil, nil, nil, 1, 1, 1)
        end
    end
end)