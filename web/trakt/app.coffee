trakt = angular.module("trakt", [])

MainController = ($scope, $http)->
    angular.extend($scope,{
        apiKey : "53a8e19b109858453b16650b1ede8a7f"
        results : []
        availableGenres:[]
        filterText:null
        genreFilter:null
        orderFields:[{label:'Air Date',value:"episode.first_aired"},{label:'Rating',value:'episode.ratings.percentage'}]
        orderDirections:["Descending","Ascending"]
        orderReverse:false
    })


    $scope.selectGenre=(genre)->
        $scope.genreFilter=genre

    $scope.init = ->
        today = new Date
        apiDate = today.getFullYear() + ("0" + (today.getMonth() + 1))
            .slice(-2) + "" + ("0" + today.getDate()).slice(-2)
        url ='http://api.trakt.tv/calendar/premieres.json/' + $scope.apiKey + '/' + apiDate + '/' + 30 + '/?callback=JSON_CALLBACK'
        $http.jsonp(url)
            .success((data)->
                $scope.results = data.reduce((prev, current,i,arr)->
                        prev.concat(current.episodes.map((value)->
                            value.date = arr[i].date;value))
                ,[])
                $scope.availableGenres = $scope.results.reduce((prev,current,index,arr)->
                  prev.concat(current.show.genres.filter((el)->el if prev.indexOf(el)<0 ))
                ,[])
                console.log( $scope.availableGenres)

            ).error((error)->)