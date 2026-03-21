-- .luacheckrc
-- Config for MekTown Recruit WoW Addon

globals = {
    -- WoW Globals (3.3.5a)
    "MekTownRecruit", "MekTownRecruitDB", "MTR", "CfgDB", "SaveValue", "SaveBool", "SaveTable", "SaveSlider", "SaveText", "MP", "MPE", "Trunc",
    "CreateFrame", "UIParent", "GameTooltip", "StaticPopupDialogs", "StaticPopup_Show", "UnitName", "GetRealmName",
    "UnitClass", "UnitRace", "UnitLevel", "GetRealZoneText", "GetZoneText", "GetMoney", "IsInGuild", "IsInRaid", "IsInGroup",
    "GetNumRaidMembers", "GetNumPartyMembers", "GetNumGuildMembers", "GetGuildRosterInfo", "GuildRoster", "GuildUninvite",
    "SendAddonMessage", "RegisterAddonMessagePrefix", "SendChatMessage", "GetContainerNumSlots", "GetContainerItemInfo",
    "GetInventoryItemLink", "GetItemInfo", "GetItemLink", "GetSkillLineInfo", "GetNumSkillLines", "ATTACHMENTS_MAX_RECEIVE",
    "GetInboxNumItems", "GetInboxItemLink", "GetInboxItem", "hooksecurefunc", "UnitAffectingCombat", "PlaySound", "date", "time",
    "wipe", "tremove", "tinsert", "math", "string", "table", "pairs", "ipairs", "tonumber", "tostring", "print", "select",
    "type", "unpack", "error", "pcall", "xpcall", "assert", "getmetatable", "setmetatable", "rawget", "rawset", "next",
    "raidevent", "bit", "DEFAULT_CHAT_FRAME", "ChatFrame1", "SlashCmdList", "SLASH_MEKTOWN1", "SLASH_MEKTOWN2", "SLASH_MTRID1",
    "InterfaceOptionsFrame_OpenToCategory", "InterfaceOptionsFrameAddOns", "UIOptionsFrame_AddOns", "UIDropDownMenu_Initialize",
    "UIDropDownMenu_AddButton", "UIDropDownMenu_CreateInfo", "UIDropDownMenu_SetSelectedValue", "UIDropDownMenu_GetSelectedValue",
    "UIDropDownMenu_SetWidth", "UIDropDownMenu_SetText", "UIDROPDOWNMENU_INIT_MENU", "CloseDropDownMenus", "DropDownList1", "DropDownList2",
    "UnitPopup_ShowMenu", "UnitPopupButtons", "UnitPopupMenus", "GuildControlGetNumRanks", "GuildControlGetRankName", "GuildControlSetRank",
    "GuildControlGetRankFlags", "GuildRosterSetOfficerNote", "SetGuildRosterShowOffline", "GetNumGuildBankTabs", "GetGuildBankTabInfo",
    "GetGuildBankItemLink", "GetGuildBankItemInfo", "QueryGuildBankLog", "GetNumGuildBankTransactions", "GetGuildBankTransaction",
    "SetCurrentGuildBankTab", "GuildBankMessageFrame", "GuildBankFrame", "GuildBankFrame_UpdateLog", "GameFontNormal", "GameFontHighlight",
    "GameFontNormalSmall", "GameFontHighlightSmall", "GameFontNormalLarge", "GameFontGreen", "ITEM_QUALITY_COLORS",
    "GetAverageItemLevel", "IsInInstance", "Minimap", "GetSpellLink", "GetSpellInfo", "GetChannelList", "GetNumDisplayChannels",
    "GetChannelName", "JoinChannelByName", "GetChannelDisplayInfo", "GuildSetMOTD", "GetGuildInfo", "UnitIsGroupAssistant", "IsRaidLeader",
    "IsPartyLeader", "IsGuildLeader", "GetTime", "MysticEnchantUtil", "_G", "geterrorhandler", "GetGuildRosterLastOnline",
    "GetRaidRosterInfo", "GuildInvite", "ChatFrame_SendTell", "InviteUnit", "IsShiftKeyDown", "ChatEdit_GetActiveWindow",
    "ChatEdit_InsertLink", "GetLootSlotInfo", "GetLootSlotLink", "GetNumLootItems", "MTR_Tooltip", "GetGuildRosterLastOnline",
    "RAID_CLASS_COLORS", "GetGuildRosterLastOnline", "GetNumDisplayChannels", "GetChannelName", "JoinChannelByName",
    "GetChannelDisplayInfo", "GuildSetMOTD", "GetGuildInfo", "UnitIsGroupAssistant", "IsRaidLeader", "IsPartyLeader",
    "IsGuildLeader", "GetTime", "MysticEnchantUtil", "date", "time", "ChatEdit_GetActiveWindow", "ChatEdit_InsertLink",
    "UnitExists", "UnitIsInMyGuild"
}

-- Global options
unused_args = true
redefined = true
unused_second_aries = true
