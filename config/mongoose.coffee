Server=require './init'
mongoose=require 'mongoose'
db=Server.db
conn=mongoose.connection

conn.on 'connecting',()->
	console.log i18n.__('db_conectar_criar')

conn.on 'connect',()->
	console.log i18n.__('db_conectar_sucesso')

conn.on 'error',()->
	console.log "Erro"
	console.log i18n.__('db_conectar_erro')
