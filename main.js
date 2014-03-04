var app = angular.module("app",[]);


app.controller("mainController",["$scope","metaService",
	function($scope,metaService){
    $scope.levels=[];
	$scope.select = function(){
                
				metaService.getData()
				.success(function(data, status) { 
                  $scope.levels=JSON.parse(data);
			  }).error(function(data, status) {
			    // Some error occurred
			//   alert(status);
			  });
				
	}();
 }]);



