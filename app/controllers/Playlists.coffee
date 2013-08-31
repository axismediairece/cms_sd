mongoose=require 'mongoose'
Playlist=mongoose.model 'playlists'
_=require('underscore')._
Utils=require '../../config/Utils'
module.exports=Self={}


Self.consoleList=(req,res)->
	settings=_.extend
		$porPag:10
		$pag:1
	,req.query
	settings.$pag=if settings.$pag>0 then settings.$pag-1 or 0
	Playlist
	.find(Utils.FilterToRegexp ['nome','descricao'],req.query )
	.where('_conta',req.user._id)
	.limit(settings.$porPag)
	.select('_id modulos status')
	.skip(settings.$porPag*settings.$pag)
	.sort({'data.criacao':-1,name:'asc'})
	.exec (err,data)->
		res.jsonp data


      
Self.consoleRemove=(req,res)->
	if !(emp=req.$params.empresa) then return res.json {status:0}
	emp.remove (err)-> res.json {status:1}

    
Self.consoleDetail=(req,res)->
	res.jsonp req.$params.empresa