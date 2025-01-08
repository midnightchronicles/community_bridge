BridgeServerConfig = {}
BridgeServerConfig.LogSystem = "builtin" -- "builtin", "qb", "ox"
BridgeServerConfig.WebhookURL = "PUT_WEBHOOK_URL_HERE"
BridgeServerConfig.WebhookImage = "https://cdn.discordapp.com/avatars/299410129982455808/31ce635662206e8bd0132c34ce9ce683?size=1024"
BridgeServerConfig.MaxInventorySlots = 50
Require("init.lua", "ox_lib")

return BridgeServerConfig
