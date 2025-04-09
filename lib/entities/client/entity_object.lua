BaseEntity = BaseEntity or Require("lib/entities/client/entity_base.lua")
local Objects = {}

Object = {}

function Object.Create(id, model, coords, rotation, meta)
    local base = meta or {}
    if id and type(id) == "table" then
        base = id
        base.id = id.id or Ids.CreateUniqueId(Objects)
        base.rotation = id.rotation or vector3(0.0, 0.0, 0.0)
    else
        base.id = id or Ids.CreateUniqueId(Objects)
        base.model = model
        base.coords = coords
        base.rotation = rotation or vector3(0.0, 0.0, 0.0)
    end
    assert(base.id, "ID Failed to generate")
    assert(base.model, "Model is required for entity creation")
    assert(base.coords, "Coords are required for entity creation")

    base.Spawn = function(self)
        print("Spawning object", self)
        if not BaseEntity.LoadModel(self.model) then return end
        self.entity = CreateObject(self.model, self.coords.x, self.coords.y, self.coords.z, false, false, false)
        SetEntityRotation(self.entity, self.rotation.x, self.rotation.y, self.rotation.z, 2, false)
        SetEntityAsMissionEntity(self.entity, true, true)
        SetModelAsNoLongerNeeded(self.model)
        if self.OnSpawn then self.OnSpawn(self, self.entity, self.coords, self.rotation) end
        return self.entity
    end
    base.Remove = function(self)
        DeleteEntity(self.entity)
        if self.OnRemove then self.OnRemove(self, self.entity) end
        self.entity = nil
    end
    Object.Add(base)
    return BaseEntity.Create(base)
end

function Object.GetAll()
    return Objects
end

function Object.Get(id)
    return Objects[id]
end

function Object.Add(self)
    Objects[self.id] = self
end

function Object.Remove(id)
    Objects[id] = nil
end

function Object.SetOnSpawn(id, callback)
    local obj = Object.Get(id)
    if not obj then return end
    obj.OnSpawn = callback
    return true
end

function Object.SetOnRemove(id, callback)
    local obj = Object.Get(id)
    if not obj then return end
    obj.OnRemove = callback
    return true
end

return Object