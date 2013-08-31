module.exports=Self={}
mongoose=require 'mongoose'
crypto=require 'crypto'
_=require('underscore')._
Display=mongoose.model 'displays'

Roles=require './Roles'


#Autenticando Display - PART 1

Self.PlayerAuth=(req,res,next)->
	params=_.pick req.body,['mac','token']
	Display.findOne params,(err,data)->
		if err then return res.status(502).jsonp err #Caso tenha ocorrido algum erro na consulta
		if !data then return res.jsonp {erro:''} #Caso não tenha encontrado nenhum resultado
		Self.PlayerAuthProcess req,res,data,(err)->
			if err then return res.status(502).jsonp err
			next()
			


#	crypto.randomBytes 32,(ex,buf) -> res.jsonp {token:buf.toString('hex')}


#Autenticando Display - PART 2
Self.PlayerAuthProcess=(req,res,data,done)->
	if !req.user then req.user={}
	res.locals.display=data
	req.user.funcao= '_display'
	done null


#
Self.PlayerRoleCheck=(done)->
	return (req,res,next)->
		next null,done


Roles.use 'player storage',Self.PlayerRoleCheck
