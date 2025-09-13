local ESX, QBCore = nil, nil
Config = Config or {}
Config.Framework = "ESX" -- ili "QB"

-- Učitavanje frameworka
if Config.Framework == "ESX" then
    ESX = exports["es_extended"]:getSharedObject()
elseif Config.Framework == "QB" then
    QBCore = exports["qb-core"]:GetCoreObject()
end

-- Praćenje vremena igre
local vrijemeIgre = 0
CreateThread(function()
    while true do
        Wait(60000) -- svaka minuta
        vrijemeIgre = vrijemeIgre + 1
        TriggerServerEvent("aktivnost:updateVrijeme", vrijemeIgre)
    end
end)

-- Otvaranje UI-a
RegisterCommand("aktivnost", function()
    SetNuiFocus(true, true)
    SendNUIMessage({ akcija = "otvori" })
end)

-- Slanje prijave
RegisterNUICallback("posaljiPrijavu", function(podaci, cb)
    TriggerServerEvent("aktivnost:posaljiPrijavu", podaci.igrac, podaci.razlog)
    cb("ok")
end)

-- Zatvaranje UI-a
RegisterNUICallback("zatvori", function(_, cb)
    SetNuiFocus(false, false)
    cb("ok")
end)


RegisterCommand("prijave", function(src)
    if src == 0 then
        print("Ova komanda je samo za Admine.")
        return
    end
    if not IsPlayerAceAllowed(src, "admin") then
        TriggerClientEvent("chat:addMessage", src, {
            color = {255,255,0},
            args = {"SUSTAV", "Nemaš dozvolu za ovu komandu!"}
        })
        return
    end

    MySQL.query('SELECT * FROM prijave ORDER BY vrijeme DESC LIMIT 10', {}, function(rez)
        if #rez == 0 then
            TriggerClientEvent("chat:addMessage", src, {
                color = {200,200,200},
                args = {"PRIJAVE", "Nema prijava u bazi."}
            })
            return
        end

        for _, v in ipairs(rez) do
            TriggerClientEvent("chat:addMessage", src, {
                color = {255, 100, 100},
                args = {
                    "PRIJAVA",
                    ("[%s] %s (ID %s) je prijavio %s (ID %s) | Razlog: %s"):format(
                        v.vrijeme, v.prijavio_ime, v.prijavio_id, v.igrac_ime, v.igrac_id, v.razlog
                    )
                }
            })
        end
    end)
end)
