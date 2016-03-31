'use strict';

var app = angular.module('nekolog' , ['ngCookies']);

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
app.controller('IssueCtrl', ['$scope', '$http', '$cookies', function ($scope, $http, $cookies) {
    var $uri ='/issues';
    $scope.projects = [
        {id: "", name: "loading..."}
    ];
    $scope.project = $cookies.get('issues.project');

    $http.get('/projects').success(function(res) {
        console.log(res);
        var selectedProject = $cookies.get('issues.project');
        var selectedIndex = 0;
        console.log($cookies.get('issues.project'));
        $scope.projects = res.projects.map(function (p, i) {
            if (p.attributes.id == selectedProject) {
                selectedIndex = i;
                console.log(selectedIndex);
            }
            return {id: p.attributes.id, name: p.attributes.name};
        });
        $scope.project = $scope.projects[selectedIndex];
    }).error(function(res) {
        console.log(res);
    });

    $scope.changeProject = function() {
        console.log($scope.project);
        $cookies.put('issues.project', $scope.project);
        console.log($cookies.get('issues.project'));
        $scope.doSearch();
    }

    $scope.doSearch = function() {
        if ($scope.project == null) {
            return;
        }
        $http({
            method : 'GET',
            url : $uri + '/' + $scope.project,
            params: {"statusId[]": [1, 2, 3]}
        }).success(function(data, status, headers, config) {
            $scope.issues = {1: [], 2: [], 3: []};
            data.issues.forEach(function (issue, idx) {
                var statusId = issue.status.attributes.id
                $scope.issues[statusId].push(issue);
            });
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
    };

    $scope.doSearch();
}]);

//IssueTypes
app.controller('IssueTypesGetCtrl', ['$scope', '$http', function ($scope, $http) {
    var $uri ='/issue_types';
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

app.controller('IssueTypesPostCtrl', ['$scope', '$http', function ($scope, $http) {
    var $uri ='/issue_types';
    $scope.doPost = function() {
        $http({
            method : 'POST',
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
