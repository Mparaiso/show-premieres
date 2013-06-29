trakt = angular.module("trakt", [])

MainController = ($scope, $http,$timeout)->
    angular.extend($scope,{
        apiKey : "53a8e19b109858453b16650b1ede8a7f"
        results : []
        filteredShows:[]
        availableGenres:[]
        filterText:null
        genreFilter:null
        networkFilter:null
        filteredGenres:[]
        orderFields:[
            {label:'Air Date',value:"episode.first_aired"}
            {label:'Rating',value:'episode.ratings.percentage'}
            {label:"Network",value:"show.network"}
        ]
        orderDirections:["Descending","Ascending"]
        orderReverse:false
        emptyMessage:"Loading TV shows please wait..."
    })

    $scope.$watch("filteredShows.length",->
        res = $scope.filteredShows.reduce((prev,current,i,arr)->
            prev.concat(current.show.genres.filter(((genre)-> genre.trim().length > 1 and prev.indexOf(genre)<0))
            )
        ,[]).sort()
        $scope.availableGenres = res
        if $scope.availableGenres.indexOf($scope.genreFilter)<0
            #console.log $scope.genreFilter
            $timeout (-> $scope.genreFilter=null) ,0
    ,false)


    $scope.selectNetwork=(network)->
        $scope.networkFilter = network

    $scope.selectGenre=(genre)->
        $scope.genreFilter=genre

    $scope.init = ->
        today = new Date
        apiDate = today.getFullYear() + ("0" + (today.getMonth() + 1))
            .slice(-2) + "" + ("0" + today.getDate()).slice(-2)
        url ='http://api.trakt.tv/calendar/premieres.json/' + $scope.apiKey + '/' + apiDate + '/' + 100 + '/?callback=JSON_CALLBACK'
        $http.jsonp(url)
            .success((data)->
                $scope.results = data.reduce((prev, current,i,arr)->
                        prev.concat(current.episodes.map((value)->
                            value.date = arr[i].date;value))
                ,[])
#                $scope.availableGenres = $scope.results.reduce((prev,current,index,arr)->
#                  prev.concat(current.show.genres.filter((el)->el if prev.indexOf(el)<0 ))
#                ,[])
                console.log( $scope.availableGenres)
                console.log( $scope.results)

                $scope.networks = $scope.results.reduce((prev,current,index,arr)->
                    prev.push(current.show.network) if current.show.network.trim().length > 1 and prev.indexOf(current.show.network)<0
                    return prev
                ,[]).sort()
                return

            ).error((error)(->$scope.emptyMessage="Loading TV shows failed , please refresh the page."))