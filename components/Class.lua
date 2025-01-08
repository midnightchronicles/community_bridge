
local Tables = Require('use/tables.lua')
local Ids = Require("use/ids.lua")

local AllInstances = {}


---@class Class
Class = {}
Class.ClassName = "Class"
Class.__call = function(this, ...)
    return this:new(...)
end
Builders = {}

function Class.SetInstance(instance)
    AllInstances[instance.id] = instance
end

function Class.GetInstance(id)
    return AllInstances[id]
end

--- Default (empty) constructor
--- @param self Class
--- @vararg any
function Class:init(...) end

--- Creates a subclass of the current class.
--- This function copies the properties and methods of the current class to a new object.
--- It also sets up metatables to allow for object-oriented behavior, such as method calls and property access.
--- @param obj object | nil: The table to extend. If nil, a new table will be created.
--- @return obj object: The extended object with properties and methods from the given class obj.
function Class:extend(obj)
    local className = obj.ClassName or "Class"


    local old = Tables.DeepClone(self, {}, {components = true})
    local new = Tables.DeepClone(obj, old, {ClassName = true})

	new.components = self.components or {}
    new.components[className] = obj

    if not new.id then new.id = Ids.CreateUniqueId(new.components) end

	-- create new objects directly, like o = Object()
    self = setmetatable(new, Class)

    if not Class.GetInstance(new.id) then Class.SetInstance(self) end
	return self
end

--- Sets a property on the object. NOTE: This is mostly for internal purposes.
--- @param prop string|table: The property name or a table of properties to set.
--- @param value any: The value to set the property to.
function Class:set(prop, value)
	if not value and type(prop) == "table" then
		for k, v in pairs(prop) do
			rawset(self._, k, v)
		end
	else
		rawset(self._, prop, value)
	end
end

--- This function is used to create a new instance of the class.
--- It calls the init function if it exists.
--- @vararg any: The arguments to pass to the init
--- @return object: The new instance of the class.
function Class:new(...)
	local obj = self:extend({})
	if obj.init then obj:init(...) end
	return obj
end

--- This function is used to create a new instance of the class.
--- It calls the struct function if it exists.
--- @vararg object(s): List of objects to extend the class with.
--- @return object: The new instance of the class with the data and functions from the objects passed.
function class(className, ...)
    local newObj = Class:extend({})
    local components = table.pack(...)
    newObj.ClassName = className
    if components then
        for k, v in pairs(components) do
            local clName = v.ClassName
            if not Builders[clName] then -- builders are used to reconstruct an object usually when pulled from server to client or vice versa
                Builders[clName] = Tables.DeepClone(newObj)
            end
        end
    end
    if components.n > 0 then
        for k, v in pairs(components) do
            if k ~= "n" then
                local newNewObject = nil
                if v.Struct and type(v.Struct) == "function" then
                    newNewObject = v:Struct()
                end
                newObj = newObj:extend(newNewObject or v)
            end
        end
    else
        return newObj
    end

	return newObj
end

function reconstruct(obj)
    local newTable = {}
    local tbl = obj.components or {}
    for k, v in pairs(tbl) do
        local builder = Builders[k]
        if builder then
            newTable[k] = builder
        end
    end
    return class(table.unpack(newTable))
end

--- Overwrites the type(self) value to return "Class".
--- @return string: The string "Class".
function Class:__type()
    return self.ClassName or "Class"
end

--- Overwrites the call operator to call the new function. Ex: Class()
--- @vararg any: The arguments to pass to the new function.
--- @return object: The new instance of the class.
function Class:__call(...)
  return self:new(...)
end


--- Checks to see if the class is an instance of the given class.
--- @param cls Class: The class to check against.
--- @return boolean: True if the class is an instance of the given class, false otherwise.
function Class:IsA(cls)
    local p = promise.new()
    CreateThread(function()
        local m = getmetatable(self)
        while m do
            if m == cls then
                return p:resolve(true)
            end
            m = getmetatable(m)
            Wait(0)
        end
        return p:resolve(false)
    end)
    return Citizen.Await(p)
end

return {Class, class}