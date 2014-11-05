local Vector3 = Vector3
local GameLib = GameLib
local Colors  = GeneticAssistConfig.Colors
local Util    = GeneticAssistUtil
local GA      = GeneticAssist

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

local function NoxmindCreate(iUnit)
  iUnit.line = GeneticAssistLine.new(GA.gameOverlay, "solid", Colors.white, 4, true)
end

local function NoxmindDestroy(iUnit)
  iUnit.line:Destroy()
end

local function NoxmindHide(iUnit)
  iUnit.line:Hide()
end

local function NoxmindUpdate(iUnit)
  -- Target Positioning & Facing
  local tPos = iUnit['unit']:GetPosition()

  -- Line in front of boss
  local tPosVector= Vector3.New(tPos.x, tPos.y, tPos.z) -- why?
  local tFacing = iUnit['unit']:GetFacing()
  local tAngle = math.atan2(tFacing.x, tFacing.z)
  iUnit.line:Show()
  iUnit.line:Draw(tPos, { x = (tPosVector.x + 150 * math.sin(tAngle)), y = tPosVector.y, z = (tPosVector.z + 150 * math.cos(tAngle))})
end

-- ~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~-~'*`~ --

GA:SetCallback('Noxmind the Insidious', 'OnCreate',  NoxmindCreate)
GA:SetCallback('Noxmind the Insidious', 'OnDestroy', NoxmindDestroy)
GA:SetCallback('Noxmind the Insidious', 'OnHide',    NoxmindHide)
GA:SetCallback('Noxmind the Insidious', 'OnUpdate',  NoxmindUpdate)