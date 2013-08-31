angular.module('signplay',[])
.controller('FormAuth',function($scope){
	$scope.formAuth={
		email:'designer_max@hotmail.com',
		senha:''
	}

	$scope.FormAuthSubmit=function(){
		alert("FOi")
	}
});