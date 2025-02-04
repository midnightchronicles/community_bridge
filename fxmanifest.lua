fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
author 'The Order of the Sacred Framework'
description 'A bridge made for the community to use as a base for their own projects. This bridge will allow a single format to work with nearly all commonly used systems while still offering expandability.'
version '0.2.1'

shared_scripts {
    '@ox_lib/init.lua',
    'settings/sharedConfig.lua',
    'use/*.lua',
    'modules/utility/shared/*.lua',
    'modules/math/*.lua',
    'modules/locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'settings/serverConfig.lua',
    'modules/locales/shared.lua',
    'modules/utility/server/*.lua',
    'modules/framework/**/server.lua',
    'modules/inventory/**/server.lua',
    'modules/doorlock/**/server.lua',
    'modules/phone/**/server.lua',
    'modules/notify/server.lua',
    'modules/managment/**/server.lua',
    'init.lua',
}

client_scripts {
    'settings/clientConfig.lua',
    'modules/locales/shared.lua',
    'modules/utility/client/*.lua',
    'modules/framework/**/client.lua',
    'modules/inventory/**/client.lua',
    'modules/doorlock/**/client.lua',
    'modules/phone/**/client.lua',
    'modules/notify/client.lua',
    'modules/weather/**/client.lua',
    'modules/vehicleKey/**/client.lua',
    'modules/fuel/**/client.lua',
    'modules/target/**/client.lua',
    'modules/dispatch/**/client.lua',
    'modules/progressbar/**/client.lua',
    'modules/clothing/**/client.lua',
    'modules/input/*.lua',
    'modules/menu/*.lua',
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
