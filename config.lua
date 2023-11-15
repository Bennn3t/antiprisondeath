Config = Config or {}

Config = {
    MinHealth = 100, -- Health the player will get respawned at.
    Framework = 'QBCore', -- QBCore or BJCore
    ShowDebugPrints = true, -- Set to false if live server
    CheckPrisonGrounds = true, -- Checks if player is within the prison grounds before Reviving
    TeleportLocation = vector4(1765.6617, 2565.9589, 45.564975, 175.65957), -- Location player gets teleported to if CheckPrisonGrounds is set to true and they have time in jail left.
    NPCAttack = true, -- Only revive if player is attacked by NPC not player if set to false it will revive if player dies to another player
    FallDamage = true -- Revives player after fall damage
}
