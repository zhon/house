
angular.module( 'app.sales', [
  'ui.state',
  'placeholders',
  'ui.bootstrap',
  'titleService'
])

.config(function config( $stateProvider ) {
  $stateProvider.state( 'sales', {
    url: '/sales',
    views: {
      "main": {
        controller: 'SalesCtrl',
        templateUrl: 'sales/sales.tpl.html'
      }
    }
  });
})

.controller( 'SalesCtrl', function SalesController( $scope, SaleRepository, titleService ) {
  titleService.setTitle( 'Sales' );

  $scope.items = [];
  getAllSales();

  function getAllSales() {
    SaleRepository.getAllSales().then(function(items) {
      $scope.items = items;
    });
  }

})

.service( 'SaleRepository', function SaleRepository($http) {
  return {
    getAllSales: function () {
      return $http.get('/api/sales').then(function (result) {
        return result.data;
      });
    }
  };

})


;
