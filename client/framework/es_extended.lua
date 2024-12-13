local ESX = exports.es_extended:getSharedObject()
local esx = {}
local officer = {}

esx.loadedEvent = 'esx:playerLoaded'
esx.logoutEvent = 'esx:onPlayerLogout'
esx.setGroupEvent = 'esx:setJob'

function esx.getOfficerData()
    local playerData = ESX.PlayerData

    officer.citizenid = playerData.identifier
    officer.firstname = playerData.firstname
    officer.lastname = playerData.lastname
    officer.role = playerData.job.grade_name
    officer.role = playerData.job.grade

    return officer
end

function esx.notify(text, type)
    lib.notify({
        description = text,
        type = type
    })
end

function esx.isJobPolice()
    return ESX.PlayerData.job.name == 'police' and true or false
end

---@todo Provide Proper Job Implementation
function esx.isOnDuty()
    return true
end

---@todo Provide Proper Implementation
function esx.GetVehiclesByName()
    return 'Unknown'
end

function esx.getPlayerGender()
    return ESX.PlayerData.sex
end

return esx
