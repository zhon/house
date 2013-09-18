/* jshint -W024 */

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

  $scope.sales = [];
  getAllSales();

  $scope.deleteSale = function (sale) {
    SaleRepository.delete(sale._id).then(function() {
      var sales = _.reject($scope.sales, function(s) {
        return sale === s;
      });
      $scope.sales = sales;
    },
    function(result) {
      alert("something went wrong " + result);
    });
  };

  function getAllSales() {
    SaleRepository.getAllSales().then(function(items) {
      $scope.sales = items;
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
    ,
    delete: function(saleId) {
      return $http.delete('api/sale/' + saleId);
    }

  };

})


;
