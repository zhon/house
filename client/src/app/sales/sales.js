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
      var sales = _.without($scope.sales, sale);
      $scope.sales = sales;
    },
    function(result) {
      alert("something went wrong " + result);
    });
  };

  $scope.nextRank = function (sale) {
    if (sale.rank === null) {
      sale.rank = '0'
    }
    switch (sale.rank) {
    case '1':
      sale.rank = '2';
    break;
    case '2':
      sale.rank = '0';
      break;
    case '3':
      sale.rank = '1';
      break;
    case '0':
      sale.rank = '3';
      break;
    }

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
