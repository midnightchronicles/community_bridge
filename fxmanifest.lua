fx_version 'cerulean'
game 'gta5'
lua54 'yes'
use_experimental_fxv2_oal 'yes'
author 'The Order of the Sacred Framework'
description 'A bridge made for the community to use as a base for their own projects. This bridge will allow a single format to work with nearly all commonly used systems while still offering expandability.'
version '0.6.1'

shared_scripts {
    '@ox_lib/init.lua',
    'lib/init.lua',
    'settings/sharedConfig.lua',
    'modules/math/*.lua',
    'modules/locales/*.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'settings/serverConfig.lua',
    'modules/locales/shared.lua',
    'modules/version/server/*.lua',
    'modules/framework/**/server.lua',
    'modules/inventory/**/server.lua',
    'modules/doorlock/**/server.lua',
    'modules/phone/**/server.lua',
    'modules/managment/**/server.lua',
    'modules/dispatch/**/server.lua',
    'modules/clothing/**/server.lua',
    'modules/shops/**/server.lua',
    'modules/helptext/**/server.lua',
    'modules/notify/**/server.lua',
    'modules/housing/**/server.lua',
    'modules/skills/**/server.lua',
    'init.lua',
}

client_scripts {
    'settings/clientConfig.lua',
    'modules/locales/shared.lua',
    'modules/framework/**/client.lua',
    'modules/inventory/**/client.lua',
    'modules/doorlock/**/client.lua',
    'modules/phone/**/client.lua',
    'modules/weather/**/client.lua',
    'modules/vehicleKey/**/client.lua',
    'modules/fuel/**/client.lua',
    'modules/target/**/client.lua',
    'modules/dispatch/**/client.lua',
    'modules/progressbar/**/client.lua',
    'modules/clothing/**/client.lua',
    'modules/input/*.lua',
    'modules/menu/*.lua',
    'modules/helptext/**/client.lua',
    'modules/notify/**/client.lua',
    'modules/dialogue/**/client/*.lua',
    'modules/shops/**/client.lua',
    'modules/housing/**/client.lua',
    'modules/accessibility/client.lua',
    'modules/skills/**/client.lua',
    'init.lua',
}

ui_page 'web/dist/index.html'

files {
    'web/dist/index.html',
    'web/dist/assets/*.css',
    'web/dist/assets/*.js',
    'locales/*.json',
    'lib/**/client/*.lua',
    'lib/**/shared/*.lua',
    'lib/**/server/*.lua',
    'lib/init.lua',
}

dependencies {
    '/server:6116',
    '/onesync',
    'ox_lib',
}
