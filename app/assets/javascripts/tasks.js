

angular.module('tasks',['ui.date','ui.sortable','ngTagsInput','angularFileUpload']).
service('getTasks',function($http){
  $http.defaults.headers.common['X-User-Email'] = 'efren_ce@hotmail.com'; 
  $http.defaults.headers.common['X-User-Token'] = "pwxtcdG515yudzeuAX-m";

  var promise = $http.get('/users/1/tasks.json').
  success(function(data){
    console.log(data);
    return data.tasks;
  });
  return promise;
}).
controller('mainController',['$scope','$http','getTasks','FileUploader',function($scope,$http,getTasks,FileUploader){
  $scope.uploader = new FileUploader();
  $scope.dateOptions = {
    changeYear: true,
    changeMonth: true,
    yearRange: '1900:-0'
  };

  $scope.sortableOptions = {
    update: function(e, ui) {
      console.log('update event get fired');
      if (ui.item.scope().item == "can't be moved") {
        ui.item.sortable.cancel();
      }
      console.log($scope.tasks);
      var data = {tasks: $scope.tasks};
      var promise = $http.post('/users/1/tasks/sort.json',data,{}).
      success(function(data){
        console.log(data);
      });
    }
  };
  $scope.newTask = {};
  $scope.query = '';
  getTasks.then(function(data){
    $scope.tasks = data.data.tasks;
    console.log(data);
    $scope.deleteTask = function(task){
      var promise = $http.delete('/tasks/'+task.id+'.json',{},{}).
      success(function(data){
        $scope.tasks = _.filter($scope.tasks, function(t){ 
          return t.id !== task.id;
        });
      });
    };

    $scope.updateTask = function(task){      
      var modifiedTask;
      if(task.tags) { 
        task =  _.extend(task,{tags: _.pluck(task.tags,'text')});
      }
      //task = _.filter(task,function(v,k){ k !== 'uploader';});
      console.log(task);
      var promise = $http.put('/tasks/'+task.id+'.json',task,{}).
      success(function(data){
        console.log(data);
      });
    };

    $scope.uploadFile = function(files){
      $scope.file = files[0];
    };

    $scope.addTask = function(){
      //console.log($scope.newTask);
      console.log($scope.uploader);
      var fd = new FormData();
      //console.log($scope.uploader);
      var data = {
        'description': $scope.newTask.description,
        'expiration':$scope.newTask.expDate,
        'tags':_.pluck($scope.newTask.tags,'text'), 
        'status':false,
        'file':$scope.file
      };
      _.each(data,function(v,k){ fd.append(k,v); });
      var responsePromise = $http.post('/users/1/tasks.json',fd,{
        transformRequest: angular.identity,
        headers:{'Content-Type':undefined}
      }).
      success(function(data){
        console.log(data);
        if(data.status === 200){
          $scope.tasks.push(data.task);
          $scope.newTask = {};
        } else if(data.status === 400){ // there are validation errors
          console.log('error');
        }  
      });
    };

    $scope.search = function(){
      if($scope.query){
        var promise = $http.post('/users/1/tasks/search.json',{query:$scope.query},{}).
        success(function(data){
          $scope.tasks = data.tasks;
        });
      } else {
        var promise = $http.get('/users/1/tasks.json').
        success(function(data){
          $scope.tasks = data.tasks;
        });
      }
    };

    $scope.clearCompleted = function(){
      $scope.tasks = _.filter($scope.tasks, function(t){
        return !t.status;
      });
    };

  });
}]).directive('ngEnter', function () {
  return function (scope, element, attrs) {
    element.bind("keydown keypress", function (event) {
      if(event.which === 13) {
        scope.$apply(function (){
          scope.$eval(attrs.ngEnter);
        });

        event.preventDefault();
      }
    });
  };
});
