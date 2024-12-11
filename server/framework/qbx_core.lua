local QBX = exports.qbx_core
local officers = require 'server.officers'

local function addOfficer(playerId)
    if officers.get(playerId) then return end

    local player = QBX:GetPlayer(playerId)
    if not player then return end

    if player.PlayerData.job.type == 'leo' or player.PlayerData.job.type == 'doj' then
        officers.add(playerId, player.PlayerData.charinfo.firstname, player.PlayerData.charinfo.lastname, player.PlayerData.citizenid)
        MySQL.prepare.await('INSERT INTO `mdt_profiles` (`citizenid`, `image`, `notes`, `lastActive`) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE `lastActive` = NOW()', { player.PlayerData.citizenid, nil, nil })
    end
end

CreateThread(function()
    for _, playerId in pairs(GetPlayers()) do
        addOfficer(tonumber(playerId))
    end
end)

RegisterNetEvent('QBCore:Server:OnPlayerLoaded', function()
    addOfficer(source)
end)

AddEventHandler("QBCore:Server:OnJobUpdate", function(source, job)
    local officer = officers.get(source)

    if officer then
        if job.type ~= 'leo' or job.type ~= 'doj' then
            return officers.remove(source)
        end

        return
    end

    addOfficer(source)
end)

RegisterNetEvent('QBCore:Server:OnPlayerUnload', function(playerId)
    local officer = officers.get(playerId)

    if officer then
        officers.remove(playerId)
    end
end)

local qbx = {}

-- Dashboard
function qbx.getAnnouncements()
    local announcements = MySQL.rawExecute.await([[
        SELECT
            a.id,
            a.contents,
            a.creator AS citizenid,
            b.charinfo,
            c.image,
            DATE_FORMAT(a.createdAt, "%Y-%m-%d %T") AS createdAt
        FROM
            `mdt_announcements` a
        LEFT JOIN
            `players` b
        ON
            b.citizenid = a.creator
        LEFT JOIN
            `mdt_profiles` c
        ON
            c.citizenid = a.creator
    ]])

    local result = {}
    for i = 1, #announcements do
        local charinfo = json.decode(announcements[i].charinfo)
        table.insert(result, { 
            id = announcements[i].id, 
            contents = announcements[i].contents, 
            citizenid = announcements[i].citizenid, 
            firstname = charinfo.firstname, 
            lastname = charinfo.lastname,
            image = announcements[i].image,
            createdAt = announcements[i].createdAt
        })
    end

    return result
end

local selectWarrants = [[
    SELECT
        warrants.incidentid,
        players.citizenid,
        players.charinfo,
        DATE_FORMAT(warrants.expiresAt, "%Y-%m-%d %T") AS expiresAt,
        c.image
    FROM
        `mdt_warrants` warrants
    LEFT JOIN
        `players`
    ON
        warrants.citizenid = players.citizenid
    LEFT JOIN
        `mdt_profiles` c
    ON
        c.citizenid = players.citizenid
]]

function qbx.getWarrants()
    local queryResult = MySQL.rawExecute.await(selectWarrants, {})
    local warrants = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        warrants[#warrants+1] = {
            incidentid = v.incidentid,
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            expiresAt = v.expiresAt,
            image = v.image
        }
    end

    return warrants
end

function qbx.getCharacterProfile(parameters)
    local result = MySQL.rawExecute.await([[
        SELECT
            a.charinfo,
            a.metadata,
            a.citizenid,
            b.image,
            b.notes,
            b.fingerprint
        FROM
            `players` a
        LEFT JOIN
            `mdt_profiles` b
        ON
            b.citizenid = a.citizenid
        WHERE
            a.citizenid = ?
    ]], parameters)?[1]
    local profile

    if result then
        local charinfo = json.decode(result.charinfo)
        local metadata = json.decode(result.metadata)

        profile = {
            citizenid = result.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            dob = charinfo.birthdate,
            phoneNumber = charinfo.phone, -- Get phone number, example: exports["lb-phone"]:GetEquippedPhoneNumber(result.citizenid)
            fingerprint = result.fingerprint or 'Unknown',
            notes = result.notes,
            image = result.image,
        }
    end

    return profile
end

-- Profiles
local selectProfiles = [[
    SELECT
        players.citizenid,
        players.charinfo,
        profile.image
    FROM
        players
    LEFT JOIN
        mdt_profiles profile
    ON
        profile.citizenid = players.citizenid
    LIMIT 10 OFFSET ?
]]

function qbx.getAllProfiles()
    local profilesResult = MySQL.rawExecute.await(selectProfiles, {})
    local profiles = {}

    for _, v in pairs(profilesResult) do
        local charinfo = json.decode(v.charinfo)
        profiles[#profiles+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            dob = charinfo.birthdate,
            image = v.image,
        }
    end

    return profiles
end

local selectProfilesFilter = selectProfiles:gsub('LIMIT', [[
    WHERE 
        players.citizenid LIKE ?
        OR CONCAT(
            JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.firstname')),
            ' ',
            JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.lastname'))
        ) LIKE ?
    GROUP BY
        players.citizenid
    LIMIT
]])

function qbx.getProfiles(parameters, filter)
    local query, params
    
    if filter then
        local searchInput = parameters[1]
        params = { "%" .. searchInput .. "%", "%" .. searchInput .. "%", parameters[2] }
        
        query = selectProfilesFilter
    else
        query = selectProfiles
        params = parameters
    end

    local profilesResult = MySQL.rawExecute.await(query, params)
    local profiles = {}

    for _, v in pairs(profilesResult) do
        local charinfo = json.decode(v.charinfo)
        profiles[#profiles+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            dob = charinfo.birthdate,
            image = v.image,
        }
    end

    return profiles
end

function qbx.getDriverPoints(citizenid)
    local result = MySQL.rawExecute.await('SELECT SUM(COALESCE(points, 0) * COALESCE(count, 1)) AS total_points FROM mdt_incidents_charges WHERE citizenid = ?', { citizenid })?[1]
    if (result.total_points) then return result.total_points end

    return 0
end

function qbx.isProfileWanted(citizenid)
    local response = MySQL.rawExecute.await('SELECT * FROM `mdt_warrants` WHERE `citizenid` = ?', {
        citizenid
    })
    
    return response[1] and true or false
end

function qbx.getVehiclesForProfile(parameters)
    local sharedVehicles = QBX:GetVehiclesByName()
    local vehicles = MySQL.rawExecute.await('SELECT `plate`, `vehicle` FROM `player_vehicles` WHERE `citizenid` = ?', parameters) or {}

    for _, v in pairs(vehicles) do
        v.label = sharedVehicles[v.vehicle]?.name or v.vehicle
        v.vehicle = nil
    end

    return vehicles
end

function qbx.getLicenses(citizenid)
    local player = QBX:GetPlayerByCitizenId(citizenid)
    if not player then 
        local result = MySQL.rawExecute.await([[
        SELECT
            metadata
        FROM
            players
        WHERE
            citizenid = ?
        ]], { citizenid })?[1]
        local metadata = json.decode(result.metadata)

        return metadata.licences
    end

    return player.PlayerData.metadata.licences
end

function qbx.getJobs(parameters)
    local sharedJobs = exports.qbx_core:GetJobs()
    local result = MySQL.rawExecute.await([[
        SELECT
            job,
            metadata
        FROM
            players
        WHERE
            citizenid = ?
    ]], parameters)?[1]
    local job = json.decode(result.job)
    local metadata = json.decode(result.metadata)
    local jobs = {}
    local otherJobs = GetResourceState('qb-phone'):match('started') and exports['qb-phone']:getJobs(parameters[1])

    table.insert(jobs, { job = job.label, gradeLabel = job.grade.name })

    if metadata.otherjobs then
        for k, v in pairs(metadata.otherjobs) do
            if not sharedJobs[k] then goto continue end

            table.insert(jobs, { job = k, gradeLabel = sharedJobs[k].grades['' .. v .. ''].name })
            ::continue::
        end
    end

    if GetResourceState('qb-phone'):match('started') then
        for k, v in pairs(otherJobs) do
            if not sharedJobs[k] then goto continue end

            table.insert(jobs, { job = sharedJobs[k].label, gradeLabel = sharedJobs[k].grades[otherJobs[k].grade].name })
            ::continue::
        end
    end

    return jobs
end

function qbx.getGangs(parameters)
    local sharedGangs = exports.qbx_core:GetGangs()
    local result = MySQL.rawExecute.await([[
        SELECT
            gang,
            metadata
        FROM
            players
        WHERE
            citizenid = ?
    ]], parameters)?[1]
    local gang = json.decode(result.gang)
    local metadata = json.decode(result.metadata)
    local gangs = {}

    table.insert(gangs, { gang = gang.label, gradeLabel = gang.grade.name })

    if metadata.otherjobs then
        for k, v in pairs(metadata.otherjobs) do
            if not sharedGangs[k] then goto continue end

            table.insert(gangs, { gang = k, gradeLabel = sharedGangs[k].grades['' .. v .. ''].name })
            ::continue::
        end
    end

    return gangs
end

-- Still needs implementation
function qbx.getProperties(parameters)
    local result = MySQL.query.await([[
        SELECT 
            CASE
                WHEN p.type = 'IPL' AND p.buildingid IS NULL THEN JSON_EXTRACT(p.metadata, '$.enterData')
                WHEN p.type = 'IPL' AND p.buildingid IS NOT NULL THEN JSON_EXTRACT(b.metadata, '$.enterData')
                WHEN p.type = 'MLO' THEN JSON_EXTRACT(p.metadata, '$.managePoint')
                WHEN p.type = 'Shell' THEN JSON_EXTRACT(p.metadata, '$.enterData')
                ELSE NULL
            END AS coords,
            p.label
        FROM
            properties p
        LEFT JOIN buildings b ON p.buildingid = b.id
        JOIN properties_owners po ON po.property_id = p.id
        WHERE
            po.identifier = ?
    ]], { parameters[1] })
    local properties = {}

    for _, property in pairs(result) do
        table.insert(properties, { label = property.label })
    end

    return properties
end

function qbx.getOfficersInvolved(parameters)
    local queryResult = MySQL.rawExecute.await([[
        SELECT
            players.citizenid,
            players.charinfo,
            profile.callSign
        FROM
            mdt_incidents_officers officer
        LEFT JOIN
            players
        ON
            players.citizenid = officer.citizenid
        LEFT JOIN
            mdt_profiles profile
        ON 
            players.citizenid = profile.citizenid
        WHERE
            incidentid = ?
    ]], parameters)

    local officers = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        officers[#officers+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            callsign = v.callSign,
        }
    end

    return officers
end

function qbx.getOfficersInvolvedReport(parameters)
    local queryResult = MySQL.rawExecute.await([[
        SELECT
            players.citizenid,
            players.charinfo,
            profile.callSign
        FROM
            mdt_reports_officers officer
        LEFT JOIN
            players
        ON
            players.citizenid = officer.citizenid
        LEFT JOIN
            mdt_profiles profile
        ON 
            players.citizenid = profile.citizenid
        WHERE
            reportid = ?
    ]], parameters)

    local officers = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        officers[#officers+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            callsign = v.callSign,
        }
    end

    return officers
end

function qbx.getCitizensInvolvedReport(parameters)
    local queryResult = MySQL.rawExecute.await([[
        SELECT
            players.citizenid,
            players.charinfo
        FROM
            mdt_reports_citizens officer
        LEFT JOIN
            players
        ON
            players.citizenid = officer.citizenid
        LEFT JOIN
            mdt_profiles profile
        ON 
            players.citizenid = profile.citizenid
        WHERE
            reportid = ?
    ]], parameters)

    local citizens = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        citizens[#citizens+1] = {
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            citizenid = v.citizenid,
            dob = charinfo.birthdate
        }
    end

    return citizens
end

function qbx.getCriminalsInvolved(parameters)
    local queryResult = MySQL.rawExecute.await([[
        SELECT DISTINCT
            criminal.citizenid,
            criminal.reduction,
            players.charinfo,
            DATE_FORMAT(criminal.warrantExpiry, "%Y-%m-%d") AS warrantExpiry,
            criminal.processed,
            criminal.pleadedGuilty
        FROM
            mdt_incidents_criminals criminal
        LEFT JOIN
            players
        ON
            players.citizenid = criminal.citizenid
        WHERE
            incidentid = ?
    ]], parameters)

    local involvedCriminals = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        involvedCriminals[#involvedCriminals+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            reduction = v.reduction,
            warrantExpiry = v.warrantExpiry,
            processed = v.processed,
            pleadedGuilty = v.pleadedGuilty
        }
    end

    return involvedCriminals
end

function qbx.getCriminalCharges(parameters)
  return MySQL.rawExecute.await([[
      SELECT
          citizenid,
          charge as label,
          type,
          time,
          fine,
          count,
          points
      FROM
          mdt_incidents_charges
      WHERE
          incidentid = ?
      GROUP BY
          charge, citizenid
  ]], parameters)
end

local selectOfficers = [[
    SELECT
        mdt_profiles.id,
        players.charinfo,
        players.citizenid,
        player_groups.group AS `group`,
        player_groups.grade,
        mdt_profiles.image,
        mdt_profiles.callSign
    FROM
        player_groups
    LEFT JOIN
        players
    ON
        player_groups.citizenid = players.citizenid
    LEFT JOIN
        mdt_profiles
    ON
        players.citizenid = mdt_profiles.citizenid
    WHERE
        player_groups.group IN ("police")
]]

function qbx.getOfficers()
    local query = selectOfficers
    local queryResult = MySQL.rawExecute.await(query)
    local officers = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        officers[#officers+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            callsign = v.callSign,
        }
    end

    return officers
end

local selectOfficersForRoster = [[
    SELECT
        mdt_profiles.id,
        players.charinfo,
        players.citizenid,
        player_groups.group AS `group`,
        player_groups.grade,
        mdt_profiles.image,
        mdt_profiles.callSign,
        mdt_profiles.apu,
        mdt_profiles.air,
        mdt_profiles.mc,
        mdt_profiles.k9,
        mdt_profiles.fto,
        DATE_FORMAT(mdt_profiles.lastActive, "%Y-%m-%d %T") AS formatted_lastActive
    FROM
        player_groups
    LEFT JOIN
        players
    ON
        player_groups.citizenid = players.citizenid
    LEFT JOIN
        mdt_profiles
    ON
        players.citizenid = mdt_profiles.citizenid
    WHERE
        player_groups.group IN ("police")
]]

local policeJobs = {
    'police',
    'bcso',
    'sasp',
}

function qbx.fetchRoster()
    local query = selectOfficersForRoster
    local queryResult = MySQL.rawExecute.await(query)
    local rosterOfficers = {}

    for i = 1, #policeJobs do
        local job = QBX:GetJob(policeJobs[i])

        for _, v in pairs(queryResult) do
            local charinfo = json.decode(v.charinfo)
            rosterOfficers[#rosterOfficers+1] = {
                citizenid = v.citizenid,
                firstname = charinfo.firstname,
                lastname = charinfo.lastname,
                callsign = v.callSign,
                image = v.image,
                title = job.grades[v.grade].name,
                apu = v.apu,
                air = v.air,
                mc = v.mc,
                k9 = v.k9,
                fto = v.fto,
                lastActive = v.formatted_lastActive
            }
        end

        return rosterOfficers
    end
end

local selectCharacters = [[
    SELECT
        charinfo,
        citizenid
    FROM
        players
]]

local selectCharactersFilter = selectCharacters .. [[
    WHERE 
        players.citizenid LIKE ?
        OR CONCAT(
            JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.firstname')),
            ' ',
            JSON_UNQUOTE(JSON_EXTRACT(players.charinfo, '$.lastname'))
        ) LIKE ?
    GROUP BY
        players.citizenid
]]

function qbx.getCharacters(parameters, filter)
    local searchInput = parameters[1]
    local params = { "%" .. searchInput .. "%", "%" .. searchInput .. "%" }
    local query = filter and selectCharactersFilter or selectCharacters

    local queryResult = MySQL.rawExecute.await(query, params)
    local characters = {}

    for _, v in pairs(queryResult) do
        local charinfo = json.decode(v.charinfo)
        characters[#characters+1] = {
            citizenid = v.citizenid,
            firstname = charinfo.firstname,
            lastname = charinfo.lastname,
            dob = charinfo.birthdate,
        }
    end

    return characters
end

local selectVehicles = [[
    SELECT
        plate,
        vehicle
    FROM
        player_vehicles
]]

function qbx.getVehicles()
  return MySQL.rawExecute.await(selectVehicles)
end

local selectVehicle = [[
    SELECT
        player_vehicles.citizenid,
        player_vehicles.plate,
        player_vehicles.vehicle,
        player_vehicles.mods,
        mdt_vehicles.notes,
        mdt_vehicles.image,
        mdt_vehicles.known_information
    FROM
        player_vehicles
    LEFT JOIN
        mdt_vehicles
    ON
        mdt_vehicles.plate = player_vehicles.plate
    WHERE
        player_vehicles.plate = ?
]]

function qbx.getVehicle(plate)
    local response = MySQL.rawExecute.await(selectVehicle, {plate})?[1]
    local player = QBX:GetPlayerByCitizenId(response.citizenid) or QBX:GetOfflinePlayer(response.citizenid)

    if not player then return end

    local data = {
        plate = response.plate,
        vehicle = response.vehicle,
        mods = response.mods,
        notes = response.notes,
        image = response.image,
        known_information = response.known_information,
        owner = player.PlayerData.charinfo.firstname .. " " .. player.PlayerData.charinfo.lastname .. ' (' .. response.citizenid .. ')'
    }

    return data
end

local selectWeapons = [[
    SELECT
        model,
        serial
    FROM
        mdt_weapons
]]

function qbx.getWeapons()
    return MySQL.rawExecute.await(selectWeapons)
end

local selectedWeapon = [[
    SELECT
        mdt_weapons.model,
        mdt_weapons.class,
        mdt_weapons.serial,
        mdt_weapons.owner,
        mdt_weapons.notes,
        mdt_weapons.image
    FROM
        mdt_weapons
    WHERE
        mdt_weapons.serial = ?
]]

function qbx.getWeapon(serial)
    local result = MySQL.query.await(selectedWeapon, { serial })?[1]
    print('This is the primary result: ', json.encode(result))

    local player = QBX:GetPlayerByCitizenId(result.citizenid) or QBX:GetOfflinePlayer(result.citizenid)

    if not player then return end

    local data = {
        model = result.model,
        class = result.class,
        serial = result.serial,
        notes = result.notes,
        image = result.image,
        known_information = result.known_information,
        owner = result.owner .. ' (' .. result.citizenid .. ')'
    }

    return data
end

function qbx.hireOfficer(data)
    exports.qbx_core:AddPlayerToJob(data.citizenid, 'police', 1)

    local success = MySQL.prepare.await('INSERT INTO `mdt_profiles` (`citizenid`, `callsign`, `lastActive`) VALUES (?, ?, ?) ON DUPLICATE KEY UPDATE `callsign` = ?, `lastActive` = ?', { data.citizenid, data.callsign, os.date("%Y-%m-%d %H:%M:%S"), data.callsign, os.date("%Y-%m-%d %H:%M:%S") })

    return success
end

function qbx.fireOfficer(citizenId)
    exports.qbx_core:RemovePlayerFromJob(citizenId, 'police')
    MySQL.prepare.await('UPDATE `mdt_profiles` SET `callsign` = ? WHERE `citizenid` = ?', { nil, citizenId })

    return true
end

function qbx.setOfficerRank(data)
    exports.qbx_core:AddPlayerToJob(data.citizenId, 'police', data.grade)

    return true
end


return qbx