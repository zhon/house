
angular.module( 'app.sellers', [
  'ui.router',
  'ui.bootstrap',
  'titleService'
])

.config(function config( $stateProvider ) {
  $stateProvider.state( 'sellers', {
    url: '/sellers',
    views: {
      "main": {
        controller: 'SellersCtrl',
        templateUrl: 'sellers/sellers.tpl.html'
      }
    }
  });
})

.controller( 'SellersCtrl', function SellersController( $scope, SellerRepository, titleService, $filter ) {
  titleService.setTitle( 'Sellers' );

  $scope.sellers = [];
  $scope.filteredSellers = [];
  getAllSellers();

  $scope.$watch("search", function(query) {
    $scope.filteredSellers = $filter("filter")($scope.sellers, query);
  });

  function getAllSellers() {
    SellerRepository.getAllSellers().then(function(items) {
      $scope.sellers = items;
      $scope.filteredSellers = items;
    });
  }

})

.service( 'SellerRepository', function SellerRepository($http) {
  return {

    getAllSellers: function () {
      return $http.get('/api/sellers').then(function (result) {
        return result.data;
      });
    }

  };

})

;
