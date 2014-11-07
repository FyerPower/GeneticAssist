-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local Apollo = Apollo
local Vector3 = Vector3
local GameLib = GameLib
local Line
local Util
local Colors

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------

local GeneticAssist = Apollo.GetAddon("GeneticAssist")
local MyModule = GeneticAssist:NewModule("X89")

function MyModule:OnEnable()
  Line   = Apollo.GetPackage("GeneticAssist:Line").tPackage
  Util   = Apollo.GetPackage("GeneticAssist:Utilities").tPackage
  Colors = Apollo.GetPackage("GeneticAssist:Config").tPackage.Colors

  local targetName = 'Experiment X-89'
  -- local targetName = 'Raid Target Dummy'

  GeneticAssist:SetEncounter(targetName, {
    ['Circle'] = { ['Resolution'] = 18,  ['Thickness'] = 4,  ['Color'] = Colors.yellow,  ['Height'] = 1,  ['Outline'] = true,  ['Radius'] = 9 },
    ['DeBuff'] = {
      ['Corruption Globule'] = "GeneticAssistSprites:SmallBomb",
      ['Strain Bomb'] = "GeneticAssistSprites:BigBomb"
    }
  })
  GeneticAssist:RegisterUnitCallback(targetName, 'OnCreate',  'Create',  self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnDestroy', 'Destroy', self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnHide',    'Hide',    self)
  GeneticAssist:RegisterUnitCallback(targetName, 'OnUpdate',  'Update',  self)
end

-----------------------------------------------------------------------------------------------
-- Functions
-----------------------------------------------------------------------------------------------

function MyModule:Create(unit)
  unit.line = Line(GeneticAssist.gameOverlay, "solid", Colors.white, 4, true)
end

function MyModule:Destroy(unit)
  unit.line:Destroy()
end

function MyModule:Hide(unit)
  unit.line:Hide()
end

function MyModule:Update(unit)
  -- Target Positioning & Facing
  local tPos = unit['unit']:GetPosition()

  -- Line in front of boss
  local tPosVector= Vector3.New(tPos.x, tPos.y, tPos.z) -- why?
  local tFacing = unit['unit']:GetFacing()
  local tAngle = math.atan2(tFacing.x, tFacing.z)
  unit.line:Draw(tPos, { x = (tPosVector.x + 120 * math.sin(tAngle)), y = tPosVector.y, z = (tPosVector.z + 120 * math.cos(tAngle))}):Show()

  -- Update config for the circle
  unit['config']['Circle']['Color'] = Util:GetDistance(GameLib.GetPlayerUnit():GetPosition(), tPos) > 9 and Colors.yellow or Colors.red
end