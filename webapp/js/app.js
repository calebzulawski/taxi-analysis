"use strict"

function getColor(value){
    var h = (1-value*.66 - .33)/2;
    var s = 1;
    var l = .5;
    var r, g, b;

    if (s == 0) {
        r = g = b = l; // achromatic
    } else {
        var hue2rgb = function hue2rgb(p, q, t){
            if(t < 0) t += 1;
            if(t > 1) t -= 1;
            if(t < 1/6) return p + (q - p) * 6 * t;
            if(t < 1/2) return q;
            if(t < 2/3) return p + (q - p) * (2/3 - t) * 6;
            return p;
        }

        var q = l < 0.5 ? l * (1 + s) : l + s - l * s;
        var p = 2 * l - q;
        r = hue2rgb(p, q, h + 1/3);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1/3);
    }

    r = Math.round(r * 255).toString(16);
    g = Math.round(g * 255).toString(16);
    b = Math.round(b * 255).toString(16);

    if (r.length == 1) {
        r = '0' + r;
    }
    if (g.length == 1) {
        g = '0' + g;
    }
    if (b.length == 1) {
        b = '0' + b;
    }
    return '#'+r+g+b;
}

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
    $scope.squares = []

    $http.get(jsonRoot + 'squaresByDistrict.json').success(function(data) {
        $scope.allSquares = data.districts;
    });

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
                    fill: {color: '#000000', opacity: 0.5},
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
                        fill: {color: '#000000', opacity: 0.5},
                        stroke: {color: '#000000', weight: 2, opacity: 1},
                        cityid: item.properties.BoroCD
                        } )

                    id++;
                }
            }
        }
    });

    var regionEvents = {
        click: function(poly,eventName,model,args) {
            var id;
            var bounds = {
                northeast: {
                    latitude: -9999,
                    longitude: -9999
                },
                southwest: {
                    latitude: 9999,
                    longitude: 9999,
                }
            }

            for (var i = 0; i < $scope.polygons.length; i++) {
                if ($scope.polygons[i].id == model.$parent.$index) {
                    id = $scope.polygons[i].cityid;
                }
                $scope.polygons[i].fill = {color: $scope.polygons[i].fill.color, opacity: .5};
            }
            for (var i = 0; i < $scope.polygons.length; i++) {
                if ($scope.polygons[i].cityid == id) {
                    $scope.polygons[i].fill = {color: $scope.polygons[i].fill.color, opacity: 0};
                    for (var j = 0; j < $scope.polygons[i].path.length; j++) {
                        if ($scope.polygons[i].path[j].longitude > bounds.northeast.longitude) {
                            bounds.northeast.longitude = $scope.polygons[i].path[j].longitude;
                        }
                        if ($scope.polygons[i].path[j].latitude > bounds.northeast.latitude) {
                            bounds.northeast.latitude = $scope.polygons[i].path[j].latitude;
                        }
                        if ($scope.polygons[i].path[j].longitude < bounds.southwest.longitude) {
                            bounds.southwest.longitude = $scope.polygons[i].path[j].longitude;
                        }
                        if ($scope.polygons[i].path[j].latitude < bounds.southwest.latitude) {
                            bounds.southwest.latitude = $scope.polygons[i].path[j].latitude;
                        }
                    }
                }
            }

            $scope.squares = $scope.allSquares[id].squares

            $scope.map.bounds = bounds;
        }
    }

    $scope.events = regionEvents;

    $scope.loadJson = function(url) {
        $http.get(jsonRoot + '/data/' + url + '/neighborhood.json').success(function(data) {
            var min = 999999999;
            var max = -999999999;
            for (var i = 0; i < data.data.length; i++) {
                data.data[i] = {neighborhood: parseFloat(data.data[i].neighborhood,10), value: parseFloat(data.data[i].value,10)}
                if (data.data[i].value < min) {
                    min = data.data[i].value;
                }
                if (data.data[i].value > max) {
                    max = data.data[i].value;
                }
            }

            for (var i = 0; i < data.data.length; i++) {
                for (var j = 0; j < $scope.polygons.length; j++) {
                    if (data.data[i].neighborhood == $scope.polygons[j].cityid) {
                        $scope.polygons[j].fill = {color: getColor(Math.log2((data.data[i].value - min)/(max-min)+1)), opacity: 0.5};
                    }
                }
            }
        });

        $http.get(jsonRoot + '/data/' + url + '/square.json').success(function(data) {
            var squareData = {};
            var neighborhood;
            var square;
            var value;
            for (var i = 0; i < data.data.length; i++) {
                neighborhood = data.data[i].neighborhood
                square = data.data[i].square
                value = data.data[i].value
                data.data[i] = {
                    neighborhood: parseFloat(neighborhood,10),
                    square: parseFloat(square,10),
                    value: parseFloat(value,10)
                };
                if (typeof squareData[data.data[i].neighborhood] === 'undefined') {
                    squareData[data.data[i].neighborhood] = { min: data.data[i].value, max: data.data[i].value}
                } else {
                    if (data.data[i].value < squareData[data.data[i].neighborhood].min) {
                        squareData[data.data[i].neighborhood].min = data.data[i].value;
                    }
                    if (data.data[i].value > squareData[data.data[i].neighborhood].max) {
                        squareData[data.data[i].neighborhood].max = data.data[i].value;
                    }
                }
            }
            var min = 999999999;
            var max = -999999999;
            for (var i = 0; i < data.data.length; i++) {
                for (var j = 0; j < $scope.allSquares[data.data[i].neighborhood].squares.length; j++) {
                    if (data.data[i].square == $scope.allSquares[data.data[i].neighborhood].squares[j].id) {
                        var setColorValue = Math.log2((data.data[i].value - squareData[data.data[i].neighborhood].min)/(squareData[data.data[i].neighborhood].max-squareData[data.data[i].neighborhood].min)+1);
                        $scope.allSquares[data.data[i].neighborhood].squares[j].fill = {color: getColor(setColorValue), opacity: 0.5};
                        $scope.allSquares[data.data[i].neighborhood].squares[j].stroke = {color: '#000000', weight: 0, opacity: 1};
                    }
                }
            }
            console.log('Done')
        });
    }

    $http.get(jsonRoot + 'list.json').success(function(data) {
        $scope.list = data
        console.log(data.default)
        //$scope.loadJson(data.default)
    });
}]);
