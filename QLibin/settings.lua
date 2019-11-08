local utils = require("QLibin\\utils")

local metaQSettings = {}
function metaQSettings:__call(settings)
    self.defaults = utils.copy(settings)
    return settings
end
function metaQSettings:__index(key)
    if not self.defaults[key] then
        utils.log('WARNING: Unexpected settings key "'..utils.dump(key)..'". Return nil.')
        return nil
    end
    return Settings[key] or self.defaults[key]
end


local QSettings = setmetatable({}, metaQSettings)
return QSettings