'use strict';

var app = angular.module('nekolog' , ['ngCookies', 'ui.sortable']);

//Projects
app.controller('SettingCtrl', ['$scope', '$http', function($scope, $http) {

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

// Issues
app.controller('MainCtrl', ['$scope', '$http', '$cookies', function ($scope, $http, $cookies) {

    $scope.projects = [
        {id: "", name: "loading..."}
    ];
    $scope.project = $cookies.get('issues.project');
    $scope.issues = {1: [], 2: [], 3: []};
    $scope.todoIssues = [];
    $scope.doingIssues = [];
    $scope.doneIssues = [];
    $scope.sortableOptions = {
        connectWith: angular.element('.issues'),
        update: function(e, ui) {
            console.log($scope.todoIssues, $scope.doingIssues, $scope.doneIssues);
        }
    }

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
        $scope.getIssues();
    }

    $scope.getIssues = function() {
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": "issues", "projectId": $scope.project, "statusId[]": [1, 2, 3]}
        }).success(function(data, status, headers, config) {
            data.issues.forEach(function (issue, idx) {
                var statusId = issue.status.attributes.id
                $scope.issues[statusId].push(issue);
            });
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": "todo", "projectId": $scope.project, "statusId[]": [1]}
        }).success(function(data, status, headers, config) {
            $scope.todoIssues = data.issues
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": "doing", "projectId": $scope.project, "statusId[]": [2]}
        }).success(function(data, status, headers, config) {
            $scope.doingIssues = data.issues;
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": "done", "projectId": $scope.project, "statusId[]": [3]}
        }).success(function(data, status, headers, config) {
            $scope.doneIssues = data.issues;
            console.log(status);
            console.log(data);
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
    };

    console.log('project', $scope.project);
    if ($scope.project != null) {
        $scope.getIssues();
    }
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
