local GameLib = GameLib
local Colors  = GeneticAssistConfig.Colors
local Util    = GeneticAssistUtil
local GA      = GeneticAssist

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

local function KuralakCreate(unit)
  -- Print("Kuralak Create")
  if not unit['Lines'] then
    -- Print("Unit Lines Created")
    local colors = { Colors.red, Colors.cyan, Colors.green, Colors.purple, Colors.pink, Colors.golden, Colors.gray, Colors.blue }
    unit['Lines'] = {}
    for i, v in pairs(colors) do
      unit['Lines'][i] = GeneticAssistLine.new(GA.gameOverlay, 'solid', v, 3, true)
    end
  end

  if not unit['Markers'] then
    -- Print("Unit Marker Created")
    unit['Markers'] = {}
    unit['Markers']["Number1"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-1", Colors.red, 32, 32, false)
    unit['Markers']["Number2"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-2", Colors.cyan, 32, 32, false)
    unit['Markers']["Number3"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-3", Colors.green, 32, 32, false)
    unit['Markers']["Number4"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-4", Colors.purple, 32, 32, false)
    unit['Markers']["Number5"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-5", Colors.pink, 32, 32, false)
    unit['Markers']["Number6"]     = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-6", Colors.golden, 32, 32, false)
    unit['Markers']["Number1p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-1", Colors.red, 32, 32, false)
    unit['Markers']["Number2p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-2", Colors.cyan, 32, 32, false)
    unit['Markers']["Number3p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-3", Colors.green, 32, 32, false)
    unit['Markers']["Number4p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-4", Colors.purple, 32, 32, false)
    unit['Markers']["Number5p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-5", Colors.pink, 32, 32, false)
    unit['Markers']["Number6p"]    = GeneticAssistMarker.new(GA.gameOverlay, "GeneticAssistSprites:Number-6", Colors.golden, 32, 32, false)
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

local function KuralakDestroy(unit)
  -- Print("Kuralak Destroy")
  for i, v in pairs(unit['Markers']) do  v:Hide() end
  for i, v in pairs(unit['Lines']) do    v:Hide() end
end

local function KuralakHide(unit)
  -- Print("Kuralak Hide")
  for i, v in pairs(unit['Markers']) do  v:Hide() end
  for i, v in pairs(unit['Lines']) do    v:Hide() end
end

local function KuralakUpdate(unit)
  -- Print("Kuralak Update")
  local tPos = unit['unit']:GetPosition()
  if not tPos then return end

  if Util:GetDistance(GameLib.GetPlayerUnit():GetPosition(), tPos) < 120 then
    local curr = unit['unit']:GetHealth()
    local max = unit['unit']:GetMaxHealth()
    if curr and max then
      if (curr / max * 100) > 73 then
        local d1 = 10
        local d2 = 5
        local d3 = 8.66
        unit['Markers']['Number1']:Draw({x = tPos.x-d2-0.5,  y = tPos.y, z = tPos.z+d3+0.866}):Show()
        unit['Markers']['Number2']:Draw({x = tPos.x-d1-1,    y = tPos.y, z = tPos.z         }):Show()
        unit['Markers']['Number3']:Draw({x = tPos.x-d2-0.5,  y = tPos.y, z = tPos.z-d3-0.866}):Show()
        unit['Markers']['Number4']:Draw({x = tPos.x+d2+0.5,  y = tPos.y, z = tPos.z-d3-0.866}):Show()
        unit['Markers']['Number5']:Draw({x = tPos.x+d1+1,    y = tPos.y, z = tPos.z         }):Show()
        unit['Markers']['Number6']:Draw({x = tPos.x+d2+0.5,  y = tPos.y, z = tPos.z+d3+0.866}):Show()
        unit['Lines'][1]:Draw(tPos,     {x = tPos.x-d2,      y = tPos.y, z = tPos.z+d3}):Show()
        unit['Lines'][2]:Draw(tPos,     {x = tPos.x-d1,      y = tPos.y, z = tPos.z}):Show()
        unit['Lines'][3]:Draw(tPos,     {x = tPos.x-d2,      y = tPos.y, z = tPos.z-d3}):Show()
        unit['Lines'][4]:Draw(tPos,     {x = tPos.x+d2,      y = tPos.y, z = tPos.z-d3}):Show()
        unit['Lines'][5]:Draw(tPos,     {x = tPos.x+d1,      y = tPos.y, z = tPos.z}):Show()
        unit['Lines'][6]:Draw(tPos,     {x = tPos.x+d2,      y = tPos.y, z = tPos.z+d3}):Show()
        unit['Lines'][7]:Hide()
        unit['Lines'][8]:Hide()

        unit['Markers']['Number1p']:Draw({x = tPos.x-52.5,  y = tPos.y, z = tPos.z+90.9}):Show()
        unit['Markers']['Number2p']:Draw({x = tPos.x-105,   y = tPos.y, z = tPos.z}):Show()
        unit['Markers']['Number3p']:Draw({x = tPos.x-52.5,  y = tPos.y, z = tPos.z-90.9}):Show()
        unit['Markers']['Number4p']:Draw({x = tPos.x+52.5,  y = tPos.y, z = tPos.z-90.9}):Show()
        unit['Markers']['Number5p']:Draw({x = tPos.x+105,   y = tPos.y, z = tPos.z}):Show()
        unit['Markers']['Number6p']:Draw({x = tPos.x+52.5,  y = tPos.y, z = tPos.z+90.9}):Show()

        local marks = { 'DirectionN', 'DirectionNE', 'DirectionE', 'DirectionSE', 'DirectionS', 'DirectionSW', 'DirectionW', 'DirectionNW' }
        for i, v in pairs(marks) do
          unit['Markers'][v]:Hide()
        end
      else
        local d1 = 10
        local d2 = 7
        unit['Markers']['DirectionN']:Draw(  {x = tPos.x,        y = tPos.y, z = tPos.z-d1-1}  ):Show()
        unit['Markers']['DirectionNE']:Draw( {x = tPos.x+d2+0.7, y = tPos.y, z = tPos.z-d2-0.7}):Show()
        unit['Markers']['DirectionE']:Draw(  {x = tPos.x+d1+1,   y = tPos.y, z = tPos.z}       ):Show()
        unit['Markers']['DirectionSE']:Draw( {x = tPos.x+d2+0.7, y = tPos.y, z = tPos.z+d2+0.7}):Show()
        unit['Markers']['DirectionS']:Draw(  {x = tPos.x,        y = tPos.y, z = tPos.z+d1+1}  ):Show()
        unit['Markers']['DirectionSW']:Draw( {x = tPos.x-d2-0.7, y = tPos.y, z = tPos.z+d2+0.7}):Show()
        unit['Markers']['DirectionW']:Draw(  {x = tPos.x-d1-1,   y = tPos.y, z = tPos.z}       ):Show()
        unit['Markers']['DirectionNW']:Draw( {x = tPos.x-d2-0.7, y = tPos.y, z = tPos.z-d2-0.7}):Show()
        unit['Lines'][1]:Draw(tPos, {x = tPos.x,    y = tPos.y, z = tPos.z-d1}):Show()
        unit['Lines'][2]:Draw(tPos, {x = tPos.x+d2, y = tPos.y, z = tPos.z-d2}):Show()
        unit['Lines'][3]:Draw(tPos, {x = tPos.x+d1, y = tPos.y, z = tPos.z}):Show()
        unit['Lines'][4]:Draw(tPos, {x = tPos.x+d2, y = tPos.y, z = tPos.z+d2}):Show()
        unit['Lines'][5]:Draw(tPos, {x = tPos.x,    y = tPos.y, z = tPos.z+d1}):Show()
        unit['Lines'][6]:Draw(tPos, {x = tPos.x-d2, y = tPos.y, z = tPos.z+d2}):Show()
        unit['Lines'][7]:Draw(tPos, {x = tPos.x-d1, y = tPos.y, z = tPos.z}):Show()
        unit['Lines'][8]:Draw(tPos, {x = tPos.x-d2, y = tPos.y, z = tPos.z-d2}):Show()

        local marks = { 'Number1', 'Number2', 'Number3', 'Number4', 'Number5', 'Number6', 'Number1p', 'Number2p', 'Number3p', 'Number4p', 'Number5p', 'Number6p' }
        for i, v in pairs(marks) do
          unit['Markers'][v]:Hide()
        end
      end
    end
  else
    for i, v in pairs(unit['Markers']) do  v:Hide() end
    for i, v in pairs(unit['Lines']) do    v:Hide() end
  end
end

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

GA:SetCallback('Kuralak the Defiler', 'OnCreate',  KuralakCreate)
GA:SetCallback('Kuralak the Defiler', 'OnDestroy', KuralakDestroy)
GA:SetCallback('Kuralak the Defiler', 'OnHide',    KuralakHide)
GA:SetCallback('Kuralak the Defiler', 'OnUpdate',  KuralakUpdate)
