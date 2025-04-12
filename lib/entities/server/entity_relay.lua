-- Objects
Ids = Ids or Require("lib/utility/shared/ids.lua")

local Entities = {}
EntityRelay = {}

function EntityRelay.Create(id, model, coords, rotation, meta)
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
    EntityRelay.Add(self)
    TriggerClientEvent(GetCurrentResourceName() .. "client:CreateEntity", -1, self)
end

function EntityRelay.GetAll()
    return Entities
end

function EntityRelay.Get(id)
    return Entities[id]
end

function EntityRelay.Add(self)
    Entities[self.id] = self
end

function EntityRelay.Remove(id)
    Entities[id] = nil
end

function EntityRelay.LoadModel(model)
    return Utility.LoadModel(model)
end

return EntityRelay