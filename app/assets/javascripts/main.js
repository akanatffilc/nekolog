'use strict';

var app = angular.module('nekolog' , []);

//Projects
app.controller('MainCtrl', ['$scope', '$http', function ($scope, $http) {

    var $uri ='/projects';

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

//Issue
app.controller('IssueCtrl', ['$scope', '$http', function ($scope, $http) {
    var $uri ='/issues';
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
