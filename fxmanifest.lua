fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'The Order of the Sacred Framework'
description 'A bridge made for the community to use as a base for their own projects. This bridge will allow a single format to work with nearly all commonly used systems while still offering expandability.'
version '0.0.10'

shared_scripts {
    'settings/sharedConfig.lua',
    'use/*.lua',
    'modules/Utility/shared/*.lua',
    'modules/locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'settings/serverConfig.lua',
    'modules/locales/shared.lua',
    'modules/Utility/server/*.lua',
    'modules/Framework/**/server.lua',
    'modules/Inventory/**/server.lua',
    'modules/Doorlock/**/server.lua',
    'modules/Phone/**/server.lua',
    'modules/Notify/server.lua',
    'modules/Managment/**/server.lua',
    'init.lua',
}

client_scripts {
    'settings/clientConfig.lua',
    'modules/locales/shared.lua',
    'modules/Utility/client/*.lua',
    'modules/Framework/**/client.lua',
    'modules/Inventory/**/client.lua',
    'modules/Doorlock/**/client.lua',
    'modules/Phone/**/client.lua',
    'modules/Notify/client.lua',
    'modules/Weather/**/client.lua',
    'modules/VehicleKey/**/client.lua',
    'modules/Fuel/**/client.lua',
    'modules/Target/**/client.lua',
    'modules/Dispatch/**/client.lua',
    'modules/Progressbar/**/client.lua',
    'modules/Clothing/**/client.lua',
    'modules/Input/client.lua',
    'modules/math/*.lua',
    'modules/menu/client.lua',
    'init.lua',
}

files {
    'locales/*.json',
    'components/*.lua',
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
}