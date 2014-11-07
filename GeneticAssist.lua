-----------------------------------------------------------------------------------------------
--   _____                 _   _                         _     _
--  / ____|               | | (_)          /\           (_)   | |
-- | |  __  ___ _ __   ___| |_ _  ___     /  \   ___ ___ _ ___| |_
-- | | |_ |/ _ \ '_ \ / _ \ __| |/ __|   / /\ \ / __/ __| / __| __|
-- | |__| |  __/ | | |  __/ |_| | (__   / ____ \\__ \__ \ \__ \ |_
--  \_____|\___|_| |_|\___|\__|_|\___| /_/    \_\___/___/_|___/\__|
--
-- slash command to turn the addon on/off: /ga
-----------------------------------------------------------------------------------------------

require "Window"
require "GameLib"
require "GroupLib"
require "ICCommLib"

-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local Apollo    = Apollo
local GameLib   = GameLib
local ICCommLib = ICCommLib
local Vector3   = Vector3
local pairs     = pairs
local ipairs    = ipairs
local math      = math
local table     = table
local Print     = Print

-- Packages
local GeminiDB
local GeminiLocale
local Encounters
local Util
local Line
local Marker
local Circle
local Notification

local nScreenWidth, _ = Apollo.GetScreenSize()

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------

local GeneticAssist = Apollo.GetPackage("Gemini:Addon-1.1").tPackage:NewAddon('GeneticAssist', false, { "Gemini:DB-1.0", "Gemini:Locale-1.0", "GeneticAssist:Config", "GeneticAssist:Utilities", "GeneticAssist:Line", "GeneticAssist:Circle", "GeneticAssist:Marker", "GeneticAssist:Notification" })

GeneticAssist.tCallbacks = {}
GeneticAssist.tUnits = {}
GeneticAssist.tGroupMembers = {}
local tDefaultSettings = {
	global = {
		tNotifications = {
			nLeft = (nScreenWidth / 2),
			nTop = 200,
			nHeight = 256,
			nWidth = 512
		}
	}
}

function GeneticAssist:OnInitialize()
	-- Load Packages
	GeminiDB     = Apollo.GetPackage("Gemini:DB-1.0").tPackage
	GeminiLocale = Apollo.GetPackage("Gemini:Locale-1.0").tPackage
	Config       = Apollo.GetPackage("GeneticAssist:Config").tPackage
	Colors       = Config.Colors
	Encounters   = Config.Encounters
	Util         = Apollo.GetPackage("GeneticAssist:Utilities").tPackage
	Line         = Apollo.GetPackage("GeneticAssist:Line").tPackage
	Circle       = Apollo.GetPackage("GeneticAssist:Circle").tPackage
	Marker       = Apollo.GetPackage("GeneticAssist:Marker").tPackage
	Notification = Apollo.GetPackage("GeneticAssist:Notification").tPackage

	-- Register Slash
	Apollo.RegisterSlashCommand("ga", "SlashCommand", self)

	-- Load Sprite File
	Apollo.LoadSprites("Sprites.xml")

	-- Load Window
  self.xmlDoc = XmlDoc.CreateFromFile("GeneticAssist.xml")
  self.xmlDoc:RegisterCallback("OnDocumentReady", self)

	-- Load Database
	self.db = GeminiDB:New(self, tDefaultSettings)

	-- Load Locale
	self.locale = GeminiLocale:GetLocale("GeneticAssist", true)
end

function GeneticAssist:OnDocumentReady()
	self.gameOverlay = Apollo.LoadForm(self.xmlDoc, "GameOverlay",'InWorldHudStratum', self)

	-- Unit Monitoring
	Apollo.RegisterEventHandler("UnitCreated",          "OnUnitCreated",         self) -- Unit Created
	Apollo.RegisterEventHandler("UnitDestroyed",        "OnUnitDestroyed",       self) -- Unit Destroyed

  -- Group Monitoring
	Apollo.RegisterEventHandler("Group_Join",           "OnGroupJoin",           self) -- I Joined a Group
	Apollo.RegisterEventHandler("Group_Left",           "OnGroupLeft",           self) -- I Left a Group
	Apollo.RegisterEventHandler("Group_Add",            "OnGroupAdd",            self) -- A Group Member was Added
	Apollo.RegisterEventHandler("Group_Remove",         "OnGroupRemove",         self) -- A Group Member was Removed / Left
	Apollo.RegisterEventHandler("Group_MemberPromoted", "OnGroupMemberPromoted", self) -- Group Leader Change

  if GroupLib.InRaid() or GroupLib.InGroup() then
  	self:OnGroupJoin()
  end
end

function GeneticAssist:SlashCommand()
	self.options:Show()
end

-----------------------------------------------------------------------------------------------
--   _    _       _ _       __  __                                                   _
--  | |  | |     (_) |     |  \/  |                                                 | |
--  | |  | |_ __  _| |_    | \  / | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_
--  | |  | | '_ \| | __|   | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '_ ` _ \ / _ \ '_ \| __|
--  | |__| | | | | | |_    | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_
--   \____/|_| |_|_|\__|   |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|
--                                                    __/ |
--                                                   |___/
-----------------------------------------------------------------------------------------------

function GeneticAssist:OnUnitCreated(tUnit)
	if not tUnit then return; end

	local unitid = tUnit:GetId()
	local unitname = tUnit:GetName()
	local config = Encounters[unitname]
	if config and not self.tUnits[unitid] then
		-- Print(unitid..": "..unitname.." ~ Created")
		self.tUnits[unitid] = { ['unit'] = tUnit, ['name'] = unitname, ['config'] = config }
		self:CreateUnit(self.tUnits[unitid])

		if Util:TableLength(self.tUnits) == 1 then
			Apollo.RegisterEventHandler("NextFrame", "OnUpdate", self)
		end
	end
end

function GeneticAssist:OnUpdate()
	if not self.tUnits then return end

	for _, unit in pairs(self.tUnits) do
		if unit then
			if unit['unit']:IsInCombat() or unit['config']['SkipCombatCheck'] == true then
				self:UpdateUnit(unit)
			else
				self:HideUnit(unit)
			end
		end
	end
end

function GeneticAssist:OnUnitDestroyed(tUnit)
	if not tUnit then return; end

	local unitid = tUnit:GetId()
	if self.tUnits[unitid] then
		-- Print(unitid..": "..tUnit:GetName().." ~ Destroyed")
		self:DestroyUnit(self.tUnits[unitid])
		self.tUnits[unitid] = nil

		if Util:TableLength(self.tUnits) == 0 then
			Apollo.RemoveEventHandler("NextFrame", self)
		end
	end
end

-- Callbacks (used so encounters can bind to specific events)
function GeneticAssist:SetEncounter(unitname, config)
	-- if we're sending it nothing and our encounter already exists, lets not override it
	if config == nil and Encounters[unitname] ~= nil then return end

	-- Add encounter configs
	Encounters[unitname] = config or {}
end

function GeneticAssist:RegisterUnitCallback(unitname, type, method, scope)
	if not self.tCallbacks[unitname] then self.tCallbacks[unitname] = {} end

	-- Verify we have an encounter
	self:SetEncounter(unitname, config)

	-- Set Callback
	self.tCallbacks[unitname][type] = { ['Method'] = method, ['Scope'] = scope }
end

function GeneticAssist:FireUnitCallback(unit, type)
	if self.tCallbacks[unit['name']] and self.tCallbacks[unit['name']][type] then
		local scope = self.tCallbacks[unit['name']][type]['Scope']
		local method = self.tCallbacks[unit['name']][type]['Method']

		scope[method](scope, unit)
	end
end

function GeneticAssist:CreateUnit(unit)
	local config = unit['config']

	self:FireUnitCallback(unit, 'OnCreate')

	if config['Line'] then
		unit['Line'] = Line(self.gameOverlay, 'solid', config['Line']['Color'], config['Line']['Thickness'], true);
	end

	if config['Circle'] then
		unit['Circle'] = Circle(self.gameOverlay, config['Circle']['Resolution'], config['Circle']['Thickness'], config['Circle']['Color'], config['Circle']['Height'], config['Circle']['Outline']);
	end

	if config['Marker'] then
		unit['Marker'] = Marker(self.gameOverlay, config['Marker']['Sprite'], config['Marker']['Color'], config['Marker']['Width'], config['Marker']['Height'], true);
	end

	if config['Notification'] then
		unit['Notification'] = Notification(self.gameOverlay, config['Notification'], nil, self.db.global.tNotifications)
		unit['Notification']:Show()
	end

	if config['DeBuff'] then
		unit['DeBuff'] = {}
		for buffname, sprite in pairs(config['DeBuff']) do
			unit['DeBuff'][buffname] = Notification(self.gameOverlay, sprite, nil, self.db.global.tNotifications)
		end
	end

	if config['Buff'] then
		unit['Buff'] = {}
		for buffname, sprite in pairs(config['Buff']) do unit['Buff'][buffname] = Notification(self.gameOverlay, sprite, nil, self.db.global.tNotifications) end
	end

	if config['Cast'] then
		unit['Cast'] = {}
		for spellname, sprite in pairs(config['Cast']) do unit['Cast'][spellname] = Notification(self.gameOverlay, sprite, nil, self.db.global.tNotifications) end
	end
end


function GeneticAssist:DestroyUnit(unit)
	local config = unit['config']

	self:FireUnitCallback(unit, 'OnDestroy')

	if config['Line'] then
		unit['Line']:Destroy()
	end

	if config['Circle'] then
		unit['Circle']:Destroy()
	end

	if config['Marker'] then
		unit['Marker']:Destroy()
	end

	if config['Notification'] then
		unit['Notification']:Destroy()
	end

	if config['DeBuff'] then
		for buffname, _ in pairs(config['DeBuff']) do
			unit['DeBuff'][buffname]:Destroy()
		end
		unit['DeBuff'] = {}
	end

	if config['Buff'] then
		for buffname, _ in pairs(config['Buff']) do
			unit['Buff'][buffname]:Destroy()
		end
		unit['Buff'] = {}
	end

	if config['Cast'] then
		for spellname, _ in pairs(config['Cast']) do
			unit['Cast'][spellname]:Destroy()
		end
		unit['Cast'] = {}
	end
end

function GeneticAssist:HideUnit(unit)
	local config = unit['config']

	self:FireUnitCallback(unit, 'OnHide')

	if config['Line'] then
		unit['Line']:Hide()
	end

	if config['Circle'] then
		unit['Circle']:Hide()
	end

	if config['Marker'] then
		unit['Marker']:Hide()
	end

	if config['Notification'] then
		unit['Notification']:Hide()
	end

	if config['DeBuff'] then
		for buffname, _ in pairs(config['DeBuff']) do
			unit['DeBuff'][buffname]:Hide()
		end
	end

	if config['Buff'] then
		for buffname, _ in pairs(config['Buff']) do
			unit['Buff'][buffname]:Hide()
		end
	end

	if config['Cast'] then
		for spellname, _ in pairs(config['Cast']) do
			unit['Cast'][spellname]:Hide()
		end
	end
end

function GeneticAssist:UpdateUnit(unit)
	local config = unit['config']

	self:FireUnitCallback(unit, 'OnUpdate')

	if config['Line'] then
		unit['Line']:Show()
		unit['Line']:Draw(GameLib.GetPlayerUnit():GetPosition(), unit['unit']:GetPosition())
	end

	if config['Marker'] then
		unit['Marker']:Show()
		unit['Marker']:Draw(unit['unit']:GetPosition())
	end

	if config['Notification'] then
		unit['Notification']:Show()
	end

	if config['Circle'] then
		local tPos = unit['unit']:GetPosition()
		local tPosVector= Vector3.New(tPos.x, tPos.y, tPos.z) -- why?
		local tFacing = unit['unit']:GetFacing()
		local tAngle = math.atan2(tFacing.x, tFacing.z)
		unit['Circle']:Show()
		unit['Circle']:Draw(tPos, config['Circle']['Radius'], tAngle, config['Circle']['Color'])
	end

	if config['DeBuff'] then
		local debuffs = Util:GetBuffList(GameLib.GetPlayerUnit(), 'arHarmful')
		for buffname, _ in pairs(config['DeBuff']) do
			unit['DeBuff'][buffname]:Active(debuffs[buffname])
		end
	end

	if config['Buff'] then
		local buffs = Util:GetBuffList(GameLib.GetPlayerUnit(), 'arBeneficial')
		for buffname, _ in pairs(config['Buff']) do
			unit['Buff'][buffname]:Active(buffs[buffname])
		end
	end

	if config['Cast'] then
		-- Error!
		for spellname, _ in pairs(config['Cast']) do
			unit['Cast'][spellname]:Active(unit['unit']:ShouldShowCastBar() and unit['unit']:GetCastName() == spellname)
		end
	end
end


-----------------------------------------------------------------------------------------------
--   _____                          __  __                                                   _
--  / ____|                        |  \/  |                                                 | |
-- | |  __ _ __ ___  _   _ _ __    | \  / | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_
-- | | |_ | '__/ _ \| | | | '_ \   | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '_ ` _ \ / _ \ '_ \| __|
-- | |__| | | | (_) | |_| | |_) |  | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_
--  \_____|_|  \___/ \__,_| .__/   |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|
--                        | |                                 __/ |
--                        |_|                                |___/
-----------------------------------------------------------------------------------------------

-- You've joined a group
function GeneticAssist:OnGroupJoin()
	self:UpdateGroup()
end

-- You've left a group
function GeneticAssist:OnGroupLeft()
  self.channelName = nil
  self.channel = nil
  self.tGroupMembers = {}
end

-- A member has joined your group
function GeneticAssist:OnGroupAdd(strMemberName)
	self:UpdateGroup()
end

-- A member has left your group
function GeneticAssist:OnGroupRemove(strMemberName, eReason)
  if eReason == GroupLib.RemoveReason.Disband then return; end
	self.tGroupMembers[strMemberName] = nil
end

-- A member has been promoted to party leader
function GeneticAssist:OnGroupMemberPromoted(strMemberName)
	self.groupLeader = strMemberName
	self.channelName = tostring(string.gsub(self.groupLeader, "%s+", "_") .. "_GA")
	self.channel = ICCommLib.JoinChannel(self.channelName, "OnChanMessage", self)
end

function GeneticAssist:UpdateGroup()
	for i = 1, GroupLib.GetMemberCount(), 1 do
    local tGroupMember = GroupLib.GetGroupMember(i)
    if tGroupMember.bIsLeader then
    	self:OnGroupMemberPromoted(tGroupMember.strCharacterName)
    end
		self.tGroupMembers[tGroupMember.strCharacterName] = tGroupMember
  end
end

function GeneticAssist:DebugGroup()
	Print("Group Members:")
  for name, member in pairs(self.tGroupMembers) do
  	if member then
  		Print("Group Member: "..name)
  	end
  end
end

-----------------------------------------------------------------------------------------------
--              _     _                 __  __                           _
--     /\      | |   | |               |  \/  |                         (_)
--    /  \   __| | __| | ___  _ __     | \  / | ___  ___ ___  __ _  __ _ _ _ __   __ _
--   / /\ \ / _` |/ _` |/ _ \| '_ \    | |\/| |/ _ \/ __/ __|/ _` |/ _` | | '_ \ / _` |
--  / ____ \ (_| | (_| | (_) | | | |   | |  | |  __/\__ \__ \ (_| | (_| | | | | | (_| |
-- /_/    \_\__,_|\__,_|\___/|_| |_|   |_|  |_|\___||___/___/\__,_|\__, |_|_| |_|\__, |
--                                                                  __/ |         __/ |
--                                                                 |___/         |___/
-----------------------------------------------------------------------------------------------

function GeneticAssist:OnChanMessage(channel, message)
  if self.channelName ~= channel then return; end
end

function GeneticAssist:SendMessage(mSender, mType, mBody)
  if not self.channel then return; end
  self.channel:SendMessage({ sender = mSender, type = mType, body = mBody })
end