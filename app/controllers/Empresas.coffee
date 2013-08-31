mongoose=require 'mongoose'
Empresa=mongoose.model 'empresas'
_=require('underscore')._
module.exports=Self={}



EmpFilter=(filters,data)->
	if !data then return {}
	result={}
	for key in filters
		if (dataVal=data[key])!=undefined
			result[key]={$regex:new RegExp(dataVal,'i')}
	return result

Self.consoleList=(req,res)->
	settings=_.extend
		$porPag:10
		$pag:1
	,req.query
	settings.$pag=if settings.$pag>0 then settings.$pag-1 or 0
	Empresa
	.find(EmpFilter ['nome','descricao'],req.query)
	.where('_conta',req.user._id)
	.limit(settings.$porPag)
	.select('_id nome tags status')
	.skip(settings.$porPag*settings.$pag)
	.sort({'data.criacao':-1,name:'asc'})
	.exec (err,data)->
		Empresa.count().exec (err,count)->
			res.set
				td:
					JSON.stringify
						pag:settings.$pag+1
						porPag:settings.$porPag
						total:count
			res.jsonp data

      
Self.consoleRemove=(req,res)->
	if !(emp=req.$params.empresa) then return res.json {status:0}
	emp.remove (err)->
		res.json {status:1}

    
Self.consoleDetail=(req,res)->
	res.jsonp req.$params.empresa

###
	#console.log req.query
	reqData=req.query

	perPage=req.param '$limitPage'
	page=parseInt(req.param('$page'))-1
	skip=perPage*page
	filter=EmpFilter ['nome','descricao'],req.query
	Empresa
	.where('_conta',req.user._id)
	.limit(perPage)
	.skip(skip)
	.find(filter)
	.sort({'data.criacao':-1})
	.exec (err,data)->
		if err then return res.status(403).jsonp err
		res.jsonp data
###


Self.consoleAdd=(req,res)->
	new_=new Empresa req.body
	new_._conta=req.user._id
	new_.save (err,data)->
		if err then return res.status(403).jsonp err
		res.jsonp data