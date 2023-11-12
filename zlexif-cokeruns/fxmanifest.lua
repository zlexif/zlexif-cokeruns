fx_version 'cerulean'
games { 'gta5' }

author 'Zlexif'
description 'Coke runs script for QBCore Framework'
version '1.0.0'

-- Shared Script
server_script 'server/server.lua'

shared_script 'shared/config.lua'

-- Client Scripts
client_scripts {
    '@PolyZone/client.lua',
    '@PolyZone/BoxZone.lua',
    '@PolyZone/EntityZone.lua',
    '@PolyZone/CircleZone.lua',
    '@PolyZone/ComboZone.lua',
    'client/client.lua'
}

-- Dependencies
dependencies {
    'qb-core',
    'qb-target',  -- Ensure qb-target is installed and running on your server
    'PolyZone',   -- Required for zone management
    'progressbar'
}
