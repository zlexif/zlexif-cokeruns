QBCore = exports['qb-core']:GetCoreObject()

-- Table to keep track of players' order status
local playerOrderStatus = {}

-- Event to handle getting an order (giving burner phone)
RegisterServerEvent('zlexif-cokeruns:getOrder')
AddEventHandler('zlexif-cokeruns:getOrder', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    -- Check if player already has an active order
    if playerOrderStatus[src] then
        TriggerClientEvent('QBCore:Notify', src, "You already have an active order!", "error")
        return
    end

    if Player then
        -- Attempt to add the burner phone to the player's inventory
        local itemAdded = Player.Functions.AddItem(Config.BurnerPhone, 1)
        if itemAdded then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.BurnerPhone], 'add')
            TriggerClientEvent('QBCore:Notify', src, "Go make a deal", "success")
            playerOrderStatus[src] = true  -- Mark order status as active
        else
            TriggerClientEvent('QBCore:Notify', src, "You cannot carry more items", "error")
        end
    end
end)

-- Make the burner phone item usable
QBCore.Functions.CreateUseableItem("burnerphone", function(source)
    TriggerClientEvent('zlexif-cokeruns:useBurnerPhone', source)
end)

-- Function to reset player's order status
local function resetPlayerOrderStatus(playerId)
    playerOrderStatus[playerId] = nil
end

-- Event to handle the completion of the deal (giving the reward)
RegisterServerEvent('zlexif-cokeruns:completeDeal')
AddEventHandler('zlexif-cokeruns:completeDeal', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if Player then
        -- Remove the burner phone
        if Player.Functions.RemoveItem(Config.BurnerPhone, 1) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.BurnerPhone], 'remove')
        end

        -- Give the reward item
        if Player.Functions.AddItem(Config.RewardItem, Config.RewardAmount) then
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.RewardItem], 'add')
            resetPlayerOrderStatus(src)  -- Reset order status after completion
        else
            TriggerClientEvent('QBCore:Notify', src, 'You cannot carry more items', 'error')
        end
    end
end)

-- Event to handle order cancellation
RegisterServerEvent('zlexif-cokeruns:server:cancelOrder')
AddEventHandler('zlexif-cokeruns:server:cancelOrder', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if Player then
        -- Check if the player has the burner phone
        if Player.Functions.GetItemByName(Config.BurnerPhone) then
            -- Remove the burner phone from the player's inventory
            Player.Functions.RemoveItem(Config.BurnerPhone, 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[Config.BurnerPhone], 'remove')

            -- Deduct cancellation fee (if any)
            local cancellationFee = Config.OrderCancellationFee or 0
            if cancellationFee > 0 then
                Player.Functions.RemoveMoney('bank', cancellationFee)
                TriggerClientEvent('QBCore:Notify', src, "Order cancelled. A fee of $" .. cancellationFee .. " has been charged.", "error")
            else
                TriggerClientEvent('QBCore:Notify', src, "Order cancelled.", "success")
            end
            resetPlayerOrderStatus(src)  -- Reset order status after cancellation
        else
            TriggerClientEvent('QBCore:Notify', src, "You don't have an order to cancel.", "error")
        end
    end
end)
