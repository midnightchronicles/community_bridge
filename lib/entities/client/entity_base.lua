
-- Objects
Utility = Utility or Require("lib/utility/client/utility.lua")
Ids = Ids or Require("lib/utility/shared/ids.lua")
Point = Point or Require("lib/points/client/points.lua")

local Entities = {}
BaseEntity = {}

function BaseEntity.Create(id, model, coords, rotation, meta)
    local self = meta or {}
    if id and type(id) == "table" then
        self = id
        self.id = id.id or Ids.CreateUniqueId(Entities)
        self.rotation = id.rotation or vector3(0.0, 0.0, 0.0)
    else
        self.id = id or Ids.CreateUniqueId(Entities)
        self.model = model
        self.coords = coords
        self.rotation = rotation or vector3(0.0, 0.0, 0.0)
    end
    assert(self.id, "ID Failed to generate")
    assert(self.model, "Model is required for entity creation")
    assert(self.coords, "Coords are required for entity creation")

    self.Spawn = self.Spawn or function() end
    self.Remove = self.Remove or function() end
    
    return Point.Register(self.id, self.coords, 50.0, self.Spawn, self.Remove, nil, self)
end

function BaseEntity.GetAll()
    return Entities
end

function BaseEntity.Get(id)
    return Entities[id]
end

function BaseEntity.Add(self)
    Entities[self.id] = self
end

function BaseEntity.Remove(id)
    Entities[id] = nil
end

function BaseEntity.LoadModel(model)
    return Utility.LoadModel(model)
end

return BaseEntity