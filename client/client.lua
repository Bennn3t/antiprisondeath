
if Config.Framework == 'QBCore' then
    Framework = exports['qb-core']:GetCoreObject()
elseif Config.Framework == 'BJCore' then
    Framework = nil
    Citizen.CreateThread(function() 
        while Framework == nil do
            TriggerEvent("BJCore:GetObject", function(obj) Framework = obj end)
            Citizen.Wait(200)
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
                        Citizen.Wait(10)
                    end
                    if Config.ShowDebugPrints then print('Players ragdolled or speed above 0.5 or armed') end
                    if Config.CheckPrisonGrounds then
                        if InPrison then
                            if sourceOfDeath ~= 0 and IsEntityAPed(sourceOfDeath) then
                                if not IsPedAPlayer(sourceOfDeath) then
                                    if Config.ShowDebugPrints then print('Killed by an NPC') end
                                    if Config.NPCAttack then
                                        TriggerEvent('hospital:client:Revive')
                                        if Config.ShowDebugPrints then print('Revivied') end
                                    end
                                else
                                    if Config.ShowDebugPrints then print('Killed by a player') end
                                    if not Config.NPCAttack then
                                        TriggerEvent('hospital:client:Revive')
                                        if Config.ShowDebugPrints then print('Revivied') end
                                    end
                                end
                            else
                                if Config.ShowDebugPrints then print('Killed yourself') end
                                if Config.FallDamage then
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
                                    TriggerEvent('hospital:client:Revive')
                                    if Config.ShowDebugPrints then print('Revivied') end
                                end
                            else
                                if Config.ShowDebugPrints then print('Killed by a player') end
                                if not Config.NPCAttack then
                                    TriggerEvent('hospital:client:Revive')
                                    if Config.ShowDebugPrints then print('Revivied') end
                                end
                            end
                        else
                            if Config.ShowDebugPrints then print('Killed yourself') end
                            if Config.FallDamage then
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
		PrisonZone = PolyZone:Create({
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
		}, {
            name="prison",
            minZ = 40.00642,
            maxZ = 73.213783,
            debugPoly = false -- Set to false if live server
		})
		ManagePrisonZone()
	end

    RegisterNetEvent("BJCore:Client:OnPlayerLoaded")
    AddEventHandler("BJCore:Client:OnPlayerLoaded", function()
        if PrisonZone == nil then
            CreatePrisonZone()
        end
    end)

	function ManagePrisonZone()
		PrisonZone:onPlayerInOut(function(isPointInside, point)
			if isPointInside then
				print("Entered Zone")
				-- print("Point: "..print(point))
                InPrison = true
			else
                InPrison = false
                local Player = Framework.Functions.GetPlayerData()
				if Player.metadata["injail"] > 0 then
					SetEntityCoords(PlayerPedId(), Config.TeleportLocation)
				end
				print("Left Zone")
				-- print("Point: "..print(point))
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
