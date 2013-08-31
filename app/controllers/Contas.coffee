module.exports=Self={}
mongoose=require 'mongoose'
Conta=mongoose.model 'contas'
Empresas=mongoose.model 'empresas'
Utils=require '../../config/Utils'








createConta=(data,next)->
	if !data then return false
	#Aqui pode enviar um e-mail de ativação
	data.provedor= 'local'
	_conta=new Conta data
	_conta.save next

Self.authCallback=(req,res) -> res.redirect '/' 

#Fazendo o login
Self.login=(req,res) -> res.render "contas/login"

#Quando logar
Self.signin=(req,res) -> res.render "user"

#Cadastrar
Self.signup=(req,res) -> res.render "contas/signup",{conta:new Conta()}

#Sair da sessão
Self.logout=(req,res) ->
	req.logout()
	res.redirect '/login'

#Criando uma conta
Self.create=(req,res) -> createConta req.body,(err,conta)->
	if err then return res.render "contas/singup",{errors:err.errors,conta:conta}
	return res.redirect '/'

Self.show=(req,res) -> res.render "contas/perfil",{user:req.profile}

Self.user=(req,res,next,id)->
	Conta.findOne {_id:id},(err,conta)->
		if err then return next err
		if !conta then return next new Error i18n.__ 'erro_carregar_conta',id
		req.profile=res.locals.user=conta
		next()


Self.dashboard=(req,res) -> res.render "admin/page-app"


#### MÉTODOS POR CONSOLE | http://[host]:[port]/console/***

Self.consoleScope=(req,res)->
	req.logout()

Self.consoleLogout=(req,res)->
	req.logout()
	res.jsonp {status:1}