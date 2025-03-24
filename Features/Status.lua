local UnitIsPlayer = UnitIsPlayer
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsConnected = UnitIsConnected

local AFK = AFK
local DND = DND
local PLAYER_OFFLINE = PLAYER_OFFLINE

local PLAYER_STATUS_FORMAT = " <%s>" 
local PLAYER_STATUS_LABEL = {
    ["AFK"] = GREEN_FONT_COLOR:WrapTextInColorCode(PLAYER_STATUS_FORMAT:format(AFK)),
    ["DND"] = RED_FONT_COLOR:WrapTextInColorCode(PLAYER_STATUS_FORMAT:format(DND)),
    ["OFFLINE"] = GRAY_FONT_COLOR:WrapTextInColorCode(PLAYER_STATUS_FORMAT:format(PLAYER_OFFLINE))
}

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        local afk = UnitIsAFK(unit) and PLAYER_STATUS_LABEL["AFK"]
        local dnd = UnitIsDND(unit) and PLAYER_STATUS_LABEL["DND"]
        local dc = not UnitIsConnected(unit) and PLAYER_STATUS_LABEL["OFFLINE"]

        lineData.leftText = lineData.leftText .. (afk or dnd or dc or "")
    end
end)