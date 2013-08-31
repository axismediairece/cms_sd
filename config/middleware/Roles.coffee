module.exports=Self={}
_=require('underscore')._

mongoose=require 'mongoose'
Empresa=mongoose.model 'empresas'
Token=mongoose.model 'tokens'
TokenMdwre=require './Tokens'
Utils=require '../Utils'



Self.checkAccess=(rules,action)->
	return (req,res,next)->
		res.locals.user=req.user
		next()





############################################################################################
#ALOGARÍTIMO PARA PARÂMETROS app.get 'page/:parametro',LoadParams(['parametro'])


LoadParam=
	empresa:(id,done)-> Empresa.findOne {_id:id},done


Self.LoadParams=(params,options)->
	return (req,res,next)->
		if !params then return res.status(403).jsonp err
		loadeds=0
		if !req.$params then req.$params=[]
		for i in params
			if LoadParam[i]&&key=req.params[i]
				LoadParam[i] key,(err,data)->
					if err then return res.status(403).jsonp err
					#Passando o valor do parâmetro para o req.$param
					req.$params[i]=data
					res.locals[i]=data
					loadeds++
					params.length==loadeds&&next()

#########################################################################


#DEFININDO OS ESCORPOS
Self.Scopes=require './Scopes'


#
#Verificar se
Self.checkHasProperty=(refs,param)->
	for r in refs
		if (val=r[param])
      return val
	  else false

############# ALOGARÍTIMOS PARA GERAR ESCORPO ####################

#Verifica disponibilidade do escorpo
CompareAndGetScopes=(req,res,scope,done)->
	if !scope||!scope.req||typeof scope.req!='Array'||!scope.all||typeof scope.all!='Array'||!scope.conta
		loadeds=0
		totals=scope.req.length
		errors=[]
		scopesLoaded={}
		#Esta função é executada quando um escorpo conclui -- Aqui que finaliza a função
		callLoaded=()->
			loadeds++
			if loadeds>=totals
				req.$scope=scopesLoaded
				done (if errors.length then errors else null),scopesLoaded
		for c in scope.req
			f=(i)->
				if (_s=scope.all[i])&&_s.run
					_s.run req,res,scope.conta,(err,data)->
						if err then errors.push(err)
						scopesLoaded[i]=data
						callLoaded()
				else
						callLoaded()
			f(c)
	else done new Error()



Self.GetScope=(req,res,next)->
	if token=req._token
		conta=token._owner
		scopes=data.scopes
	else if req.user
		conta=req.user
		scopes=Self.Scopes
	else
    return res.jsonp {err:'Errou'}
	#Escorpos requisitados
	scopesReq=Self.checkHasProperty([req.body,req.query],'_scope')||''
	scopesReq=if scopesReq then scopesReq.split(",") else scopesReq
	CompareAndGetScopes req,res,{req:scopesReq,all:scopes,conta:conta},(err,scopesRes)->
		if err then return res.jsonp err else res.jsonp scopesRes





# http://google.com.br/?_scope=[...],



#################################################################
#	Quando o escorpo não está definido o sistema cria
#	automaticamente sendo manipulada na administração de Regras
#################################################################


###################################
#-------------REGRAS---------------
#	MODERADOR
# 
#	acao cadastrar contas
#	acao editar contas
#	acao remover contas
#	acesso dashboard
#	acesso eventos
#	acesso playlists
#	acesso relatorios
#	acesso lista contas
###################################

Self.Funcoes=
	_player:[
		'player displays'
		'player playlists'
		'player storage'
	],
	registrado:[
		'user dashboard'
		'console empresas list'
		'player displays'
		'player playlists'
		'player storage'
	],
	admin:[
		'cadastrar contas'
		'editar contas'
		'remover contas'
		'acessar dashboard'
		'acessar eventos'
		'acessar playlists'
		'acessar relatorios'
		'acessar lista contas'

		'acessar clientes venda'
	],
	vendendor:[
		'acesso clientes venda'
	]


Self.Acoes=
	add_funcao:{errorMsg:'Você não pode adicionar uma função'}




#Esta função verifica se usuário tem permissão
Self.UserHasPermission=(acao,user,done)->
	if !(funcao=Self.Funcoes[user.funcao]) then return done i18n.__('Sua função está ultrapassada'),null
	if (_acao=funcao.indexOf(acao))!=-1
		done null,Self.Acoes[_acao]
	else
		done i18n.__ 'Você não possui esta permissão'

    
    
################################################
#A Função com todos os previlégios é 'superadmin'
################################################


ResError=(opts)-> return _.extend {status:0,msg:'Erro Indefinido'},opts


# Função para registrar 'As funções das contas'
Self.use=(acao,callback,errorMsg)->
	Self.Acoes[acao]={callback:callback,errorMsg:errorMsg}


Self.action=(acao)->
	#Caso a ação ainda não foi cadastrada ele cadastra
	if !(acao in Self.Acoes) then Self.Acoes[acao]={}
	return (req,res,next)->
		User=(if req._token then req._token._owner)||req.user
		if !User then return res.status(409).jsonp ResError {msg:i18n.__('Voçe não tem permissão')}
		if !User then return res.status(502).json {err:'Precisa Logar'}
		#Caso seja o 'superadmin' o acesso é permitido
		if req.user.funcao.indexOf('superadmin')!=-1 then return next()
		#Caso a ação não exista
		if !acao||!_acao=Self.Acoes[acao] then return res.status(409).jsonp ResError {msg:i18n.__('A ação não existe')}
		#Verificando se conta tem permissão
		Self.UserHasPermission acao,req.user,(err,_acao)->
			if err then return res.status(409).jsonp ResError {msg:err} else next()
			_acao.callback&&_acao.callback req,res,(err2)-> 
				if err2 then res.status(409).jsonp ResError {msg:err2} else next()


#Registrando Acao | Ela é chamada pela função 'Self.action'
#A conta já teve permissão para executar
#	Self.use 'add_usuario',(req,res,done)->
#		done()
