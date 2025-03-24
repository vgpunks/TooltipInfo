local UnitIsPlayer = UnitIsPlayer
local GetGuildInfo = GetGuildInfo

local GUILD_FORMAT = "%s <%s>"
local GUILD_FULLNAME_FORMAT = "%s-%s"
local GUILD_LABEL = GREEN_FONT_COLOR:WrapTextInColorCode(GUILD_FORMAT)

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()

    if unit and UnitIsPlayer(unit) then
        local guildName, guildRankName, _, guildRealm = GetGuildInfo(unit)

        if not guildName then
            return
        end

        if lineData.leftText:find(guildName) and not lineData.isGuildLine then
            lineData.isGuildLine = true

            local guildFullName = guildName

            if guildRealm and IsShiftKeyDown() then
                guildFullName = GUILD_FULLNAME_FORMAT:format(guildName, guildRealm)
            end

            lineData.leftText = GUILD_LABEL:format(guildFullName, guildRankName)
        end
    end
end)