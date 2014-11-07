-----------------------------------------------------------------------------------------------
-- Performance Boost: Redefine global functions locally
-----------------------------------------------------------------------------------------------

local Apollo = Apollo
local Line
local Colors

-----------------------------------------------------------------------------------------------
-- Initialization
-----------------------------------------------------------------------------------------------

local GeneticAssist = Apollo.GetAddon("GeneticAssist")
local MyModule = GeneticAssist:NewModule("Convergence")

function MyModule:OnEnable()
  Line   = Apollo.GetPackage("GeneticAssist:Line").tPackage
  Colors = Apollo.GetPackage("GeneticAssist:Config").tPackage.Colors

  local targetName = 'Noxmind the Insidious'
  -- local targetName = 'Raid Target Dummy'

  GeneticAssist:SetEncounter(targetName, { ['Cast'] = { ['Essence Rot'] = 'GeneticAssistSprites:EssenceRot' } })
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
  unit.line:Show()
  unit.line:Draw(tPos, { x = (tPosVector.x + 150 * math.sin(tAngle)), y = tPosVector.y, z = (tPosVector.z + 150 * math.cos(tAngle))})
end