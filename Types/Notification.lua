-----------------------------------------------------------------------------------------------
-- Notification
-----------------------------------------------------------------------------------------------

require "Window"
require "Sound"

-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local Marker = GeneticAssistMarker
local ApolloColor = ApolloColor

local nScreenWidth, _ = Apollo.GetScreenSize()
-- local LocationX = 1866
-- local LocationY = 500
local LocationX = nScreenWidth / 2
local LocationY = 200
local SizeX = 400
local SizeY = 200

-----------------------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------------------

GeneticAssistNotification = {}
GeneticAssistNotification.__index = GeneticAssistNotification
GeneticAssistNotification.__call = function (cls, ...) return cls.new(...) end

function GeneticAssistNotification.new(window, sprite, sound, isActive)
  local self = setmetatable({}, GeneticAssistNotification)

  self.window = window
  self.sprite = sprite
  self.sound = sound
  self.isActive = (isActive == true)

  self.marker = Marker.new(self.window, self.sprite, ApolloColor.new("ffffffff"), SizeX, SizeY, self.isActive, "ScreenLocation")
  self.marker:Draw({x=LocationX, y=LocationY, z=0})

  return self
end

function GeneticAssistNotification:Active(isActive)
  isActive = (isActive == true)
  if isActive == true and self.isActive == false then
    self:Show()
  end
  if isActive == false and self.isActive == true then
    self:Hide()
  end
end

function GeneticAssistNotification:Show()
  if self.isActive == true then return end
  self.marker:Show()
  if self.sound then Sound.Play(tonumber(self.sound)) end
  self.isActive = true
end
function GeneticAssistNotification:Hide()
  if self.isActive == false then return end
  self.marker:Hide()
  self.isActive = false
end


function GeneticAssistNotification:Destroy()
  self.marker:Destroy()
end


-- PlayRingtoneSoldier
-- PlayUIQueuePopsPvP
-- PlayUIQueuePopsDungeon
-- PlayUIQueuePopsAdventure
-- PlayUIWindowPublicEventVoteVotingEnd
-- PlayUIWindowPublicEventVoteOpen
-- PlayUIMissionUnlockSoldier