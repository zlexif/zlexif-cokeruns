local QBCore = exports['qb-core']:GetCoreObject()

Citizen.CreateThread(function()
    RequestModel(GetHashKey(Config.NPC.model))
    while not HasModelLoaded(GetHashKey(Config.NPC.model)) do
        Wait(1)
    end

    local npc = CreatePed(4, GetHashKey(Config.NPC.model), Config.NPC.coords.x, Config.NPC.coords.y, Config.NPC.coords.z, Config.NPC.heading, false, true)
    SetEntityInvincible(npc, true)
    FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
end)

exports['qb-target']:AddTargetModel(GetHashKey(Config.NPC.model), {
    options = {
        {
            event = "zlexif-cokeruns:getOrder",
            icon = "fas fa-hand-holding",
            label = "Get Order",
        },
        {
            event = "zlexif-cokeruns:cancelOrder",
            icon = "fas fa-ban",
            label = "Cancel Order",
        },
    },
    distance = 2.5,
})



local dealZone = CircleZone:Create(Config.DealZone.coords, Config.DealZone.radius, {
    name = "dealzone",
    debugPoly = Config.Debug
})



RegisterNetEvent('zlexif-cokeruns:useBurnerPhone')
AddEventHandler('zlexif-cokeruns:useBurnerPhone', function()
    local playerCoords = GetEntityCoords(PlayerPedId())
 
    if dealZone:isPointInside(playerCoords) then
        QBCore.Functions.Progressbar("discussing_deal", "Discussing Deal...", Config.DealDuration, false, true, {
            disableMovement = false,
            disableCarMovement = false,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function() 
            local pedCoords = playerCoords + vector3(5, 5, 0)  
            local pedModel = GetHashKey("a_m_m_skater_01")  

            RequestModel(pedModel)
            while not HasModelLoaded(pedModel) do
                Wait(1)
            end

            local dealerPed = CreatePed(4, pedModel, pedCoords.x, pedCoords.y, pedCoords.z, 0, true, false)
            TaskGoToEntity(dealerPed, PlayerPedId(), -1, 2.0, 2.0, 1073741824, 0)

            Citizen.Wait(5000) 

            TriggerServerEvent('zlexif-cokeruns:completeDeal')  

            SetEntityAsNoLongerNeeded(dealerPed)
            DeletePed(dealerPed)
        end)
    else
        QBCore.Functions.Notify("You are not in the right zone.", "error")  -- Notify player
    end
end)


RegisterNetEvent('zlexif-cokeruns:getOrder')
AddEventHandler('zlexif-cokeruns:getOrder', function()
    TriggerServerEvent('zlexif-cokeruns:getOrder')
end)


RegisterNetEvent('zlexif-cokeruns:cancelOrder')
AddEventHandler('zlexif-cokeruns:cancelOrder', function()
    TriggerServerEvent('zlexif-cokeruns:server:cancelOrder')
end)

