GeneticAssistUtil = {}
GeneticAssistUtil.__index = GeneticAssistUtil

function GeneticAssistUtil:TableLength(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
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