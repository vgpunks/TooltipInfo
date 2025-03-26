local _, addon = ...
local Player = addon.Player

local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local UnitIsEnemy = UnitIsEnemy
local UnitCanAttack = UnitCanAttack

local PVP = PVP
local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local PVP_LABEL = " (" .. PVP .. ")"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        if UnitIsPVP(unit) then
            local reactionColor = Player:GetReactionColor(unit)
            lineData.leftText = lineData.leftText .. reactionColor:WrapTextInColorCode(PVP_LABEL)
        end
    end
end)