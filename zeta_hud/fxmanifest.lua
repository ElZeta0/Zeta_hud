fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'Zeta'
description 'HUD personalizzato By Zeta'
version '1.0.0'

shared_script 'config.lua'
client_script 'client.lua'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/logo.png'
}
dependency "zeta_hud"