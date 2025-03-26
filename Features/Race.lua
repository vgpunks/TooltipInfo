local _, addon = ...
local Player = addon.Player

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
            local reactionColor = Player:GetReactionColor(unit)
            lineData.leftText = lineData.leftText:gsub(race, reactionColor:WrapTextInColorCode(race))
        end
    end
end)