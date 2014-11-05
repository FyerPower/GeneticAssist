GeneticAssistUtil = {}
GeneticAssistUtil.__index = GeneticAssistUtil

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

function GeneticAssistUtil:MergeTables(t1, t2)
  for k, v in pairs(t2) do
    if type(v) == "table" then
    if t1[k] then
        if type(t1[k] or false) == "table" then
          mergeTables(t1[k] or {}, t2[k] or {})
        else
          t1[k] = v
        end
    else
      t1[k] = {}
        mergeTables(t1[k] or {}, t2[k] or {})
    end
    else
      t1[k] = v
    end
  end
  return t1
end

-- Apollo.RegisterPackage(GeneticAssistUtil, "GeneticAssistUtil:Utilities", 1, {})