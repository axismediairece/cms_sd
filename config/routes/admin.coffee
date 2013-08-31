roles=require '../middleware/Roles'
path=require 'path'
fs=require 'fs'

roles.use 'user dashboard'

module.exports=(app)->

	empresas=require '../../app/controllers/Empresas'

	app.get '/admin/console/empresas',roles.action('user dashboard'),empresas.consoleList
	app.post '/admin/console/empresas',roles.action('dashboard empresas add'),empresas.consoleAdd
	app.delete '/admin/console/empresas/:empresa',roles.checkAccess(['registred']),roles.LoadParams(['empresa']),empresas.consoleRemove

	app.get '/console/scopes',roles.checkAccess(['registred']),roles.GetScope

	tmpls=[
		'empresas-adicionar'
		'empresas-lista'
	]
	#Templates usados no angular-js
	for i in tmpls
		app.get '/admin/tmplViews/'+i,roles.checkAccess(['registred']),(req,res)-> res.render "admin/tmplViews/"+i
			
	#app.get '/admin/tmplViews/:tmplView',roles.checkAcess(['registred']),(req,res)->
