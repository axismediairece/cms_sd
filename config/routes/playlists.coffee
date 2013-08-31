roles=require '../middleware/Roles'
path=require 'path'
fs=require 'fs'

module.exports=(app)->

	playlists=require '../../app/controllers/Playlists'

#### MÉTODOS POR CONSOLE
	app.get '/console/playlists',roles.action('console playlists list'),playlists.consoleList
	app.get '/console/playlists/:playlist',roles.LoadParams(['playlist']),roles.action('console playlist detail'),playlists.consoleDetail
	app.delete '/console/playlists/:playlists',roles.LoadParams(['playlist']),roles.action('console playlist remove'),playlists.consoleRemove