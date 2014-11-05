-----------------------------------------------------------------------------------------------
-- Circle
-----------------------------------------------------------------------------------------------
-- TODO: Add Outline Functionality

require "Window"
require "GameLib"

-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local GameLib = GameLib
local Apollo = Apollo
local ApolloColor = ApolloColor
local Vector3 = Vector3
local math = math

-----------------------------------------------------------------------------------------------
-- Code
-----------------------------------------------------------------------------------------------

local Line = {}
Line.__index = Line
setmetatable(Line, {
  __call = function (cls, ...)
    return cls.new(...)
  end
})

function Line.new(lWindow, lType, lColor, lSize, lOutline)
  local self = setmetatable({}, Line)

  self.window = lWindow
  self.type = lType or "solid"
  self.color = lColor or ApolloColor.new("ffffffff")
  self.size = lSize or 4
  self.showOutline = lOutline or false
  self.outlineColor = ApolloColor.new("ff000000")
  self.outlineSize = self.size + 3
  self.display = true

  if self.showOutline then
    self.outline = self.window:AddPixie({ bLine = true, fWidth = self.outlineSize, cr = self.outlineColor, loc = { fPoints = {0,0,0,0}, nOffsets = {0,0,0,0} } })
  end
  self.line = self.window:AddPixie({ bLine = true, fWidth = self.size, cr = self.color, loc = { fPoints = {0,0,0,0}, nOffsets = {0,0,0,0} } })

  return self
end

function Line:Draw(origin, destination)
  self.origin = origin
  self.destination = destination

  if not self.display then
    origin = {x=0,y=0,z=0}
    destination = {x=0,y=0,z=0}
  end

  local originScreenPoint = GameLib.WorldLocToScreenPoint( Vector3.New(origin.x, origin.y, origin.z) )
  local destinationScreenPoint = GameLib.WorldLocToScreenPoint( Vector3.New(destination.x, destination.y, destination.z) )
  self.window:UpdatePixie( self.line , { bLine = true, fWidth = self.size, cr = self.color, loc = { fPoints = {0,0,0,0}, nOffsets = {originScreenPoint.x, originScreenPoint.y, destinationScreenPoint.x, destinationScreenPoint.y} } })
  if self.showOutline then
    self.window:UpdatePixie( self.outline , { bLine = true, fWidth = self.outlineSize, cr = self.outlineColor, loc = { fPoints = {0,0,0,0}, nOffsets = {originScreenPoint.x, originScreenPoint.y, destinationScreenPoint.x, destinationScreenPoint.y} } })
  end
  return self; -- Chainable
end

function Line:Hide()
  if not self.display then return; end
  self.display = false
  self:Draw({x=0,y=0,z=0}, {x=0,y=0,z=0})
end

function Line:Show()
  if self.display then return; end
  self.display = true
  self:Draw(self.origin, self.destination)
end

function Line:Destroy()
  if self.showOutline then
    self.window:DestroyPixie(self.outline)
  end
  self.window:DestroyPixie(self.line)
end

-- Register Package
Apollo.RegisterPackage(Line, "GeneticAssist:Line", 1, {})