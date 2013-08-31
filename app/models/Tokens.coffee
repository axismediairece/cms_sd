mongoose=require 'mongoose'
Schema=mongoose.Schema

TokenSchema=new Schema
	token:{type:String,required:true,index:{unique:true}}
	_appId:{type:Schema.ObjectId,ref:'contas',required:true}
	_owner:{type:Schema.ObjectId,ref:'contas',required:true}
	scopes:[String]
	actions:[String]
	,{_id:false}

mongoose.model 'tokens',TokenSchema