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

local Circle = {}
Circle.__index = Circle
setmetatable(Circle, {
  __call = function (cls, ...)
    return cls.new(...)
  end
})

function Circle.new(window, resolution, thickness, color, height, outline)
  local self = setmetatable({}, Circle)

  self.window = window
  self.resolution = resolution or 18
  self.thickness = thickness or 2
  self.color = color or ApolloColor.new("ffffffff")
  self.height = height or 1
  self.showOutline = outline or false
  self.outlineColor = ApolloColor.new("ff000000")
  self.outlineThickness = self.thickness + 3
  self.isActive = false

  -- create marker
  self.outline = {}
  if self.showOutline then
    for i = 1, self.height do
      self.outline[i] = {}
      for j = 1, self.resolution do
        self.outline[i][j] = self.window:AddPixie( { bLine = true, fWidth = self.outlineThickness, cr = self.outlineColor, loc = { fPoints = {0,0,0,0}, nOffsets = {0,0,0,0} } } )
      end
    end
  end

  self.circle = {}
  for i = 1, self.height do
    self.circle[i] = {}
    for j = 1, self.resolution do
      self.circle[i][j] = self.window:AddPixie( { bLine = true, fWidth = self.thickness, cr = self.color, loc = { fPoints = {0,0,0,0}, nOffsets = {0,0,0,0} } } )
    end
  end

  return self
end

function Circle:Draw(origin, distance, angle, color)
  if self.isActive == false then return end
  for i = 1, self.height do
    local originVector = Vector3.New(origin.x, origin.y+((i-1)*0.5), origin.z)
    local startPoint = GameLib.WorldLocToScreenPoint( Vector3.New( (originVector.x + distance * math.sin(angle)), originVector.y, (originVector.z + distance * math.cos(angle)) ) )

    for j = 1, self.resolution do
      local rotation = angle + math.rad(-360 / (self.resolution / j))
      local endPoint = GameLib.WorldLocToScreenPoint( Vector3.New( (originVector.x + distance * math.sin(rotation)), originVector.y, (originVector.z + distance * math.cos(rotation)) ) )
      if self.showOutline then
        self.window:UpdatePixie( self.outline[i][j] , { bLine = true, fWidth = self.outlineThickness, cr = self.outlineColor, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPoint.x, endPoint.y }  } } )
      end
      self.window:UpdatePixie( self.circle[i][j] , { bLine = true, fWidth = self.thickness, cr = color, loc = { fPoints = {0,0,0,0}, nOffsets = { startPoint.x, startPoint.y, endPoint.x, endPoint.y }  } } )
      startPoint = endPoint
    end
  end
end

function Circle:Show()
  if self.isActive == true then return end

  self.isActive = true
end
function Circle:Hide()
  if self.isActive == false then return end
  self:Draw({x=-100, y=-100, z=-100}, 0, 0, self.color)
  self.isActive = false
end

function Circle:Destroy()
  for i = 1, self.height do
    for j = 1, self.resolution do
      if self.showOutline and self.outline[i] and self.outline[i][j] then
        self.window:DestroyPixie( self.outline[i][j] )
      end
      if self.circle[i] and self.circle[i][j] then
        self.window:DestroyPixie( self.circle[i][j] )
      end
    end
  end
  self.outline = {}
  self.circle = {}
end

-- Register Package
Apollo.RegisterPackage(Circle, "GeneticAssist:Circle", 1, {})