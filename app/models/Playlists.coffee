mongoose=require 'mongoose'
Schema=mongoose.Schema

ModuloSchema=new Schema
	_modulo:{type:String,ref:'sys_modulos'}
	opcoes:{}
	duracao:Number
	limites:Number


PlaylistSchema=new Schema
	_conta:{type:Schema.ObjectId,ref:'contas'}
	nome:String
	modulos:[ModuloSchema]
	status:Number


mongoose.model 'playlists',PlaylistSchema