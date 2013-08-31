module.exports=Self={}
express=require 'express'
mongoose=require 'mongoose'
mongooseRedisCache= require 'mongoose-redis-cache'

env=process.argv[2]||process.env.NODE_ENV||'development' #Tipo de ambiente

Self.config=config=require('./config')[env] #Abrindo as configurações de acordo com o ambiente
Self.app=app=express()
mongoose.connect config.mongodb.uri
#mongooseRedisCache(mongoose,config.redis)


global.i18n=require('i18n') #modulo para tradução
i18n.configure config.i18n #Configurando módulo com os atributos do config.coffee-i18n



#Incluindo os modelos
for i in ['Contas','Empresas','Playlists','Displays','Tokens']
	require __dirname+'/../app/models/'+i


#Incluindo os arquivos de configuração
for i in ['mongoose','passport','express','route']
	require __dirname+'/'+i

port=process.env.PORT||process.env.NODE_PORT||config.port #Pegando a porta a ser utilizada

#Escutando a porta do servidor
app.listen port
console.log "Iniciado na porta: "+port