mongoose=require 'mongoose'
Empresa=mongoose.model 'empresas'
Utils=require '../Utils'
_=require('underscore')._


module.exports=
	#Escorpos relacionados aos dados da conta
	conta_perfil:
		name:'Perfil da Conta'
		desc:'Informações básicas do perfil'
		run:(req,res,conta,done)->
			result={}
			result=conta
			done null,result
      
      
      
	conta_empresas:
		name:'Empresas da Conta'
		desc:'Informações básicas sobre empresas'
		run:(req,res,conta,done)->
			result={}
			findParams={_conta:conta._id}
			console.log conta._id
			Empresa.count findParams,(err,counts)->
				result.length=counts
				done null,result
        
        
        
        
	ui_config:
		run:(req,res,conta,done)->
			done null,{}
      
      
      
      

	ui_nav:
		run:(req,res,conta,done)->
			done null,{}
      
      
      
      
	tokens:
		run:(req,res,conta,done)->
			done null,{}
  