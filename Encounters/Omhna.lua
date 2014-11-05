local GameLib = GameLib
local Colors  = GeneticAssistConfig.Colors
local Util    = GeneticAssistUtil
local GA      = GeneticAssist

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

local function OmhnaCreate(unit)
  -- if not unit['Lines'] then
  if not unit['Lines'] then
    unit['Lines'] = {}
    unit['Lines']['1'] = GeneticAssistLine.new(GA.gameOverlay, 'solid', Colors.white,  5, true)
    unit['Lines']['2'] = GeneticAssistLine.new(GA.gameOverlay, 'solid', Colors.yellow, 5, true)
    unit['Lines']['3'] = GeneticAssistLine.new(GA.gameOverlay, 'solid', Colors.yellow, 5, true)
  end

  if not unit['Markers'] then
    unit['Markers'] = {}
    unit['Markers']["DirectionN"]  = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-N",  Colors.red, 32, 32, false)
    unit['Markers']["DirectionNE"] = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-NE", Colors.cyan, 32, 32, false)
    unit['Markers']["DirectionE"]  = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-E",  Colors.green, 32, 32, false)
    unit['Markers']["DirectionSE"] = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-SE", Colors.purple, 32, 32, false)
    unit['Markers']["DirectionS"]  = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-S",  Colors.pink, 32, 32, false)
    unit['Markers']["DirectionSW"] = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-SW", Colors.golden, 32, 32, false)
    unit['Markers']["DirectionW"]  = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-W",  Colors.gray, 32, 32, false)
    unit['Markers']["DirectionNW"] = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Direction-NW", Colors.blue, 32, 32, false)
  end
end

local function OmhnaDestroy(unit)
end

local function OmhnaHide(unit)
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

local function OmhnaUpdate(unit)
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

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

GA:SetCallback('Dreadphage Ohmna', 'OnCreate',  OmhnaCreate)
GA:SetCallback('Dreadphage Ohmna', 'OnDestroy', OmhnaHide)
GA:SetCallback('Dreadphage Ohmna', 'OnHide',    OmhnaHide)
GA:SetCallback('Dreadphage Ohmna', 'OnUpdate',  OmhnaUpdate)
