/* jshint -W024 */

angular.module( 'app.sales', [
  'ui.router',
  'ui.bootstrap',
])

.config(function config( $stateProvider ) {
  $stateProvider.state( 'sales', {
    url: '/sales',
    views: {
      "main": {
        controller: 'SalesCtrl',
        templateUrl: 'sales/sales.tpl.html'
      }
    },
    data:{ pageTitle: 'Sales' }
  });
})

.controller( 'SalesCtrl',
            function SalesController($scope,
                                     SaleRepository,
                                     $filter,
                                     $timeout) {
  $scope.sales = [];
  $scope.filteredSales = [];
  getAllSales();

  $scope.deleteSale = function (sale) {
    SaleRepository.delete(sale._id).then(function() {
      $scope.sales = _.without($scope.sales, sale);
      $scope.filteredSales = _.without($scope.filteredSales, sale);
    },
    function(result) {
      alert("something went wrong " + result);
    });
  };

  var rankTimeout;
  $scope.nextRank = function (sale) {
    var rank = sale.rank;
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
    default:
      sale.rank = '3';
    }

    if (!rankTimeout) {
      rankTimeout = $timeout(function () {
        if (rank !== sale.rank) {
          SaleRepository.update(sale._id, { 'rank': sale.rank});
        }
        rankTimeout = undefined;
      }, 3000);
    }

  };

  $scope.$watch("search", function(query) {
    $scope.filteredSales = $filter("filter")($scope.sales, query);
  });

  function getAllSales() {
    SaleRepository.getAllSales().then(function(items) {
      $scope.sales = items;
      $scope.filteredSales = items;
    });
  }

})

.service( 'SaleRepository', function SaleRepository($http) {
  return {

    getAllSales: function () {
      return $http.get('/api/sales').then(function (result) {
        return result.data;
      });
    },

    delete: function(saleId) {
      return $http.delete('api/sale/' + saleId);
    },
    update: function(id, data) {
      return $http.put('api/sale/' + id, angular.toJson(data));
    },

  };

})

.filter('bid', function() {
  return function(text) {
    var ret = text;
    if (ret) {
      ret = ret
        .replace(/\.\d\d/g, '') // remove pennies
        .replace(/\B(?=(?:\d{3})+(?!\d))/g, ',') // add ,
        .replace(/(\$?)(\d[\d,]+)/g, "$$$2");
    }
    return ret;
  };
})

.filter('encode', function() {
  return encodeURIComponent;
})

.filter('address', function($sce) {
  return _.memoize(function(text) {
    if (! text) {
      return '';
    }
    return $sce.trustAsHtml(
      text
        .replace(/-/g, "&#8209;")
        .replace(', ', "<br>")
        .replace(/ /g, "&nbsp;")
    );
  });
})


;
