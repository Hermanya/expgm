	
app.factory('metaService', ['$http', function($http) {

    var getData = function() {
      return $http({
        method: 'JSONP',
        url: "services/levels.json"
      });
    }
    return {
      getData: function() { return getData(); },
    };
  }]);
