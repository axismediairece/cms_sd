Server=require './init'
express=require 'express'
passport=require 'passport'
mongoSession=require('connect-mongo') express
passport=require 'passport'
flash=require 'connect-flash'
_=require('underscore')._


app=Server.app
config=Server.config


#Configurando o express.app
app.configure 'development',()->

	app.use express.compress()
	app.use express.static config.express.public,{maxAge:86400000} #maxAge: um dia
	app.set 'views',config.express.views #Definindo a pasta dos template
	app.set 'view engine','jade' #Definindo o engine "Jade"

	app.use express.cookieParser(config.express.secret)
	app.use express.methodOverride()
	app.use express.bodyParser()
	app.use express.session 
		secret:config.express.secret
		store: new mongoSession
			db:require('mongoose').connection.db
		cookie:
		    maxAge: 86400000
	app.use require('i18n').init #Inicializando configurações de Tradução
	app.use passport.initialize()
	app.use passport.session()
	app.use flash()
	app.use app.router
	app.use (req,res,next)->
		req.errorRes=(opcoes)->
			opts=_.extend {status:404,msg:'A resposta para a requisição não existe'},opcoes
			res.status(opts).jsonp {stat:0,msg:opts.msg}
		next()