local utils = {}

local Colors = {
    ['0'] = "Metallic Black",
    ['1'] = "Metallic Graphite Black",
    ['2'] = "Metallic Black Steel",
    ['3'] = "Metallic Dark Silver",
    ['4'] = "Metallic Silver",
    ['5'] = "Metallic Blue Silver",
    ['6'] = "Metallic Steel Gray",
    ['7'] = "Metallic Shadow Silver",
    ['8'] = "Metallic Stone Silver",
    ['9'] = "Metallic Midnight Silver",
    ['10'] = "Metallic Gun Metal",
    ['11'] = "Metallic Anthracite Grey",
    ['12'] = "Matte Black",
    ['13'] = "Matte Gray",
    ['14'] = "Matte Light Grey",
    ['15'] = "Util Black",
    ['16'] = "Util Black Poly",
    ['17'] = "Util Dark silver",
    ['18'] = "Util Silver",
    ['19'] = "Util Gun Metal",
    ['20'] = "Util Shadow Silver",
    ['21'] = "Worn Black",
    ['22'] = "Worn Graphite",
    ['23'] = "Worn Silver Grey",
    ['24'] = "Worn Silver",
    ['25'] = "Worn Blue Silver",
    ['26'] = "Worn Shadow Silver",
    ['27'] = "Metallic Red",
    ['28'] = "Metallic Torino Red",
    ['29'] = "Metallic Formula Red",
    ['30'] = "Metallic Blaze Red",
    ['31'] = "Metallic Graceful Red",
    ['32'] = "Metallic Garnet Red",
    ['33'] = "Metallic Desert Red",
    ['34'] = "Metallic Cabernet Red",
    ['35'] = "Metallic Candy Red",
    ['36'] = "Metallic Sunrise Orange",
    ['37'] = "Metallic Classic Gold",
    ['38'] = "Metallic Orange",
    ['39'] = "Matte Red",
    ['40'] = "Matte Dark Red",
    ['41'] = "Matte Orange",
    ['42'] = "Matte Yellow",
    ['43'] = "Util Red",
    ['44'] = "Util Bright Red",
    ['45'] = "Util Garnet Red",
    ['46'] = "Worn Red",
    ['47'] = "Worn Golden Red",
    ['48'] = "Worn Dark Red",
    ['49'] = "Metallic Dark Green",
    ['50'] = "Metallic Racing Green",
    ['51'] = "Metallic Sea Green",
    ['52'] = "Metallic Olive Green",
    ['53'] = "Metallic Green",
    ['54'] = "Metallic Gasoline Blue Green",
    ['55'] = "Matte Lime Green",
    ['56'] = "Util Dark Green",
    ['57'] = "Util Green",
    ['58'] = "Worn Dark Green",
    ['59'] = "Worn Green",
    ['60'] = "Worn Sea Wash",
    ['61'] = "Metallic Midnight Blue",
    ['62'] = "Metallic Dark Blue",
    ['63'] = "Metallic Saxony Blue",
    ['64'] = "Metallic Blue",
    ['65'] = "Metallic Mariner Blue",
    ['66'] = "Metallic Harbor Blue",
    ['67'] = "Metallic Diamond Blue",
    ['68'] = "Metallic Surf Blue",
    ['69'] = "Metallic Nautical Blue",
    ['70'] = "Metallic Bright Blue",
    ['71'] = "Metallic Purple Blue",
    ['72'] = "Metallic Spinnaker Blue",
    ['73'] = "Metallic Ultra Blue",
    ['74'] = "Metallic Bright Blue",
    ['75'] = "Util Dark Blue",
    ['76'] = "Util Midnight Blue",
    ['77'] = "Util Blue",
    ['78'] = "Util Sea Foam Blue",
    ['79'] = "Uil Lightning blue",
    ['80'] = "Util Maui Blue Poly",
    ['81'] = "Util Bright Blue",
    ['82'] = "Matte Dark Blue",
    ['83'] = "Matte Blue",
    ['84'] = "Matte Midnight Blue",
    ['85'] = "Worn Dark blue",
    ['86'] = "Worn Blue",
    ['87'] = "Worn Light blue",
    ['88'] = "Metallic Taxi Yellow",
    ['89'] = "Metallic Race Yellow",
    ['90'] = "Metallic Bronze",
    ['91'] = "Metallic Yellow Bird",
    ['92'] = "Metallic Lime",
    ['93'] = "Metallic Champagne",
    ['94'] = "Metallic Pueblo Beige",
    ['95'] = "Metallic Dark Ivory",
    ['96'] = "Metallic Choco Brown",
    ['97'] = "Metallic Golden Brown",
    ['98'] = "Metallic Light Brown",
    ['99'] = "Metallic Straw Beige",
    ['100'] = "Metallic Moss Brown",
    ['101'] = "Metallic Biston Brown",
    ['102'] = "Metallic Beechwood",
    ['103'] = "Metallic Dark Beechwood",
    ['104'] = "Metallic Choco Orange",
    ['105'] = "Metallic Beach Sand",
    ['106'] = "Metallic Sun Bleeched Sand",
    ['107'] = "Metallic Cream",
    ['108'] = "Util Brown",
    ['109'] = "Util Medium Brown",
    ['110'] = "Util Light Brown",
    ['111'] = "Metallic White",
    ['112'] = "Metallic Frost White",
    ['113'] = "Worn Honey Beige",
    ['114'] = "Worn Brown",
    ['115'] = "Worn Dark Brown",
    ['116'] = "Worn straw beige",
    ['117'] = "Brushed Steel",
    ['118'] = "Brushed Black Steel",
    ['119'] = "Brushed Aluminium",
    ['120'] = "Chrome",
    ['121'] = "Worn Off White",
    ['122'] = "Util Off White",
    ['123'] = "Worn Orange",
    ['124'] = "Worn Light Orange",
    ['125'] = "Metallic Securicor Green",
    ['126'] = "Worn Taxi Yellow",
    ['127'] = "Police Car Blue",
    ['128'] = "Matte Green",
    ['129'] = "Matte Brown",
    ['130'] = "Worn Orange",
    ['131'] = "Matte White",
    ['132'] = "Worn White",
    ['133'] = "Worn Olive Army Green",
    ['134'] = "Pure White",
    ['135'] = "Hot Pink",
    ['136'] = "Salmon pink",
    ['137'] = "Metallic Vermillion Pink",
    ['138'] = "Orange",
    ['139'] = "Green",
    ['140'] = "Blue",
    ['141'] = "Mettalic Black Blue",
    ['142'] = "Metallic Black Purple",
    ['143'] = "Metallic Black Red",
    ['144'] = "hunter green",
    ['145'] = "Metallic Purple",
    ['146'] = "Metallic Dark Blue",
    ['147'] = "Black",
    ['148'] = "Matte Purple",
    ['149'] = "Matte Dark Purple",
    ['150'] = "Metallic Lava Red",
    ['151'] = "Matte Forest Green",
    ['152'] = "Matte Olive Drab",
    ['153'] = "Matte Desert Brown",
    ['154'] = "Matte Desert Tan",
    ['155'] = "Matte Foilage Green",
    ['156'] = "Default Alloy Color",
    ['157'] = "Epsilon Blue",
    ['158'] = "Pure Gold",
    ['159'] = "Brushed Gold",
    ['160'] = "MP100",
    ['161'] = "Anodized Red Pearl",
    ['162'] = "Anodized Wine Pearl",
    ['163'] = "Anodized Purple Pearl",
    ['164'] = "Anodized Blue Pearl",
    ['165'] = "Anodized Green Pearl",
    ['166'] = "Anodized Lime Pearl",
    ['167'] = "Anodized Copper Pearl",
    ['168'] = "Anodized Bronze Pearl",
    ['169'] = "Anodized Champagne Pearl",
    ['170'] = "Anodized Gold Pearl",
    ['171'] = "Green/Blue Flip",
    ['172'] = "Green/Red Flip",
    ['173'] = "Green/Brown Flip",
    ['174'] = "Green/Turquoise Flip",
    ['175'] = "Green/Purple Flip",
    ['176'] = "Teal/Purple Flip",
    ['177'] = "Turquoise/Red Flip",
    ['178'] = "Turquoise/Purple Flip",
    ['179'] = "Cyan/Purple Flip",
    ['180'] = "Blue/Pink Flip",
    ['181'] = "Blue/Green Flip",
    ['182'] = "Purple/Red Flip",
    ['183'] = "Purple/Green Flip",
    ['184'] = "Magenta/Green Flip",
    ['185'] = "Magenta/Yellow Flip",
    ['186'] = "Burgundy/Green Flip",
    ['187'] = "Magenta/Cyan Flip",
    ['188'] = "Copper/Purple Flip",
    ['189'] = "Magenta/Orange Flip",
    ['190'] = "Red/Orange Flip",
    ['191'] = "Orange/Purple Flip",
    ['192'] = "Orange/Blue Flip",
    ['193'] = "White/Purple Flip",
    ['194'] = "Red/Rainbow Flip",
    ['195'] = "Blue/Rainbow Flip",
    ['196'] = "Dark Green Pearl",
    ['197'] = "Dark Teal Pearl",
    ['198'] = "Dark Blue Pearl",
    ['199'] = "Dark Purple Pearl",
    ['200'] = "Oil Slick Pearl",
    ['201'] = "Light Green Pearl",
    ['202'] = "Light Blue Pearl",
    ['203'] = "Light Purple Pearl",
    ['204'] = "Light Pink Pearl",
    ['205'] = "Off White Pearl",
    ['206'] = "Cute Pink Pearl",
    ['207'] = "Baby Yellow Pearl",
    ['208'] = "Baby Green Pearl",
    ['209'] = "Baby Blue Pearl",
    ['210'] = "Cream Pearl",
    ['211'] = "White Prismatic Pearl",
    ['212'] = "Graphite Prismatic Pearl",
    ['213'] = "Blue Prismatic Pearl",
    ['214'] = "Purple Prismatic Pearl",
    ['215'] = "Hot Pink Prismatic Pearl",
    ['216'] = "Red Prismatic Pearl",
    ['217'] = "Green Prismatic Pearl",
    ['218'] = "Black Prismatic Pearl",
    ['219'] = "Oil Spill Prismatic Pearl",
    ['220'] = "Rainbow Prismatic Pearl",
    ['221'] = "Black Holographic Pearl",
    ['222'] = "White Holographic Pearl",
    ['223'] = "YKTA Monochrome",
    ['224'] = "YKTA Night & Day",
    ['225'] = "YKTA The Verlierer",
    ['226'] = "YKTA Sprunk Extreme",
    ['227'] = "YKTA Vice City",
    ['228'] = "YKTA Synthwave Night",
    ['229'] = "YKTA Four Seasons",
    ['230'] = "YKTA M9 Throwback",
    ['231'] = "YKTA Bubblegum",
    ['232'] = "YKTA Full Rainbow",
    ['233'] = "YKTA Sunset",
    ['234'] = "YKTA The Seven",
    ['235'] = "YKTA Kamen Rider",
    ['236'] = "YKTA Chromatic",
    ['237'] = "YKTA Christmas",
    ['238'] = "YKTA Temperature",
    ['239'] = "YKTA HSW Badge",
    ['240'] = "YKTA Electro",
    ['241'] = "YKTA Monika",
    ['242'] = "YKTA Fubuki",
}

local Classlist = {
    ["0"] = "Compacts",
    ["1"] = "Sedans",
    ["2"] = "SUVs",
    ["3"] = "Coupes",
    ["4"] = "Muscle",
    ["5"] = "Sport-Classic",
    ["6"] = "Sports",
    ["7"] = "Super",
    ["8"] = "Motorcycles",
    ["9"] = "Off-road",
    ["10"] = "Industrial",
    ["11"] = "Utility",
    ["12"] = "Vans",
    ["13"] = "Cycles",
    ["14"] = "Boats",
    ["15"] = "Helicopters",
    ["16"] = "Planes",
    ["17"] = "Service",
    ["18"] = "Emergency",
    ["19"] = "Military",
    ["20"] = "Commercial",
    ["21"] = "Trains",
}

local weaponTable = {
    [584646201]   = "CLASS 2: AP-Pistol",
    [453432689]   = "CLASS 1: Pistol",
    [3219281620]  = "CLASS 1: Pistol MK2",
    [1593441988]  = "CLASS 1: Combat Pistol",
    [-1716589765] = "CLASS 1: Heavy Pistol",
    [-1076751822] = "CLASS 1: SNS-Pistol",
    [-771403250]  = "CLASS 2: Desert Eagle",
    [137902532]   = "CLASS 2: Vintage Pistol",
    [-598887786]  = "CLASS 2: Marksman Pistol",
    [-1045183535] = "CLASS 2: Revolver",
    [911657153]   = "Taser",
    [324215364]   = "CLASS 2: Micro-SMG",
    [-619010992]  = "CLASS 2: Machine-Pistol",
    [736523883]   = "CLASS 2: SMG",
    [2024373456]  = "CLASS 2: SMG MK2",
    [-270015777]  = "CLASS 2: Assault SMG",
    [171789620]   = "CLASS 2: Combat PDW",
    [-1660422300] = "CLASS 4: Combat MG",
    [3686625920]  = "CLASS 4: Combat MG MK2",
    [1627465347]  = "CLASS 4: Gusenberg",
    [-1121678507] = "CLASS 2: Mini SMG",
    [-1074790547] = "CLASS 3: Assaultrifle",
    [961495388]   = "CLASS 3: Assaultrifle MK2",
    [-2084633992] = "CLASS 3: Carbinerifle",
    [4208062921]  = "CLASS 3: Carbinerifle MK2",
    [-1357824103] = "CLASS 3: Advancedrifle",
    [-1063057011] = "CLASS 3: Specialcarbine",
    [2132975508]  = "CLASS 3: Bulluprifle",
    [1649403952]  = "CLASS 3: Compactrifle",
    [100416529]   = "CLASS 4: Sniperrifle",
    [205991906]   = "CLASS 4: Heavy Sniper",
    [177293209]   = "CLASS 4: Heavy Sniper MK2",
    [-952879014]  = "CLASS 4: Marksmanrifle",
    [487013001]   = "CLASS 2: Pumpshotgun",
    [2017895192]  = "CLASS 2: Sawnoff Shotgun",
    [-1654528753] = "CLASS 3: Bullupshotgun",
    [-494615257]  = "CLASS 3: Assaultshotgun",
    [-1466123874] = "CLASS 3: Musket",
    [984333226]   = "CLASS 3: Heavyshotgun",
    [-275439685]  = "CLASS 2: Doublebarrel Shotgun",
    [317205821]   = "CLASS 2: Autoshotgun",
    [-1568386805] = "CLASS 5: GRENADE LAUNCHER",
    [-1312131151] = "CLASS 5: RPG",
    [125959754]   = "CLASS 5: Compactlauncher"
}

function utils.GetVehicleClassById(classId)
    return Classlist[tostring(classId)]
end

function utils.GetColor(color)
    return Colors[tostring(color)]
end

function utils.GetVehicleColor(vehicle)
    local vehicleColor1, vehicleColor2 = GetVehicleColours(vehicle)
    local color1 = Colors[tostring(vehicleColor1)]
    local color2 = Colors[tostring(vehicleColor2)]

    if color1 and color2 then return color2 .. " on " .. color1 end

    if color1 then return color1 end

    if color2 then return color2 end

    return "Unknown"
end

function utils.GetWeaponName()
    local currentWeapon = GetSelectedPedWeapon(cache.ped)
    return weaponTable[currentWeapon] or "Unknown"
end

return utils