Util = {}
Util.__index = Util

-- Get the distance between two points
function Util:GetDistance(origin, target)
  return math.sqrt( math.pow(target.x - origin.x, 2) + math.pow(target.y - origin.y, 2) + math.pow(target.z - origin.z, 2) )
end

-- Get an associative array of all buffs (or debuffs) on a unit
function Util:GetBuffList(unit, type)
  local spells = {}
  local pBuffs = unit:GetBuffs()[type]
  if pBuffs then
    for k, buff in pairs(pBuffs) do
      spells[buff.splEffect:GetName()] = true
    end
  end
  return spells
end

-- Returns the lenght of an assoicative table
function Util:TableLength(tbl)
  local count = 0
  for _, v in pairs(tbl) do
    if v ~= nil then count = count + 1 end
  end
  return count
end

-- Merge two tables together
function Util:MergeTables(t1, t2)
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

-- Register Package
Apollo.RegisterPackage(Util, "GeneticAssist:Utilities", 1, {})