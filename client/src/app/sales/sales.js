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

.controller( 'SalesCtrl',
            function SalesController($scope,
                                     SaleRepository,
                                     titleService,
                                     $filter) {
  titleService.setTitle( 'Sales' );

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

  $scope.nextRank = function (sale) {
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

    //setTimeout(function () {
      SaleRepository.update(sale._id, { 'rank': sale.rank});
    //}, 3000);

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
      ret = ret.replace(/\.\d\d/g, '');
      if (!ret.match(/\$/)) {
        ret = ret.replace(/\b(\d[\d,]+)\b/g, function(d) { return('$'+d); });
      }
    }
    return ret;
  };
})

.filter('encode', function() {
  return encodeURIComponent;
})

.filter('address', function($sce) {
  return _.memoize(function(text) {
    return $sce.trustAsHtml(
      text
        .replace(/-/g, "&#8209;")
        .replace(', ', "\n")
        .replace(/ /g, "&nbsp;")
    );
  });
})


;
