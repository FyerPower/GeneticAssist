-----------------------------------------------------------------------------------------------
-- Marker
-----------------------------------------------------------------------------------------------

require "Window"

-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------


-----------------------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------------------

GeneticAssistMarker = {}
GeneticAssistMarker.__index = GeneticAssistMarker
GeneticAssistMarker.__call = function (cls, ...) return cls.new(...) end

-- GeneticAssistMarker(self.gameOverlay, "PerspectiveSprites:NPC-Elite", ApolloColor.new('ffffff00'), 36, 36, true, "ScreenLocation" )
function GeneticAssistMarker.new(window, sprite, color, width, height, display, positionType)
  local self = setmetatable({}, GeneticAssistMarker)

  self.window = window
  self.sprite = sprite
  self.color = color
  self.width = width
  self.height = height
  self.position = {x=0,y=0,z=0}
  self.display = (display ~= false)
  self.positionType = positionType or "WorldLocation"

  self.marker = self.window:AddPixie({
    strSprite = (self.display and self.sprite or ''),
    cr = self.color,
    loc = {
      fPoints = {0,0,0,0},
      nOffsets = {0,0,0,0}
    }
  })

  return self
end

function GeneticAssistMarker:Draw(position)
  self.position = position

  if self.positionType == "WorldLocation" then
    position = GameLib.WorldLocToScreenPoint(Vector3.New(position.x, position.y, position.z))
  end

  -- Print("Drawing "..(self.display and self.sprite or '').." at { x="..math.ceil(position.x)..", y="..math.ceil(position.y)..", z="..math.ceil(position.z).." }")

  self.window:UpdatePixie( self.marker , {
    strSprite = (self.display and self.sprite or ''),
    cr = self.color,
    loc = {
      fPoints = {0,0,0,0},
      nOffsets = {
        position.x - (self.width / 2),
        position.y - (self.height / 2),
        position.x + (self.width / 2),
        position.y + (self.height / 2)
      }
    }
  })
  return self; -- chainable
end

function GeneticAssistMarker:Hide()
  if not self.display then return; end
  self.display = false
  self:Draw(self.position)
end

function GeneticAssistMarker:Show()
  if self.display then return; end
  self.display = true
  self:Draw(self.position)
end

function GeneticAssistMarker:Destroy()
  self.window:DestroyPixie( self.marker )
end