BridgeClientConfig = {}
BridgeClientConfig.DebugLevel        = 0            -- Debug level, 0 for none, 1 for some, 2 for all data
BridgeClientConfig.NotifySystem      = "ox"         -- [ ox | qb | esx | mythic | pNotify | t-notify | wasabi | lab | custom ]
BridgeClientConfig.ShowHelpText      = "auto"       -- [ ox | qb | jg | okok | cd | lab | custom ]
BridgeClientConfig.InputSystem       = "auto"       -- [ auto | ox | qb ]
BridgeClientConfig.MenuSystem        = "auto"       -- [ auto | ox | qb ]
BridgeClientConfig.ProgressBarSystem = "auto"       -- [ auto | ox | qb ]
BridgeClientConfig.ZoneSystem        = "ox"         -- [ ox | poly ]
BridgeClientConfig.VehicleKey        = "auto"       -- [ auto | qb-vehiclekeys | MrNewbVehicleKeys | qbx | cd | f_real | mk | mono | okok | qs | renewed | t1ger | wasabi ]
BridgeClientConfig.Fuel              = "auto"       -- [ LegacyFuel | ox_fuel | ps-fuel | qs-fuelstations | Renewed-Fuel | ti_fuel | x-fuel | okokGasStation | BigDaddy | cdn | sna |  ] 
BridgeClientConfig.TargetSystem      = "ox"         -- [ ox | qb | sleepless | auto ] -- sleepless is only partially supported and would need another system in place

return BridgeClientConfig