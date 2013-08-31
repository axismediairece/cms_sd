module.exports=Self={}
mongoose=require 'mongoose'
Token=mongoose.model 'tokens'
Utils=require '../Utils'

#EXEMPLO 
TokenKeyQuery= '_token'
# http://google.com.br/?_token=[...]

Self.init=(req,res,next)->
	if _token=req._token then return next()
	token=Utils.GetParamList [req.body,req.params],'_token'
	appid=Utils.GetParamList [req.body,req.params],'_appid'
	paramsFind={}
	Token.find paramsFind,(err,data)->
		req._token=data
		next()

###
Self.CheckTokenReq=(req,res,done)->
	if _token=req._token
    
  for i in [req.body,req.params]
		if i&&(token=i[TokenKeyQuery])
	if token=Self.GetParamList [req.body.req.params],TokenKeyQuery
		if req._token
				done token,req._token
		else
			#Pesquisa o token no DB
			Token.findOne({token:token}).populate(['_owner','_to']).exec (err,data)->
				if err then return done err,null #!!!!!!!!!!!!!!!!!! TRATAR ESSA RESPOSTA DE ERRO
				req._token=data
				done token,data
	else done false,false
###