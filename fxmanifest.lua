fx_version 'cerulean'
game 'gta5'

author 'Zhora'
description 'Announcement System for ESX'
version '1.2.0' 


shared_script 'config.lua'

server_scripts {
    '@es_extended/locale.lua',
    'server/server.lua'
}

client_scripts {
    'client/client.lua'
}

ui_page 'html/ui.html'

files {
    'html/ui.html',
    'html/style.css',
    'html/script.js',
    'html/sounds/*.ogg',
    'html/sounds/*.mp3',
}

dependencies {
    'es_extended'
}


