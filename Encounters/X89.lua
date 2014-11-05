local Vector3 = Vector3
local GameLib = GameLib
local Colors  = GeneticAssistConfig.Colors
local Util    = GeneticAssistUtil
local GA      = GeneticAssist

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

local function X89Create(iUnit)
  iUnit.line = GeneticAssistLine.new(GA.gameOverlay, "solid", Colors.white, 4, true)
end

local function X89Destroy(iUnit)
  iUnit.line:Destroy()
end

local function X89Hide(iUnit)
  iUnit.line:Hide()
end

local function X89Update(iUnit)
  -- Target Positioning & Facing
  local tPos = iUnit['unit']:GetPosition()

  -- Line in front of boss
  local tPosVector= Vector3.New(tPos.x, tPos.y, tPos.z) -- why?
  local tFacing = iUnit['unit']:GetFacing()
  local tAngle = math.atan2(tFacing.x, tFacing.z)
  iUnit.line:Draw(tPos, { x = (tPosVector.x + 120 * math.sin(tAngle)), y = tPosVector.y, z = (tPosVector.z + 120 * math.cos(tAngle))}):Show()

  -- Update config for the circle
  iUnit['config']['Circle']['Color'] = Util:GetDistance(GameLib.GetPlayerUnit():GetPosition(), tPos) > 9 and Colors.yellow or Colors.red
end

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

GA:SetCallback('Experiment X-89', 'OnCreate',  X89Create)
GA:SetCallback('Experiment X-89', 'OnDestroy', X89Destroy)
GA:SetCallback('Experiment X-89', 'OnHide',    X89Hide)
GA:SetCallback('Experiment X-89', 'OnUpdate',  X89Update)
