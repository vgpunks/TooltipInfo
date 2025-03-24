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
    local name = UnitName(unit)
    if UnitIsUnit(unit, "player") then
        return PLAYER_LABEL
    elseif UnitIsPlayer(unit) then
        local classFilename = select(2, UnitClass(unit))
        if classFilename then
            local classColor = RAID_CLASS_COLORS[classFilename] or HIGHLIGHT_FONT_COLOR
            if classColor then
                return classColor:WrapTextInColorCode(name)
            end
        end
    elseif UnitReaction(unit, "player") then
        local factionColor = FACTION_BAR_COLORS[UnitReaction(unit, "player")]
        if factionColor then
            return factionColor:WrapTextInColorCode(name)
        end
    else
        return WHITE_FONT_COLOR:WrapTextInColorCode(name)
    end
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