local select = select

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
local MOUNT_LABEL = "Mount ID"
local TOY_LABEL = "Toy ID"
local CURRENCY_LABEL = "Currency ID"

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

TooltipDataProcessor.AddTooltipPostCall(TooltipDataProcessor.AllTypes, function(tooltip, data)
    if not IsShiftKeyDown() then return end
    if tooltip:IsForbidden() then return end

    local label = ID
    local id = data and data.id

    if data.type == Enum.TooltipDataType.Item then
        if not id then
            local GetItem = tooltip.GetItem
            if GetItem then
                local _, link = GetItem(tooltip)
                id = link:match(LINK_PATTERN)
            end
        end
        label = ITEM_LABEL
    elseif data.type == Enum.TooltipDataType.Spell then
        if not id then
            id = select(2, tooltip:GetSpell())
        end
        label = SPELL_LABEL
    elseif data.type == Enum.TooltipDataType.UnitAura then
        if not id then
            local info = tooltip:GetPrimaryTooltipInfo()
            if info and info.getterArgs then
                local unit, index, filter = unpack(info.getterArgs)
                local auraData = GetAuraDataByIndex(unit, index, filter)
                id = auraData.spellId
            end
        end
        label = AURA_LABEL
    elseif data.type == Enum.TooltipDataType.Mount then
        label = MOUNT_LABEL
    elseif data.type == Enum.TooltipDataType.CompanionPet then
        if not id then
            local info = tooltip:GetPrimaryTooltipInfo()
            if info and info.getterArgs then
                local battlePetGuid = unpack(info.getterArgs)
                id = C_PetJournal.GetPetInfoByPetID(battlePetGuid)
            end
        end
        label = BATTLE_PET_LABEL
    elseif data.type == Enum.TooltipDataType.Toy then
        label = TOY_LABEL
    elseif data.type == Enum.TooltipDataType.Currency then
        label = CURRENCY_LABEL
    end

    AddTooltipLine(tooltip, label, id)
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