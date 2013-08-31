mongoose=require 'mongoose'
Schema=mongoose.Schema
crypto=require 'crypto'
_=require('underscore')._
authTypes=['github','twitter','facebook','google']

ContaSchema=new Schema
	nome:String
	email:String
	provider:String
	hashed_password:String
	salt:String
	facebook:{}
	twitter:{}
	github:{}
	google:{}
	funcao:[String]
	#funcao:{type:String,ref:'acc_funcoes'}
	plano:{type:String,ref:'acc_planos'}
	app_key:String
	app_secret:String



ContaSchema
.virtual('password')
.set (password)->
	this._password=password
	this.salt=this.makeSalt()
	this.hashed_password=this.encryptPassword password
.get ()-> return this._password


validatePresenceOf=(value) -> return value&&value.length
checkProvider=(provider) -> return if provider&&authTypes.indexOf(provider)!=-1 then 1 else 0

#Validar se os campos não estiverem vazios
for i in ['nome','email','hashed_password']
	ContaSchema.path(i).validate (campo)->
		if checkProvider(this.provider) then return true
		return campo.length
	,i18n.__('campo_'+i+'_vazio')


ContaSchema.pre 'save',(next)->
	if !this.isNew
		return next()
	if !validatePresenceOf(this.password)&&!checkProvider(this.provider)
		return next new Error i18n.__('senha_invalida')
	else
		next()

ContaSchema.methods=
	authenticate:(plainText)->
		return this.encryptPassword(plainText)==this.hashed_password

	makeSalt:()->
		return Math.round(new Date().valueOf()*Math.random())+''

	encryptPassword:(password)->
		if !password
			return ''
		return crypto.createHmac('sha1',this.salt).update(password).digest('hex')

      
   
mongoose.model 'contas',ContaSchema