
local MTR = MekTownRecruit

local function SafeKeyPart(v)
    v = tostring(v or "")
    v = v:gsub("^%s+", ""):gsub("%s+$", "")
    v = v:gsub("[|:;]", "")
    if v == "" then v = "Unknown" end
    return v
end

local function CurrentRealm()
    return SafeKeyPart((GetRealmName and GetRealmName()) or "UnknownRealm")
end

local function CurrentGuildName()
    local guild = (GetGuildInfo and GetGuildInfo("player")) or nil
    guild = tostring(guild or ""):gsub("^%s+", ""):gsub("%s+$", "")
    if guild ~= "" then return guild end
    return nil
end

function MTR.GetLiveGuildName()
    return CurrentGuildName()
end

function MTR.GetGuildKey(strict)
    local guild = CurrentGuildName()
    local realm = CurrentRealm()
    if guild and guild ~= "" then
        return realm .. "|" .. SafeKeyPart(guild)
    end
    if strict then return nil end
    return realm .. "|LOADING..."
end

function MTR.GetGuildId(create)
    return nil
end

function MTR.SetGuildId(guildId)
    return nil
end

function MTR.GetGuildIdentityInfo()
    local realm = CurrentRealm()
    local guild = CurrentGuildName()
    return {
        guildKey = guild and (realm .. "|" .. SafeKeyPart(guild)) or (realm .. "|LOADING..."),
        guildId = nil,
        realm = realm,
        guildName = guild or "LOADING...",
    }
end

function MTR.RefreshGuildIdentityUI()
    if MTR.mainWin and MTR.mainWin._refreshGuildTab then pcall(MTR.mainWin._refreshGuildTab) end
end

function MTR.EnsureGuildIdentity()
    local key = MTR.GetGuildKey(true)
    return key
end

function MTR.GetGuildStore(create)
    if type(MekTownRecruitDB) ~= "table" then MekTownRecruitDB = {} end
    if type(MekTownRecruitDB.guilds) ~= "table" then MekTownRecruitDB.guilds = {} end
    local key = MTR.GetGuildKey(true)
    if not key then return nil end
    local gs = MekTownRecruitDB.guilds[key]
    if not gs and create ~= false then
        gs = {
            meta = {},
            dkpLedger = {},
            recruitHistory = {},
            familyTree = {},
            inactivityKickLog = {},
            guildBank = {},
            guildBankLedger = { entries = {}, meta = {} },
            syncState = {},
            eventLog = {},
        }
        MekTownRecruitDB.guilds[key] = gs
    end
    if gs then
        gs.meta = gs.meta or {}
        gs.meta.guildKey = key
        gs.meta.realm = CurrentRealm()
        gs.meta.guildName = CurrentGuildName() or ""
        gs.dkpLedger = gs.dkpLedger or {}
        gs.recruitHistory = gs.recruitHistory or {}
        gs.familyTree = gs.familyTree or {}
        gs.inactivityKickLog = gs.inactivityKickLog or {}
        gs.guildBank = gs.guildBank or {}
        gs.guildBankLedger = gs.guildBankLedger or { entries = {}, meta = {} }
        gs.guildBankLedger.entries = gs.guildBankLedger.entries or {}
        gs.guildBankLedger.meta = gs.guildBankLedger.meta or {}
        gs.syncState = gs.syncState or {}
        gs.eventLog = gs.eventLog or {}
    end
    return gs
end

function MTR.IsGuildOfficerName(name)
    if not name or name == "" or not IsInGuild() then return false end
    local short = tostring(name):match("^([^%-]+)") or tostring(name)
    local num = GetNumGuildMembers() or 0
    for i = 1, num do
        local n, rankName, rankIndex = GetGuildRosterInfo(i)
        local sn = n and (n:match("^([^%-]+)") or n)
        if sn == short then
            if tonumber(rankIndex) == 0 or tonumber(rankIndex) == 1 then return true end
            local rk = tostring(rankName or ""):upper()
            if rk:find("OFFIC", 1, true) or rk:find("LEAD", 1, true) or rk:find("ADMIN", 1, true) then
                return true
            end
            return false
        end
    end
    return false
end

function MTR.SendGuildScoped(prefix, payload)
    if not IsInGuild() then return false end
    local key = MTR.GetGuildKey(true)
    if not key then return false end
    local packed = "MTRSYNC:" .. key .. ":" .. tostring(payload or "")
    SendAddonMessage(prefix, packed, "GUILD")
    return true
end

function MTR.UnpackGuildScoped(message, sender, requireOfficer)
    if type(message) ~= "string" then return nil end
    local senderName = (sender or ""):match("^([^%-]+)") or (sender or "")
    local payload = message
    if message:sub(1, 8) == "MTRSYNC:" then
        local rest = message:sub(9)
        local guildKey, inner = rest:match("^(.-):(.*)$")
        if not guildKey or inner == nil then return nil end
        local localKey = MTR.GetGuildKey(true)
        if not localKey or guildKey ~= localKey then return nil end
        payload = inner
    end
    if requireOfficer and MTR.IsGuildOfficerName and not MTR.IsGuildOfficerName(senderName) then
        return nil
    end
    return payload, senderName
end

local _mtrGuildIdentityFrame = CreateFrame("Frame")
_mtrGuildIdentityFrame:RegisterEvent("PLAYER_LOGIN")
_mtrGuildIdentityFrame:RegisterEvent("PLAYER_GUILD_UPDATE")
_mtrGuildIdentityFrame:RegisterEvent("GUILD_ROSTER_UPDATE")
_mtrGuildIdentityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
_mtrGuildIdentityFrame:SetScript("OnEvent", function(self, event)
    if event == "PLAYER_LOGIN" or event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_GUILD_UPDATE" then
        if GuildRoster then pcall(GuildRoster) end
    end
    if MTR.BindGuildScopedTables then MTR.BindGuildScopedTables() end
    MTR.RefreshGuildIdentityUI()
end)

function MTR.BindGuildScopedTables()
    local gs = MTR.GetGuildStore(true)
    if type(gs) ~= "table" then return nil end
    local profile = MTR.GetActiveProfile and MTR.GetActiveProfile() or MTR.db
    if type(profile) == "table" then
        profile.dkpLedger = gs.dkpLedger
        profile.recruitHistory = gs.recruitHistory
        profile.familyTree = gs.familyTree
        profile.inactivityKickLog = gs.inactivityKickLog
    end
    MekTownRecruitDB.guildBank = gs.guildBank
    MekTownRecruitDB.guildBankLedger = gs.guildBankLedger
    MekTownRecruitDB.syncState = gs.syncState
    MTR.guildStore = gs
    return gs
end

local function IsEmptyTable(t)
    return type(t) == "table" and next(t) == nil
end

function MTR.MigrateGuildScopedData()
    local gs = MTR.GetGuildStore(true)
    local profile = MTR.GetActiveProfile and MTR.GetActiveProfile() or MTR.db
    if type(gs) ~= "table" then return nil end

    if type(profile) == "table" then
        if not IsEmptyTable(profile.dkpLedger) and IsEmptyTable(gs.dkpLedger) then gs.dkpLedger = MTR.DeepCopy(profile.dkpLedger) end
        if not IsEmptyTable(profile.recruitHistory) and IsEmptyTable(gs.recruitHistory) then gs.recruitHistory = MTR.DeepCopy(profile.recruitHistory) end
        if not IsEmptyTable(profile.familyTree) and IsEmptyTable(gs.familyTree) then gs.familyTree = MTR.DeepCopy(profile.familyTree) end
        if not IsEmptyTable(profile.inactivityKickLog) and IsEmptyTable(gs.inactivityKickLog) then gs.inactivityKickLog = MTR.DeepCopy(profile.inactivityKickLog) end
    end
    if not IsEmptyTable(MekTownRecruitDB.guildBank) and IsEmptyTable(gs.guildBank) then gs.guildBank = MTR.DeepCopy(MekTownRecruitDB.guildBank) end
    local gbl = MekTownRecruitDB.guildBankLedger
    if type(gbl) == "table" and ((type(gbl.entries)=="table" and next(gbl.entries)) or (type(gbl.meta)=="table" and next(gbl.meta))) then
        if IsEmptyTable(gs.guildBankLedger.entries) and IsEmptyTable(gs.guildBankLedger.meta) then
            gs.guildBankLedger = MTR.DeepCopy(gbl)
        end
    end
    if type(MekTownRecruitDB.syncState) == "table" and next(MekTownRecruitDB.syncState) and IsEmptyTable(gs.syncState) then
        gs.syncState = MTR.DeepCopy(MekTownRecruitDB.syncState)
    end

    gs.guildBankLedger = gs.guildBankLedger or { entries = {}, meta = {} }
    gs.guildBankLedger.entries = gs.guildBankLedger.entries or {}
    gs.guildBankLedger.meta = gs.guildBankLedger.meta or {}
    gs.syncState = gs.syncState or {}
    gs.eventLog = gs.eventLog or {}

    if type(profile) == "table" then
        profile.dkpLedger = gs.dkpLedger
        profile.recruitHistory = gs.recruitHistory
        profile.familyTree = gs.familyTree
        profile.inactivityKickLog = gs.inactivityKickLog
    end
    MekTownRecruitDB.guildBank = gs.guildBank
    MekTownRecruitDB.guildBankLedger = gs.guildBankLedger
    MekTownRecruitDB.syncState = gs.syncState
    MTR.guildStore = gs
    return gs
end

function MTR.AppendGuildEvent(dataset, action, payload)
    local gs = MTR.GetGuildStore(true)
    if not gs then return end
    local log = gs.eventLog or {}
    gs.eventLog = log
    local last = log[#log]
    local prevHash = last and last.hash or "0"
    local body = table.concat({
        tostring(time()),
        tostring(MTR.playerName or "?"),
        tostring(dataset or "?"),
        tostring(action or "?"),
        tostring(prevHash),
        tostring(payload or "")
    }, "|")
    local hash = (MTR.Hash and MTR.Hash(body)) or body
    log[#log + 1] = {
        ts = time(),
        actor = MTR.playerName or "?",
        dataset = dataset or "?",
        action = action or "?",
        payload = payload,
        prevHash = prevHash,
        hash = hash,
    }
    if #log > 1500 then
        tremove(log, 1)
    end
end
