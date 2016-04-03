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
        }).error(function(data, status, headers, config) {
            console.log(status);
        });
    };

}]);

// Main
app.controller('MainCtrl', ['$scope', '$http', '$cookies', function ($scope, $http, $cookies) {
    $scope.projects = [
    ];
    $scope.project = $cookies.get('issues.project');
    $http.get('/projects').success(function(res) {
        var selectedProject = $cookies.get('issues.project');
        var selectedIndex = 0;
        $scope.projects = res.projects.map(function (p, i) {
            if (p.attributes.id == selectedProject) {
                selectedIndex = i;
            }
            return {id: p.attributes.id, name: p.attributes.name};
        });
        $scope.project = $scope.projects[selectedIndex];
    }).error(function(res) {
        console.log(res);
    });
}]);

//Issue
app.controller('IssueCtrl', ['$scope', '$http', '$cookies', function ($scope, $http, $cookies) {
    var $uri ='/issues';
    $scope.issues = {1: [], 2: [], 3: []};

    var appElement = document.querySelector('[ng-controller=MainCtrl]');
    var $projectScope = angular.element(appElement).scope();
    $projectScope.changeProject = function() {
        neko.showLoading();
        $cookies.put('issues.project', $projectScope.project.id);
        console.log("$cookies.put('issues.project', $projectScope.project.id)", $cookies.get('issues.project'));
        $scope.doSearch();
    }

    $scope.doSearch = function() {
        if ($projectScope.project == null) {
            return;
        }
        neko.showLoading();
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": "issues", "projectId": $projectScope.project, "statusId[]": [1, 2, 3]}
        }).success(function(data, status, headers, config) {
            data.issues.forEach(function (issue, idx) {
                var statusId = issue.status.attributes.id
                $scope.issues[statusId].push(issue);
            });
            console.log("$scope.issues", $scope.issues);
            console.log(status);
            console.log(data);
            neko.hideLoading();
        }).error(function(data, status, headers, config) {
            console.log(status);
            neko.hideLoading();
        });
    };

    $scope.doSearch();
}]);

app.controller('IssuesCtrl', ['$scope', '$http', function ($scope, $http) {
    $scope.issues = [];
    $scope.changeProject = function() {
        $scope.doSearch();
    }
    $scope.init = function(type, status) {

        $scope.doSearch(type, status);

    }

    $scope.doSearch = function(type, status) {
        if ($scope.project == null) {
            return;
        }
        neko.showLoading();
        $http({
            method : 'GET',
            url : '/issues',
            params: {"type": type, "projectId": $scope.project, "statusId[]": [status]}
        }).success(function(data, status, headers, config) {
            data.issues.forEach(function (issue, idx) {
                $scope.issues.push(issue);
            });
            console.log(status);
            console.log(data);
            neko.hideLoading();
        }).error(function(data, status, headers, config) {
            console.log(status);
            neko.hideLoading();
        });
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
