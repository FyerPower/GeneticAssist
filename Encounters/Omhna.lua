-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local Apollo = Apollo
local Line
local Marker
local Colors

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------

local GeneticAssist = Apollo.GetAddon("GeneticAssist")
local MyModule = GeneticAssist:NewModule("Ohmna")

function MyModule:OnEnable()
  Line   = Apollo.GetPackage("GeneticAssist:Line").tPackage
  Marker = Apollo.GetPackage("GeneticAssist:Marker").tPackage
  Colors = Apollo.GetPackage("GeneticAssist:Config").tPackage.Colors

  local targetName = 'Dreadphage Ohmna'
  -- local targetName = 'Raid Target Dummy'

  GeneticAssist:SetEncounter(targetName, {})
  GeneticAssist:RegisterUnitCallback(targetName, 'OnCreate',  'Create',  self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnDestroy', 'Destroy', self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnHide',    'Hide',    self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnUpdate',  'Update',  self)
end

-----------------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------------

function MyModule:Create(unit)
  -- if not unit['Lines'] then
  if not unit['Lines'] then
    unit['Lines'] = {}
    unit['Lines']['1'] = Line(GeneticAssist.gameOverlay, 'solid', Colors.white,  5, true)
    unit['Lines']['2'] = Line(GeneticAssist.gameOverlay, 'solid', Colors.yellow, 5, true)
    unit['Lines']['3'] = Line(GeneticAssist.gameOverlay, 'solid', Colors.yellow, 5, true)
  end

  if not unit['Markers'] then
    unit['Markers'] = {}
    unit['Markers']["DirectionN"]  = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-N",  Colors.red, 32, 32, false)
    unit['Markers']["DirectionNE"] = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-NE", Colors.cyan, 32, 32, false)
    unit['Markers']["DirectionE"]  = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-E",  Colors.green, 32, 32, false)
    unit['Markers']["DirectionSE"] = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-SE", Colors.purple, 32, 32, false)
    unit['Markers']["DirectionS"]  = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-S",  Colors.pink, 32, 32, false)
    unit['Markers']["DirectionSW"] = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-SW", Colors.golden, 32, 32, false)
    unit['Markers']["DirectionW"]  = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-W",  Colors.gray, 32, 32, false)
    unit['Markers']["DirectionNW"] = Marker(GeneticAssist.gameOverlay, "GeneticAssistSprites:Direction-NW", Colors.blue, 32, 32, false)
  end
end

function MyModule:Destroy(unit)
end

function MyModule:Hide(unit)
  unit['Lines']['1']:Hide()
  unit['Lines']['2']:Hide()
  unit['Lines']['3']:Hide()
  unit['Markers']["DirectionN"]:Hide()
  unit['Markers']["DirectionNE"]:Hide()
  unit['Markers']["DirectionE"]:Hide()
  unit['Markers']["DirectionSE"]:Hide()
  unit['Markers']["DirectionS"]:Hide()
  unit['Markers']["DirectionSW"]:Hide()
  unit['Markers']["DirectionW"]:Hide()
  unit['Markers']["DirectionNW"]:Hide()
end

function MyModule:Update(unit)
  -- Target Positioning & Facing
  local tPos = unit['unit']:GetPosition()
  local tFacing = unit['unit']:GetFacing()
  local tAngle = math.atan2(tFacing.x, tFacing.z)

  -- math.rad(120) = 2.0724
  unit['Lines']['1']:Draw(tPos, { x = (tPos.x + 30 * math.sin(tAngle)),        y = tPos.y, z = (tPos.z + 30 * math.cos(tAngle))}):Show()
  unit['Lines']['2']:Draw(tPos, { x = (tPos.x + 30 * math.sin(tAngle+2.0724)), y = tPos.y, z = (tPos.z + 30 * math.cos(tAngle+2.0724))}):Show()
  unit['Lines']['3']:Draw(tPos, { x = (tPos.x + 30 * math.sin(tAngle-2.0724)), y = tPos.y, z = (tPos.z + 30 * math.cos(tAngle-2.0724))}):Show()

  unit['Markers']['DirectionN']:Draw( { x = (tPos.x + 33 * math.cos(math.rad(270))),   y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(270)))}):Show()
  unit['Markers']['DirectionNE']:Draw({ x = (tPos.x + 33 * math.cos(math.rad(315))),  y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(315)))}):Show()
  unit['Markers']['DirectionE']:Draw( { x = (tPos.x + 33 * math.cos(math.rad(0))),  y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(0)))}):Show()
  unit['Markers']['DirectionSE']:Draw({ x = (tPos.x + 33 * math.cos(math.rad(45))), y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(45)))}):Show()
  unit['Markers']['DirectionS']:Draw( { x = (tPos.x + 33 * math.cos(math.rad(90))), y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(90)))}):Show()
  unit['Markers']['DirectionSW']:Draw({ x = (tPos.x + 33 * math.cos(math.rad(135))), y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(135)))}):Show()
  unit['Markers']['DirectionW']:Draw( { x = (tPos.x + 33 * math.cos(math.rad(180))), y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(180)))}):Show()
  unit['Markers']['DirectionNW']:Draw({ x = (tPos.x + 33 * math.cos(math.rad(225))), y = tPos.y, z = (tPos.z + 33 * math.sin(math.rad(225)))}):Show()
end
