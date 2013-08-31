mongoose=require 'mongoose'
Schema=mongoose.Schema

EmpresaSchema=new Schema
	_conta:{type:Schema.ObjectId,ref:'contas'}
	nome:String
	tags:[]
	data:
		criacao:{type:Date,default:Date.now}
		atualizado:Date
		expirar:Date
	status:{type:Number,default:1}

mongoose.model 'empresas',EmpresaSchema