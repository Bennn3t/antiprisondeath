games {'gta5'}

fx_version 'cerulean'

description 'Stops players dying to fists while in prison.'
version '1.0'

client_scripts {
    'config.lua',
    'client/*.lua',
    -- '@polyzone/client.lua', -- BJCore (Disable if using QBCore)
    '@PolyZone/client.lua', -- QBCore (Disable if using BJCore)
}

dependencies {
    "PolyZone", -- QBCore (Disable if using BJCore)
    -- "polyzone" -- BJCore (Disable if using QBCore)
}

server_scripts {
    'config.lua',
    'server/*.lua',
}
