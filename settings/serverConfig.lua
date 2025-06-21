BridgeServerConfig = {}
BridgeServerConfig.LogSystem = "built-in"                     -- [ built-in | qb | ox_lib ]
BridgeServerConfig.WebhookURL = ""                           -- only if using builtin, put in the channels webhook url
BridgeServerConfig.WebhookImage = "https://cdn.discordapp.com/avatars/299410129982455808/31ce635662206e8bd0132c34ce9ce683?size=1024"
BridgeServerConfig.MaxInventorySlots = 50

return BridgeServerConfig
