"use strict"
angular.module('mapApp', ['uiGmapgoogle-maps']);

angular.module('mapApp').config(function(uiGmapGoogleMapApiProvider) {
    uiGmapGoogleMapApiProvider.configure({
        key: 'AIzaSyCx0XlJA1D6xCY324p4WrBdx4i27smZlms',
        v: '3.17',
        libraries: 'weather,geometry,visualization'
    });
})

angular.module('mapApp').controller('mainCtrl', ['$scope','$http', function($scope, $http) {
    $scope.map = {
        center: { latitude: 40.7127, longitude: -74.0059 },
        zoom: 11,
        bounds: {},
        options: {
            minZoom: 11,
            streetViewControl: false,
            zoomControl: false,
            panControl: false
        },
    };
    $scope.control = {}

    var jsonRoot = 'webapp/json/'
    $scope.polygons = []

    $http.get(jsonRoot + 'list.json').success(function(data) { 
        $scope.list = data
    });     

    $scope.loadJson = function(url) {
        $http.get(jsonRoot + url).success(function(data) {
              $scope.polygons = data
              $scope.currentTitle = data.title
        });
        //$scope.control.refresh({ latitude: 40.7127, longitude: -74.0059 })
    }
}]);
