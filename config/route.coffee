Server=require './init'
app=Server.app
Tokens=require './middleware/Tokens'

#Pre carregando o token, caso exista
app.use Tokens.init

#Incluindo os arquivos "routes/**"
for i in ['main','auth','admin','empresas','playlists']
	require(__dirname+'/routes/'+i) app