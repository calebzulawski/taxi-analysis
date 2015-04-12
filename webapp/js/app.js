"use strict"
angular.module('mapApp', ['uiGmapgoogle-maps']);

angular.module('mapApp').config(function(uiGmapGoogleMapApiProvider) {
    uiGmapGoogleMapApiProvider.configure({
        key: 'AIzaSyCx0XlJA1D6xCY324p4WrBdx4i27smZlms',
        v: '3.17',
        libraries: 'weather,geometry,visualization'
    });
})

angular.module('mapApp').controller('mainCtrl', ['$scope', function($scope) {
	$scope.map = { center: { latitude: 40.7127, longitude: -74.0059 }, zoom: 11 };
    $scope.options = {
        minZoom: 11,
        streetViewControl: false,
        zoomControl: false,
        panControl: false
    }
}]);


angular.module('mapApp').controller('sideCtrl', ['$scope','$http', function($scope, $http) {
    var jsonRoot = 'webapp/json/'
    $http.get(jsonRoot + 'json').success(function(data) { 
        $scope.list = data
    }); 

    $scope.loadJson = function(url) {
        alert(jsonRoot + url)
    }
}]);