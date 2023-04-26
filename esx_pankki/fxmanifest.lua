fx_version 'cerulean'
game {'gta5'}

client_script('c/*')
server_script "@oxmysql/lib/MySQL.lua"
server_script 's/sv_bank.lua'
ui_page('c/html/UI.html') 

files {
    'c/html/UI.html',
    'c/html/style.css',
	'c/html/img/phone.png'
}