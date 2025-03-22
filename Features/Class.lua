local UnitIsPlayer = UnitIsPlayer
local UnitClass = UnitClass
local GetGuildInfo = GetGuildInfo

local RAID_CLASS_COLORS = RAID_CLASS_COLORS

TooltipDataProcessor.AddLinePreCall(Enum.TooltipDataLineType.None, function(tooltip, lineData)
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local _, unit = tooltip:GetUnit()
 
    if unit and UnitIsPlayer(unit) then
        local guildName = GetGuildInfo(unit)

        if guildName and lineData.leftText:find(guildName) then
            return
        end

        local className, classFilename = UnitClass(unit)

        if not className or not classFilename then
            return
        end
        
        if lineData.leftText:find(className) then
            local classColor = RAID_CLASS_COLORS[classFilename]
            if classColor then
                lineData.leftText = classColor:WrapTextInColorCode(lineData.leftText)
            end
        end
    end
end)