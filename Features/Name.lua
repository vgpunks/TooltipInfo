local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP

local PVP = PVP

local PVP_LABEL = " (" .. PVP .. ")"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        local _, classFilename = UnitClass(unit)
        if classFilename then
            local classColor = RAID_CLASS_COLORS[classFilename]
            if classColor then
                local name = classColor:WrapTextInColorCode(lineData.leftText)
                if UnitIsPVP(unit) then
                    local hostileColor = FACTION_BAR_COLORS[5] -- Green (friendly)
                    if UnitIsEnemy("player", unit) then
                        hostileColor = FACTION_BAR_COLORS[1] -- Red (hostile)
                    elseif UnitCanAttack("player", unit) then
                        hostileColor = FACTION_BAR_COLORS[4] -- Yellow (neutral)
                    end
                    name = name .. hostileColor:WrapTextInColorCode(PVP_LABEL)
                end
                lineData.leftText = name
            end
        end
    end
end)