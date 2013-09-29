
angular.module( 'app.sellers', [
  'ui.state',
  'placeholders',
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

.controller( 'SellersCtrl', function SellersController( $scope, SellerRepository, titleService ) {
  titleService.setTitle( 'Sellers' );

  $scope.sellers = [];
  getAllSellers();

  function getAllSellers() {
    SellerRepository.getAllSellers().then(function(items) {
      $scope.sellers = items;
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
