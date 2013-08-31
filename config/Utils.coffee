_=require('underscore')._


module.exports=Self={}
Self.GetParamList=(list,param)->
	if list&&(typeof list=='Array')
		for i in list
			if  i&&(val=list[param])&&val!=null||undefined then return val
	else
		return false

pickCheck=(obj,string)->
	if !obj||!string then return null
	res=obj
	for i in string.split "."
		if !(res=res[i]) then return null
	return res

Self.pick=(obj,prop)->
	if !obj||!prop then return null
	res=null
	for i in prop
		res=_.extend pickCheck(obj,i),res
	return res


#Filtrar objetos e retornar como Expressão Regular
Self.FilterToRegexp=(filters,data)->
	if !data then return {}
	result={}
	for key in filters
		if (dataVal=data[key])!=undefined
			result[key]={$regex:new RegExp(dataVal,'i')}
	return result
