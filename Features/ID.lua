local select = select
local print = print

local GameTooltip = GameTooltip
local BattlePetTooltip = BattlePetTooltip
local IsShiftKeyDown = IsShiftKeyDown
local IsAltKeyDown = IsAltKeyDown
local GetDisplayedItem = TooltipUtil and TooltipUtil.GetDisplayedItem
local GetAuraDataByIndex = C_UnitAuras and C_UnitAuras.GetAuraDataByIndex
local GetQuestIDForLogIndex = C_QuestLog.GetQuestIDForLogIndex
local BattlePetToolTip_Show = BattlePetToolTip_Show
local QuestMapLogTitleButton_OnEnter = QuestMapLogTitleButton_OnEnter

local _G = _G
local ID = _G.ID

local ITEM_LABEL = "Item ID"
local SPELL_LABEL = "Spell ID"
local AURA_LABEL = "Aura ID"
local BATTLE_PET_LABEL = "Battle Pet ID"
local QUEST_LABEL = "Quest ID"

local ID_FORMAT = "|cffca3c3c<%s>|r %s"
local LINK_PATTERN = ":(%w+)"

local lastPrintedID

local function AddTooltipLine(tooltip, label, id, refresh)
    if tooltip and id then
        if IsAltKeyDown() and lastPrintedID ~= id then
            lastPrintedID = id
            StaticPopup_Show("TOOLTIPINFO_COPY_ID", label, nil, id)
        end
        id = ID_FORMAT:format(ID, id)
        tooltip:AddLine(id)
        if refresh then
            tooltip:Show()
        end
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, function(tooltip, data)
    if not IsShiftKeyDown() then return end
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local itemID = data and data.id

    if not itemID then
        local GetItem = GetDisplayedItem or tooltip.GetItem
        if GetItem then
            local _, link = GetItem(tooltip)
            itemID = link:match(LINK_PATTERN)
        end
    end

    AddTooltipLine(tooltip, ITEM_LABEL, itemID)
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, function(tooltip, data)
    if not IsShiftKeyDown() then return end
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local spellID = data and data.id

    if not spellID then
        spellID = select(2, tooltip:GetSpell())
    end

    AddTooltipLine(tooltip, SPELL_LABEL, spellID)
end)

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.UnitAura, function(tooltip, data)
    if not IsShiftKeyDown() then return end
    if tooltip:IsForbidden() then return end
    if tooltip ~= GameTooltip then return end

    local auraID = data and data.id

    if not auraID then
        local info = tooltip:GetPrimaryTooltipInfo()
        if info and info.getterArgs then
            local unit, index, filter = unpack(info.getterArgs)
            local auraData = GetAuraDataByIndex(unit, index, filter)
            auraID = auraData.spellId
        end
    end

    AddTooltipLine(tooltip, AURA_LABEL, auraID)
end)

hooksecurefunc("BattlePetToolTip_Show", function(battlePetSpeciesID)
    if not IsShiftKeyDown() then return end
    if BattlePetTooltip:IsForbidden() then return end

    AddTooltipLine(BattlePetTooltip, BATTLE_PET_LABEL, battlePetSpeciesID, true)
end)

hooksecurefunc("QuestMapLogTitleButton_OnEnter", function(frame)
    if not IsShiftKeyDown() then return end
    if GameTooltip:IsForbidden() then return end

    local questID = frame.questLogIndex and GetQuestIDForLogIndex(frame.questLogIndex)
    
    AddTooltipLine(GameTooltip, QUEST_LABEL, questID, true)
end)

hooksecurefunc("TaskPOI_OnEnter", function(frame)
    if not IsShiftKeyDown() then return end
    if GameTooltip:IsForbidden() then return end

    local questID = frame.questID

    AddTooltipLine(GameTooltip, QUEST_LABEL, questID, true)
end)
