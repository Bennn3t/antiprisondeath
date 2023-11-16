Config = Config or {}

Config = {
    MinHealth = 100, -- Health the player will get respawned at.
    Framework = 'QBCore', -- QBCore or BJCore
    ShowDebugPrints = false, -- Set to false if live server
    CheckPrisonGrounds = true, -- Checks if player is within the prison grounds before Reviving
    TeleportLocation = vector4(1765.6617, 2565.9589, 45.564975, 175.65957), -- Location player gets teleported to if CheckPrisonGrounds is set to true and they have time in jail left.
    NPCAttack = true, -- Only revive if player is attacked by NPC not player if set to false it will revive if player dies to another player
    FallDamage = true, -- Revives player after fall damage
    PolyZonePoints = {
        vector2(1853.1308, 2699.9277),
        vector2(1776.7375, 2766.2687),
        vector2(1648.0854, 2761.9118),
        vector2(1567.1546, 2683.5273),
        vector2(1530.7141, 2586.3063),
        vector2(1535.9989, 2467.802),
        vector2(1655.8057, 2390.0795),
        vector2(1761.768, 2405.101),
        vector2(1827.0704, 2472.1213),
        vector2(1827.5882, 2517.979),
        vector2(1852.0126, 2517.6203)
    },
    PolyzoneOptions = {
        name = "prison",
        minZ = 40.00642,
        maxZ = 73.213783,
        debugPoly = false -- Set to false if live server
    }
}
