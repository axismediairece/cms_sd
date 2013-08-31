mongoose=require 'mongoose'
Schema=mongoose.Schema


DisplaySchema=Schema
	nome:String
	auth:
		mac:''
		token:''
	status:Number
	data:
		criacao:{type:Date,default:Date.now}
		ultimologin:Date
		atualizado:Date
		expirar:Date
		remocao:Date

mongoose.model 'displays',DisplaySchema