local qbx = {}
local officer = {}

qbx.loadedEvent = 'QBCore:Client:OnPlayerLoaded'
qbx.logoutEvent = 'QBCore:Client:OnPlayerUnload'
qbx.setGroupEvent = 'QBCore:Client:OnJobUpdate'

function qbx.getOfficerData()
    local playerData = QBX.PlayerData

    officer.citizenid = playerData.citizenid
    officer.firstname = playerData.charinfo.firstname
    officer.lastname = playerData.charinfo.lastname
    officer.role = playerData.job.grade.name
    officer.grade = playerData.job.grade.level

    return officer
end

function qbx.notify(text, type)
    exports.qbx_core:Notify(text, type)
end

function qbx.isJobPolice()
    return (QBX.PlayerData.job.type == 'leo' or QBX.PlayerData.job.type == 'doj') and true or false
end

function qbx.isOnDuty()
    return QBX.PlayerData.job.onduty and true or false
end

function qbx.GetVehiclesByName()
    return exports.qbx_core:GetVehiclesByName()
end

function qbx.getPlayerGender()
    return QBX.PlayerData.charinfo.gender == 1 and "Female" or "Male"
end

return qbx
