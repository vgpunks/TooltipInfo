local _, addon = ...
local Player = {}
addon.Player = Player

local UnitIsEnemy = UnitIsEnemy
local UnitCanAttack = UnitCanAttack

local FACTION_BAR_COLORS = FACTION_BAR_COLORS

function Player:GetReactionColor(unit)
    local reactionColor = FACTION_BAR_COLORS[5] -- Green (friendly)
    if UnitIsEnemy("player", unit) then
        reactionColor = FACTION_BAR_COLORS[1] -- Red (hostile)
    elseif UnitCanAttack("player", unit) then
        reactionColor = FACTION_BAR_COLORS[4] -- Yellow (neutral)
    end
    return reactionColor
end