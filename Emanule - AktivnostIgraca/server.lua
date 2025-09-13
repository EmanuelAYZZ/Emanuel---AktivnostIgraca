local podaciIgraca = {}

-- Sprema vrijeme igranja
RegisterNetEvent("aktivnost:updateVrijeme", function(vrijeme)
    local src = source
    podaciIgraca[src] = vrijeme
end)

-- Prijava igrača (spremanje u bazu)
RegisterNetEvent("aktivnost:posaljiPrijavu", function(igrac, razlog)
    local src = source
    local imePrijavio = GetPlayerName(src) or "Nepoznat"
    local imeIgrac = GetPlayerName(igrac) or ("ID:" .. tostring(igrac))

    print(("[PRIJAVA] %s (%d) je prijavio %s (%s) | Razlog: %s"):format(
        imePrijavio, src, imeIgrac, igrac, razlog
    ))

    -- Spremi u bazu
    MySQL.insert(
        'INSERT INTO prijave (igrac_id, igrac_ime, prijavio_id, prijavio_ime, razlog) VALUES (?, ?, ?, ?, ?)',
        { tostring(igrac), imeIgrac, tostring(src), imePrijavio, razlog }
    )

    -- Obavijesti admine u igri
    for _, id in ipairs(GetPlayers()) do
        if IsPlayerAceAllowed(id, "admin") then
            TriggerClientEvent("chat:addMessage", id, {
                color = {255, 0, 0},
                multiline = true,
                args = {"PRIJAVA", imePrijavio .. " je prijavio " .. imeIgrac .. " | Razlog: " .. razlog}
            })
        end
    end
end)

-- Kad igrač izađe
AddEventHandler("playerDropped", function()
    local src = source
    podaciIgraca[src] = nil
end)
