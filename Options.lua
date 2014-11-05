require "Window"

local GA = GeneticAssist

local GeneticAssistOptions = {
  tTabControls = {},
  tTabButtons = {},
  tOptionsList = {
    General = {
      Settings = "Add-on Settings",
      Interrupts = "Interrupt Groups"
    },
    Encounters = {
      Kuralak = "Kuralak the Defiler",
      PhageMaw = "Phage Maw",
      Convergence = "Phageborn Convergence",
      Ohmna = "Dreadphage Ohmna"
    }
  }
}

function GeneticAssistOptions:new(o)
    o = o or {}
    setmetatable(o, self)
    self.__index = self
    return o
end

--------------------------------------------------------------------------------------------------------------
-- __          ___           _                 __  __                                                   _
-- \ \        / (_)         | |               |  \/  |                                                 | |
--  \ \  /\  / / _ _ __   __| | _____      __ | \  / | __ _ _ __   __ _  __ _  ___ _ __ ___   ___ _ __ | |_
--   \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / / | |\/| |/ _` | '_ \ / _` |/ _` |/ _ \ '_ ` _ \ / _ \ '_ \| __|
--    \  /\  /  | | | | | (_| | (_) \ V  V /  | |  | | (_| | | | | (_| | (_| |  __/ | | | | |  __/ | | | |_
--     \/  \/   |_|_| |_|\__,_|\___/ \_/\_/   |_|  |_|\__,_|_| |_|\__,_|\__, |\___|_| |_| |_|\___|_| |_|\__|
--                                                                       __/ |
--                                                                      |___/
--------------------------------------------------------------------------------------------------------------

function GeneticAssistOptions:OnLoad()
end

function GeneticAssistOptions:Show()
  self.settings = GeneticAssist.settings

  if self.xmlDoc == nil then
    self.xmlDoc = XmlDoc.CreateFromFile("Options.xml")
    self.wndOpt = Apollo.LoadForm(self.xmlDoc, "GeneticAssistOptions", nil, self)
    self:BuildOptionsWindow()
    self:BuildOptionsList()
  end

  self.wndOpt:Show(true)
end

function GeneticAssistOptions:Hide()
  self.wndOpt:Show(false)
end

function GeneticAssistOptions:BuildOptionsList()
  local build = function(list, parent)
    for tab, label in pairs(list) do
      local wnd = Apollo.LoadForm(self.xmlDoc, "MiddleLevel", parent, self)
      wnd:FindChild("MiddleLevelBtnText"):SetText(label)
      wnd:FindChild("MiddleLevelBtnText"):SetTextColor(ApolloColor.new("UI_TextMetalGoldHighlight"))
      wnd:FindChild("MiddleLevelBtn"):SetData(tostring(tab.."Tab"))
      self.tTabButtons[tostring(tab.."Tab")] = wnd
    end
    parent:ArrangeChildrenVert()
  end

  build(self.tOptionsList.General,    self.wndOpt:FindChild("GeneralSideScroll"))
  build(self.tOptionsList.Encounters, self.wndOpt:FindChild("EncounterSideScroll"))

  -- Show Default
  self.tTabButtons["SettingsTab"]:FindChild("MiddleLevelBtn"):SetCheck(true)
end

function GeneticAssistOptions:BuildOptionsWindow()
  local container = self.wndOpt:FindChild("OptionsContainer")
  for tab, label in pairs(self.tOptionsList.General) do
    self.tTabControls[tostring(tab.."Tab")] = Apollo.LoadForm(self.xmlDoc, tostring(tab.."Tab"), container, self)
    self.tTabControls[tostring(tab.."Tab")]:Show(false)
  end
  for tab, label in pairs(self.tOptionsList.Encounters) do
    self.tTabControls[tostring(tab.."Tab")] = Apollo.LoadForm(self.xmlDoc, tostring(tab.."Tab"), container, self)
    self.tTabControls[tostring(tab.."Tab")]:Show(false)
  end

  -- Show Default
  self.tTabControls["SettingsTab"]:Show(true)
end

function GeneticAssistOptions:OnTabSelect(wndHandler, wndControl)
  if wndHandler ~= wndControl then return false end
  local strTabName = wndControl:GetData()

  if strTabName ~= nil then
    for tab, control in pairs(self.tTabControls) do
      control:Show(tab == strTabName)
    end
  end
end

--------------------------------------------------------------------------------------------------------------
--  _____                           _    _____      _   _   _
-- |  __ \                         | |  /  ___|    | | | | (_)
-- | |  \/ ___ _ __   ___ _ __ __ _| |  \ `--.  ___| |_| |_ _ _ __   __ _ ___
-- | | __ / _ \ '_ \ / _ \ '__/ _` | |   `--. \/ _ \ __| __| | '_ \ / _` / __|
-- | |_\ \  __/ | | |  __/ | | (_| | |  /\__/ /  __/ |_| |_| | | | | (_| \__ \
--  \____/\___|_| |_|\___|_|  \__,_|_|  \____/ \___|\__|\__|_|_| |_|\__, |___/
--                                                                   __/ |
--                                                                  |___/
--------------------------------------------------------------------------------------------------------------

function GeneticAssistOptions:OnNotificationToggle()
  if self.notificationWnd == nil then
    self.notificationWnd = Apollo.LoadForm(self.xmlDoc, "SampleNotification", nil, self)
  end

  if not self.notificationWnd:IsShown() then
    self.notificationWnd:Show(false)

    GA.settings.notification.left, GA.settings.notification.top = self.notificationWnd:GetAnchorOffsets()
    GA.settings.notification.height = self.notificationWnd:GetHeight()
    GA.settings.notification.width = self.notificationWnd:GetWidth()
  else
    self.notificationWnd:GetAnchorOffsets(GA.settings.notification.left, GA.settings.notification.top)
    self.notificationWnd:SetHeight(GA.settings.notification.height)
    self.notificationWnd:SetWidth(GA.settings.notification.width)

    self.notificationWnd:Show(true)
  end
end

--------------------------------------------------------------------------------------------------------------

GA.options = GeneticAssistOptions:new()