local hudAttivo = true
local dentroVeicolo = false

local function inviaMessaggio(azione, dati)
    SendNUIMessage({
        azione = azione,
        dati = dati or {}
    })
end

if GetCurrentResourceName() ~= 'zeta_hud' then
    print('^1[ERRORE] La risorsa deve chiamarsi "zeta_hud" per funzionare!^0')
    return
end

local function percentualeVita(ped)
    local vita = GetEntityHealth(ped)
    local vitaMassima = GetEntityMaxHealth(ped)
    local intervallo = vitaMassima - 100

    if IsEntityDead(ped) or intervallo <= 0 then
        return 0
    end

    return math.max(0, math.min(100, math.floor(((vita - 100) / intervallo) * 100 + 0.5)))
end

CreateThread(function()
    Wait(1000)

    inviaMessaggio('inizializza', {
        nomeServer = Config.NomeServer,
        logo = Config.Logo
    })

    while true do
        local ped = PlayerPedId()
        local pausa = IsPauseMenuActive()
        local idPlayer = GetPlayerServerId(PlayerId())
        local vita = percentualeVita(ped)
        local armatura = math.max(0, math.min(100, GetPedArmour(ped)))

        local inVeicolo = IsPedInAnyVehicle(ped, false)
        local velocita = 0

        if inVeicolo then
            local mezzo = GetVehiclePedIsIn(ped, false)

            if mezzo ~= 0 then
                velocita = math.floor(GetEntitySpeed(mezzo) * 3.6 + 0.5)
            end
        end

        if inVeicolo ~= dentroVeicolo then
            dentroVeicolo = inVeicolo

            inviaMessaggio('veicolo', {
                visibile = dentroVeicolo
            })
        end


        inviaMessaggio('aggiorna', {
            vita = vita,
            armatura = armatura,
            velocita = velocita,
            inVeicolo = inVeicolo,
            visibile = hudAttivo and not pausa,
            idPlayer = idPlayer
        })

        Wait(inVeicolo and Config.AggiornamentoVelocita or Config.AggiornamentoHUD)
    end
end)
Citizen.CreateThread(function()
    local minimap = RequestScaleformMovie("minimap")
    SetRadarBigmapEnabled(true, false)
    Wait(0)
    SetRadarBigmapEnabled(false, false)
    while true do
        Wait(0)
        BeginScaleformMovieMethod(minimap, "SETUP_HEALTH_ARMOUR")
        ScaleformMovieMethodAddParamInt(3)
        EndScaleformMovieMethod()
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(6)
        HideHudComponentThisFrame(7)
        HideHudComponentThisFrame(2)
        HideHudComponentThisFrame(1)
        HideHudComponentThisFrame(13)
        HideHudComponentThisFrame(21)
        HideHudComponentThisFrame(4)
        if IsPedInAnyVehicle(PlayerPedId(), false) then 
            DisplayRadar(true)
        else
            DisplayRadar(false)
        end
    end
end)