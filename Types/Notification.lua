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

-----------------------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------------------

GeneticAssistNotification = {}
GeneticAssistNotification.__index = GeneticAssistNotification
GeneticAssistNotification.__call = function (cls, ...) return cls.new(...) end

function GeneticAssistNotification.new(window, sprite, sound, pos)
  local self = setmetatable({}, GeneticAssistNotification)

  self.window = window
  self.sprite = sprite
  self.sound = sound
  self.isActive = false

  self.marker = Marker.new(self.window, self.sprite, ApolloColor.new("ffffffff"), pos.nWidth, pos.nHeight, self.isActive, "ScreenLocation")
  self.marker:Draw({x=pos.nLeft, y=pos.nTop, z=0})

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