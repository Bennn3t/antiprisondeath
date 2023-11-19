games {'gta5'}

fx_version 'cerulean'

name "antiprisondeath"
description "Stops players dying while in prison"
author "Benn3t"
version "1.0"

client_scripts {
    'config.lua',
    'client/*.lua',
    '@PolyZone/client.lua', -- QBCore (Disable if using BJCore)
    -- '@polyzone/client.lua' -- BJCore (Disable if using QBCore)
}

dependencies {
    "PolyZone", -- QBCore (Disable if using BJCore)
    -- "polyzone" -- BJCore (Disable if using QBCore)
}

server_scripts {
    'config.lua',
    'server/*.lua',
}
