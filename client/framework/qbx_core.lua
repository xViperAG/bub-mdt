local qb = {}
local officer = {}

qb.loadedEvent = 'QBCore:Client:OnPlayerLoaded'
qb.logoutEvent = 'QBCore:Client:OnPlayerUnload'
qb.setGroupEvent = 'QBCore:Client:OnJobUpdate'

function qb.getOfficerData()
    local playerData = QBX.PlayerData

    officer.citizenid = playerData.citizenid
    officer.firstname = playerData.charinfo.firstname
    officer.lastname = playerData.charinfo.lastname
    officer.role = playerData.job.grade.name
    officer.grade = playerData.job.grade.level

    return officer
end

function qb.notify(text, type)
    exports.qbx_core:Notify(text, type)
end

function qb.isJobPolice()
    return (QBX.PlayerData.job.type == 'leo' or QBX.PlayerData.job.type == 'doj') and true or false
end

function qb.isOnDuty()
    return QBX.PlayerData.job.onduty and true or false
end

function qb.GetVehiclesByName()
    return exports.qbx_core:GetVehiclesByName()
end

function qb.getPlayerGender()
    return QBX.PlayerData.charinfo.gender == 1 and "Female" or "Male"
end

return qb
