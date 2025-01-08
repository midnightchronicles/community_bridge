fx_version 'cerulean'
game 'gta5'
lua54 'yes'
author 'The Order of the Sacred Framework'
description 'A bridge made for the community to use as a base for their own projects. This bridge will allow a single format to work with nearly all commonly used systems while still offering expandability.'
version '0.0.8'

shared_scripts {
    'settings/sharedConfig.lua',
    'use/*.lua',
    'modules/utilities/shared/*.lua',
    'modules/locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'settings/serverConfig.lua',
    'modules/locales/shared.lua',
    'modules/utilities/server/*.lua',
    'modules/framework/**/server.lua',
    'modules/inventory/**/server.lua',
    'modules/stashes/server.lua',
    'modules/phones/**/server.lua',
    'modules/managment/**/server.lua',
    'modules/notify/server.lua',
    'init.lua',
}

client_scripts {
    'settings/clientConfig.lua',
    'modules/locales/shared.lua',
    'modules/input/client.lua',
    'modules/utilities/client/*.lua',
    'modules/framework/**/client.lua',
    'modules/inventory/**/client.lua',
    'modules/keys/**/client.lua',
    'modules/fuel/**/client.lua',
    'modules/target/**/client.lua',
    'modules/menu/client.lua',
    'modules/notify/client.lua',
    'modules/dispatch/**/client.lua',
    'modules/progressbars/**/client.lua',
    'modules/clothing/**/client.lua',
    'modules/weather/**/client.lua',
    'modules/points/*.lua',
    'modules/math/*.lua',
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