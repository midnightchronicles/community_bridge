local classModule = Require("components/class.lua")
local _, class = table.unpack(classModule)

-- Registry to store singletons for classes
local SingletonRegistry = {}

--- @class Singleton
local Singleton = class()
Singleton.ClassName = "Singleton"
--- Ensures the class instance is a singleton.
--- If an instance already exists, it returns the existing one.
--- If not, it initializes and registers a new singleton.
function Singleton:Struct()
    local className = self.ClassName or "UnnamedClass"
    -- Check if the singleton already exists
    if SingletonRegistry[className] then
        self = SingletonRegistry[className]
        return self
    end
    -- Register this instance as the singleton for its class
    SingletonRegistry[className] = self
    return self
end
--- Clears the singleton instance for this class (if needed).
function Singleton:ClearSingleton()
    local destroy = self.Destroy
    if destroy and type(destroy) == "function" then self:Destroy() end
    local className = self.ClassName or "UnnamedClass"
    SingletonRegistry[className] = nil
end
--- Returns the existing singleton for a class.
--- @param className string: The name of the class to check.
--- @return any: The singleton instance, or nil if none exists.
function Singleton.Get(className)
    return SingletonRegistry[className]
end

return Singleton