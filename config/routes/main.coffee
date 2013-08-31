mongoose=require 'mongoose'
Conta=mongoose.model 'contas'

module.exports=(app)->
	app.get '/',(req,res)->
		res.render "index"

	app.get '/player_console',(req,res)->
		res.jsonp {max:'ok'}