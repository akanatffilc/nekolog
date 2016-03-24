'use strict';

angular.module('nekolog').controller('MainCtrl', ['$scope', '$http', function ($scope, $http) {

    var $uri ='/api/v2/projects';

    $scope.doSearch = function() {

        $http({
            method : 'GET',
            url : $uri
        }).success(function(data, status, headers, config) {
            $scope.results = data.data;
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
    };

}]);