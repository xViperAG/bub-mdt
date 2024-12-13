local ESX = exports.es_extended:getSharedObject()
local officers = require 'server.officers'

local function addOfficer(playerId)
    if officers.get(playerId) then return end

    local player = ESX.GetPlayerFromId(playerId)
    if not player then return end

    if player.getJob().name == 'police' then
        officers.add(playerId, player.getName().firstname, player.getName().lastname, player.getIdentifier())
        MySQL.prepare.await('INSERT INTO `mdt_profiles` (`citizenid`, `image`, `notes`, `lastActive`) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE `lastActive` = NOW()', { player.PlayerData.citizenid, nil, nil })
    end
end

CreateThread(function()
    for _, playerId in pairs(GetPlayers()) do
        addOfficer(tonumber(playerId))
    end
end)

RegisterNetEvent('esx:playerLoaded', function(playerId)
    addOfficer(playerId)
end)

---@todo Figure out proper implementation
RegisterNetEvent('esx:setJob', function()
    local officer = officers.get(source)

    if officer then
        --
    end

    addOfficer(source)
end)

RegisterNetEvent('esx:playerDropped', function(playerId)
    local officer = officers.get(playerId)

    if officer then
        officers.remove(playerId)
    end
end)

local esx = {}

---@todo Set Up Proper Implementation

return esx