// ShowService can be shared amongst controllers ,directives ,filters ,etc ...
app.factory("ShowService",function($http){

    var  ShowService = {
        availableGenres:[],
        results:[],
        url:"http://someapiurl",
        getGenres:function(){},
        getResults:function(){},
        init:function(callback){
            var that =this ;
            return $http.jsonp(this.url).success(
                function(data){
                    that.availableGenres = that.getGenres(data);
                    that.results = that.getResults(data);
                    if(callback)callback.apply(null,[].slice.call(arguments))
                }
            )
        }
    }
    return ShowService;

});

// then you can reference the show service in another controller

app.controller("SideBarCtrl",function($scope,ShowService){
$scope.showService = ShowService ;
$scope.showService.init(function(){console.log("now do something in the view")});
});