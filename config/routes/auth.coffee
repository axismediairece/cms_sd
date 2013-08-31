mongoose=require 'mongoose'
roles=require '../middleware/Roles'
passport=require 'passport'
Autenticar=require '../middleware/Autenticar'


Display=mongoose.model 'displays'

module.exports=(app)->
	contas=require '../../app/controllers/Contas'

	app.get '/login',contas.login
	app.get '/signup',contas.signup
	app.get '/logout',contas.logout
	app.get '/auth/facebook',passport.authenticate('facebook',{scope:['user_status','user_checkins'],failureRedirect:'/login'}),contas.signin
	app.get '/auth/facebook/callback',passport.authenticate('facebook',{failureRedirect:'/login'}),contas.authCallback
	app.get '/auth/twitter',passport.authenticate('twitter',{failureRedirect:'/login'}),contas.signin
	app.get '/auth/twitter/callback',passport.authenticate('twitter',{failureRedirect: '/login' }),contas.authCallback

	app.get '/dashboard',roles.checkAccess(['registred']),contas.dashboard

	app.get '/console/scopes',roles.checkAccess(['registred']),roles.GetScope


	app.post '/player_console/auth',Autenticar.PlayerAuth
	app.get '/console/logout',contas.consoleLogout