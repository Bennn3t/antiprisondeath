
if Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'BJCore' then
    Framework = nil
    CreateThread(function() 
        while Framework == nil do
            TriggerEvent("BJCore:GetObject", function(obj) Framework = obj end)
            Wait(200)
        end
    end)
else
    local message = 'Error in Config.Framework, please review and try again.'
    TriggerServerEvent('antideath:server:configerror', message)
end


AddEventHandler('gameEventTriggered', function(event, data)
    if event == "CEventNetworkEntityDamage" then
        local Player = Framework.Functions.GetPlayerData()
        local playerPed = PlayerPedId()
        local victim = NetworkGetPlayerIndexFromPed(data[1])
        local sourceOfDeath = GetPedSourceOfDeath(playerPed)

        if victim == PlayerId() then
            ped = PlayerPedId()
            if Player.metadata["injail"] > 0 then
                if Config.ShowDebugPrints then print('Player has jail time') end
                if GetEntityHealth(ped) < Config.MinHealth then
                    if Config.ShowDebugPrints then print('Players health is below Config.MinHealth') end
                    while GetEntitySpeed(ped) > 0.5 or IsPedRagdoll(ped) or IsPedArmed(ped) do
                        Wait(10)
                    end
                    if Config.ShowDebugPrints then print('Players ragdolled or speed above 0.5 or armed') end
                    if Config.CheckPrisonGrounds then
                        if InPrison then
                            if sourceOfDeath ~= 0 and IsEntityAPed(sourceOfDeath) then
                                if not IsPedAPlayer(sourceOfDeath) then
                                    if Config.ShowDebugPrints then print('Killed by an NPC') end
                                    if Config.NPCAttack then
                                        Wait(150)
                                        TriggerEvent('hospital:client:Revive')
                                        if Config.ShowDebugPrints then print('Revivied') end
                                    end
                                else
                                    if Config.ShowDebugPrints then print('Killed by a player') end
                                    if not Config.NPCAttack then
                                        Wait(150)
                                        TriggerEvent('hospital:client:Revive')
                                        if Config.ShowDebugPrints then print('Revivied') end
                                    end
                                end
                            else
                                if Config.ShowDebugPrints then print('Killed yourself') end
                                if Config.FallDamage then
                                    Wait(150)
                                    TriggerEvent('hospital:client:Revive')
                                    if Config.ShowDebugPrints then print('Revivied') end
                                end
                            end
                        end
                    else
                        if sourceOfDeath ~= 0 and IsEntityAPed(sourceOfDeath) then
                            if not IsPedAPlayer(sourceOfDeath) then
                                if Config.ShowDebugPrints then print('Killed by an NPC') end
                                if Config.NPCAttack then
                                    Wait(150)
                                    TriggerEvent('hospital:client:Revive')
                                    if Config.ShowDebugPrints then print('Revivied') end
                                end
                            else
                                if Config.ShowDebugPrints then print('Killed by a player') end
                                if not Config.NPCAttack then
                                    Wait(150)
                                    TriggerEvent('hospital:client:Revive')
                                    if Config.ShowDebugPrints then print('Revivied') end
                                end
                            end
                        else
                            if Config.ShowDebugPrints then print('Killed yourself') end
                            if Config.FallDamage then
                                Wait(150)
                                TriggerEvent('hospital:client:Revive')
                                if Config.ShowDebugPrints then print('Revivied') end
                            end
                        end
                    end
                end
            end
        end
    end
end)


if Config.CheckPrisonGrounds then 
    InPrison = false
	function CreatePrisonZone()
		PrisonZone = PolyZone:Create(Config.PolyZonePoints, Config.PolyzoneOptions)
		ManagePrisonZone()
	end
    if Config.Framework == 'QBCore' then
        RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
        AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
            if PrisonZone == nil then
                CreatePrisonZone()
            end
        end)
    elseif Config.Framework == 'BJCore' then
        RegisterNetEvent("BJCore:Client:OnPlayerLoaded")
        AddEventHandler("BJCore:Client:OnPlayerLoaded", function()
            if PrisonZone == nil then
                CreatePrisonZone()
            end
        end)
    end

	function ManagePrisonZone()
		PrisonZone:onPlayerInOut(function(isPointInside, point)
			if isPointInside then
                if Config.ShowDebugPrints then print("Entered Zone") end
                InPrison = true
			else
                InPrison = false
                local Player = Framework.Functions.GetPlayerData()
				if Player.metadata["injail"] > 0 then
					SetEntityCoords(PlayerPedId(), Config.TeleportLocation)
				end
                if Config.ShowDebugPrints then print("Left Zone") end
			end
		end)
	end
    AddEventHandler('onResourceStart', function(resource)
        if GetCurrentResourceName() == resource then
            if PrisonZone == nil then
                CreatePrisonZone()
            end
        end
    end)
end
