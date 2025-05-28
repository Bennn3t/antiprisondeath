if Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'BJCore' then
    Framework = nil
    CreateThread(function() 
        while not Framework do
            TriggerEvent("BJCore:GetObject", function(obj) Framework = obj end)
            Wait(200)
        end
    end)
else
    TriggerServerEvent('antideath:server:configerror', 'Error in Config.Framework, please review and try again.')
end

-- Game Event: Entity Damage
AddEventHandler('gameEventTriggered', function(event, data)
    if event ~= "CEventNetworkEntityDamage" then return end

    local Player = Framework.Functions.GetPlayerData()
    local ped = PlayerPedId()
    local victim = NetworkGetPlayerIndexFromPed(data[1])
    local sourceOfDeath = GetPedSourceOfDeath(ped)

    if victim ~= PlayerId() or Player.metadata["injail"] <= 0 then return end

    if Config.ShowDebugPrints then print('Player has jail time') end
    if GetEntityHealth(ped) >= Config.MinHealth then return end

    if Config.ShowDebugPrints then print('Players health is below Config.MinHealth') end

    while GetEntitySpeed(ped) > 0.5 or IsPedRagdoll(ped) or IsPedArmed(ped) do
        Wait(10)
    end

    if Config.ShowDebugPrints then print('Players ragdolled or speed above 0.5 or armed') end

    local function handleRevive(shouldRevive)
        if shouldRevive then
            Wait(150)
            TriggerEvent('hospital:client:Revive')
            if Config.ShowDebugPrints then print('Revived') end
        end
    end

    local isNPC = sourceOfDeath ~= 0 and IsEntityAPed(sourceOfDeath) and not IsPedAPlayer(sourceOfDeath)

    local function evaluateDeath()
        if isNPC then
            if Config.ShowDebugPrints then print('Killed by an NPC') end
            handleRevive(Config.NPCAttack)
        elseif sourceOfDeath ~= 0 and IsEntityAPed(sourceOfDeath) then
            if Config.ShowDebugPrints then print('Killed by a player') end
            handleRevive(not Config.NPCAttack)
        else
            if Config.ShowDebugPrints then print('Killed yourself') end
            handleRevive(Config.FallDamage)
        end
    end

    if Config.CheckPrisonGrounds then
        if InPrison then evaluateDeath() end
    else
        evaluateDeath()
    end
end)

-- Prison Zone Handling
if Config.CheckPrisonGrounds then 
    InPrison = false

    local function ManagePrisonZone()
        PrisonZone:onPlayerInOut(function(isPointInside, point)
            InPrison = isPointInside
            if Config.ShowDebugPrints then print(isPointInside and "Entered Zone" or "Left Zone") end
            if not isPointInside then
                local Player = Framework.Functions.GetPlayerData()
                if Player.metadata["injail"] > 0 then
                    SetEntityCoords(PlayerPedId(), Config.TeleportLocation)
                end
            end
        end)
    end

    local function CreatePrisonZone()
        PrisonZone = PolyZone:Create(Config.PolyZonePoints, Config.PolyzoneOptions)
        ManagePrisonZone()
    end

    local function onPlayerLoaded()
        if not PrisonZone then
            CreatePrisonZone()
        end
    end

    if Config.Framework == 'QBCore' then
        RegisterNetEvent("QBCore:Client:OnPlayerLoaded", onPlayerLoaded)
    elseif Config.Framework == 'BJCore' then
        RegisterNetEvent("BJCore:Client:OnPlayerLoaded", onPlayerLoaded)
    end

    AddEventHandler('onResourceStart', function(resource)
        if GetCurrentResourceName() == resource and not PrisonZone then
            CreatePrisonZone()
        end
    end)
end
