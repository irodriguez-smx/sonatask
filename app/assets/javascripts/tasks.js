

angular.module('tasks',[]).
  controller('mainController',['$scope',function($scope){
    $scope.tasks = [
      {'description':'Build app','done':false}
    ];

    $scope.addTask = function(){
      $scope.tasks.push({'description': $scope.newTask,'done':false});
      $scope.newTask = '';
    };

    $scope.clearCompleted = function(){
      $scope.tasks = _.filter($scope.tasks, function(t){
        return !t.done;
      });
    };
 }]);
