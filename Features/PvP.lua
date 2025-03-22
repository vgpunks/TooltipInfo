local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local UnitIsEnemy = UnitIsEnemy
local UnitCanAttack = UnitCanAttack
local GetGuildInfo = GetGuildInfo

local PVP = PVP
local FACTION_BAR_COLORS = FACTION_BAR_COLORS

local PVP_LABEL = " (" .. PVP .. ")"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        if UnitIsPVP(unit) then
            local hostileColor = FACTION_BAR_COLORS[5] -- Green (friendly)
            if UnitIsEnemy("player", unit) then
                hostileColor = FACTION_BAR_COLORS[1] -- Red (hostile)
            elseif UnitCanAttack("player", unit) then
                hostileColor = FACTION_BAR_COLORS[4] -- Yellow (neutral)
            end
            lineData.leftText = lineData.leftText .. hostileColor:WrapTextInColorCode(PVP_LABEL)
        end
    end
end)

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    
    if unit and UnitIsPlayer(unit) then
        local guildName = GetGuildInfo(unit)

        if guildName and lineData.leftText:find(guildName) then
            return
        end

        if lineData.leftText == PVP then
            lineData.leftText = ""
        end
    end
end)