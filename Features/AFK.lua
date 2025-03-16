local UnitIsPlayer = UnitIsPlayer
local UnitIsAFK = UnitIsAFK
local UnitIsDND = UnitIsDND
local UnitIsConnected = UnitIsConnected

local PLAYER_BUSY_FORMAT = " |cff00cc00%s|r"
local DISCONNECTED = "<DC>"

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.UnitName, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local unit = lineData.unitToken

    if unit and UnitIsPlayer(unit) then
        local afk = UnitIsAFK(unit) and CHAT_FLAG_AFK
        local dnd = UnitIsDND(unit) and CHAT_FLAG_DND
        local dc = not UnitIsConnected(unit) and DISCONNECTED
        lineData.leftText = lineData.leftText .. PLAYER_BUSY_FORMAT:format(afk or dnd or dc or "")
    end
end)