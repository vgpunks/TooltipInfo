local UnitIsUnit = UnitIsUnit
local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local UnitReaction = UnitReaction
local UnitName = UnitName
local UnitExists = UnitExists

local _G = _G
local TARGET = TARGET
local FACTION_BAR_COLORS = FACTION_BAR_COLORS
local RAID_CLASS_COLORS = RAID_CLASS_COLORS

local PLAYER_LABEL = WHITE_FONT_COLOR:WrapTextInColorCode("<You>")
local THE_TARGET_FORMAT = NORMAL_FONT_COLOR:WrapTextInColorCode(TARGET .. ": %s")

local function GetTargetName(unit)
    local name, color = nil, nil
    if UnitIsUnit(unit, "player") then
        return PLAYER_LABEL
    elseif UnitIsPlayer(unit) then
        local classFilename = select(2, UnitClass(unit))
        if classFilename then
            color = RAID_CLASS_COLORS[classFilename]
        end
    else
        local reaction = UnitReaction(unit, "player")
        if reaction then
            color = FACTION_BAR_COLORS[reaction]
        end
    end
    name = UnitName(unit)
    color = color or WHITE_FONT_COLOR
    return color:WrapTextInColorCode(name)
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Unit, function(tooltip)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
    
    if unit then
        local numLines = tooltip:NumLines()

        for i = 1, numLines do
            local line = _G["GameTooltipTextLeft" .. i]
            local text = line:GetText()
            local unit = unit .. "target"

            if text and text:find(THE_TARGET_FORMAT:format(".+")) then
                if UnitExists(unit) then
                    line:SetText(THE_TARGET_FORMAT:format(GetTargetName(unit)))
                else
                    tooltip:SetUnit("mouseover")
                end
                break
            elseif i == numLines and UnitExists(unit) then
                tooltip:AddLine(THE_TARGET_FORMAT:format(GetTargetName(unit)))
            end
        end
    end
end)