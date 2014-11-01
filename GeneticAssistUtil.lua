GeneticAssistUtil = {}
GeneticAssistUtil.__index = GeneticAssistUtil

function GeneticAssistUtil:TableLength(tbl)
  local count = 0
  for _, v in pairs(tbl) do
    if v ~= nil then count = count + 1 end
  end
  return count
end

function GeneticAssistUtil:GetTableIndex(tbl, value)
  for i, v in ipairs(tbl) do
    if v == value then return i; end
  end
end

function GeneticAssistUtil:GetDistance(origin, target)
  return math.sqrt( math.pow(target.x - origin.x, 2) + math.pow(target.y - origin.y, 2) + math.pow(target.z - origin.z, 2) )
end

function GeneticAssistUtil:GetBuffList(unit, type)
  local spells = {}
  local pBuffs = unit:GetBuffs()[type]
  if pBuffs then
    for k, buff in pairs(pBuffs) do
      spells[buff.splEffect:GetName()] = true
    end
  end
  return spells
end

