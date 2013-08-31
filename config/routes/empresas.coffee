roles=require '../middleware/Roles'
path=require 'path'
fs=require 'fs'


module.exports=(app)->

	empresas=require '../../app/controllers/Empresas'

#### MÉTODOS POR CONSOLE
	app.get '/console/empresas',roles.action('console empresas list'),empresas.consoleList
	app.get '/console/empresas/:empresa',roles.LoadParams(['empresa']),roles.action('console empresa detail'),empresas.consoleDetail
	app.delete '/console/empresas/:empresa',roles.LoadParams(['empresa']),roles.action('console empresa remove'),empresas.consoleRemove