

angular.module('tasks',[]).
service('getTasks',function($http){
  $http.defaults.headers.common['X-User-Email'] = 'efren_ce@hotmail.com'; 
  $http.defaults.headers.common['X-User-Token'] = 'wzjn9Bunz7_jxyqcJwt9';
 
   var promise = $http.get('/tasks.json').
    success(function(data){
      console.log(data);
      return data.tasks;
    });
    return promise;
}).
controller('mainController',['$scope','$http','getTasks',function($scope,$http,getTasks){

  getTasks.then(function(data){
    $scope.tasks = data.data.tasks;
    console.log(data);
    $scope.addTask = function(){
      var data = {'description': $scope.newTask,'done':false};
      var responsePromise = $http.post('/tasks.json',data,{}).
      success(function(data){
        console.log(data);
        if(data.status === 200){
          $scope.tasks.push(_.defaults(data.task,{done:false}));
          $scope.newTask = '';
        } else if(data.status === 400){ // there are validation errors
          console.log('error');
        }  
      });
    };

    $scope.clearCompleted = function(){
      $scope.tasks = _.filter($scope.tasks, function(t){
        return !t.done;
      });
    };
 
  });
 }]);
