local UnitIsPlayer = UnitIsPlayer
local UnitRace = UnitRace
local UnitIsFriend = UnitIsFriend
local UnitIsEnemy = UnitIsEnemy
local UnitCanAttack = UnitCanAttack

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end
    
    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) and not lineData.isGuildLine then
        local race = UnitRace(unit)

        if not race then
            return 
        end

        if lineData.leftText:find(race) then
            local hostileColor = FACTION_BAR_COLORS[5] -- Green (friendly)
            if UnitIsEnemy("player", unit) then
                hostileColor = FACTION_BAR_COLORS[1] -- Red (hostile)
            elseif UnitCanAttack("player", unit) then
                hostileColor = FACTION_BAR_COLORS[4] -- Yellow (neutral)
            end
            lineData.leftText = lineData.leftText:gsub(race, hostileColor:WrapTextInColorCode(race))
        end
    end
end)