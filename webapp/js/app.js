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
    //Set starting parameters for the map
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

    //Load polygons
    var jsonRoot = 'webapp/json/'
    $scope.polygons = []

    $http.get(jsonRoot + 'community_districts.geojson').success(function(data) { 
        var id = 0;
        for (var i = 0; i < data.features.length; i++) {
            var item = data.features[i]
            if (item.geometry.type === 'Polygon') {
                var temppath = [];
                for (var j = 0; j < item.geometry.coordinates[0].length; j++){
                    var point = item.geometry.coordinates[0][j];
                    temppath.push( {latitude: point[1], longitude: point[0]} )
                }

                $scope.polygons.push( {
                    id: id,
                    path: temppath,
                    fill: {color: '#000000', opacity: 0.1},
                    stroke: {color: '#000000', weight: 2, opacity: 1},
                    cityid: item.properties.BoroCD
                    } )

                id++;
            }
            if (item.geometry.type === 'MultiPolygon') {
                for (var j = 0; j < item.geometry.coordinates.length; j++){
                    var poly = item.geometry.coordinates[j];
                    var temppath = [];
                    for (var k = 0; k < poly[0].length; k++){
                        point = poly[0][k];
                        temppath.push( {latitude: point[1], longitude: point[0]} )
                    }

                    $scope.polygons.push( {
                        id: id,
                        path: temppath,
                        fill: {color: '#000000', opacity: 0.1},
                        stroke: {color: '#000000', weight: 2, opacity: 1},
                        cityid: item.properties.BoroCD
                        } )

                    id++;
                }
            }
        }
    }); 


    $http.get(jsonRoot + 'list.json').success(function(data) { 
        $scope.list = data
    });     

    $scope.loadJson = function(url) {
        $http.get(jsonRoot + url).success(function(data) {
              //$scope.polygons = data
              //$scope.currentTitle = data.title
        });
        //$scope.control.refresh({ latitude: 40.7127, longitude: -74.0059 })
    }
}]);
