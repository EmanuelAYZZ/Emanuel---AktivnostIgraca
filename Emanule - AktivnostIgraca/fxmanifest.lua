fx_version 'cerulean'
game 'gta5'

description 'Sustav aktivnosti i prijava igrača (ESX/QB)'
author 'Emanuel'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/skripta.js',
    'html/stil.css'
}

shared_scripts {
    '@es_extended/imports.lua', -- ESX
    '@qb-core/shared.lua'       -- QB
}

client_script 'client.lua'
server_script 'server.lua'

