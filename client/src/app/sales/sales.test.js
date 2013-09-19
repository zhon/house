/* jshint -W024 */

describe( 'sales', function() {

  beforeEach( module( 'app.sales' ) );

  describe('routing', function() {
    // good luck testing ui-routing
    // let me know when you figure it out
  });

  describe('SalesCtrl', function() {
    var scope
      , mockSaleRepository
      , deferredGetAllSales
      , $controller
      , $q
    ;

    beforeEach( inject(function($rootScope, _$controller_, _$q_, SaleRepository) {
      scope = $rootScope.$new();
      $q = _$q_;
      deferredGetAllSales = $q.defer();
      mockSaleRepository = sinon.stub(SaleRepository);
      mockSaleRepository.getAllSales.returns(deferredGetAllSales.promise);
      $controller = _$controller_;
    }));

    describe('create', function() {
      var returnedSales = [{ foo: 'bar' }];

      beforeEach(function () {
        deferredGetAllSales.resolve(returnedSales);
        $controller('SalesCtrl', {$scope: scope, SaleRepository: mockSaleRepository});
        scope.$root.$digest();
      });

      it('calls SaleRepository.getAllSales', function() {
        sinon.assert.calledOnce(mockSaleRepository.getAllSales);
      });

      it('loads all sales', function() {
        expect(scope.sales).toBe(returnedSales);
      });

    });

    describe('deleteSale', function() {
      var deferredUpdate
        , returnedSales = [{ _id: '42', foo: 'bar' }];

      beforeEach(function () {
        deferredUpdate = $q.defer();
        deferredGetAllSales.resolve(returnedSales);
        $controller('SalesCtrl', {$scope: scope, SaleRepository: mockSaleRepository});
        scope.$root.$digest();
      });

      it('deletes the sale', function() {
        mockSaleRepository.delete.returns(deferredUpdate.promise);
        expect(scope.sales).toBe(returnedSales);
        scope.deleteSale(returnedSales[0]);
        deferredUpdate.resolve('');
        scope.$root.$digest();
        expect(scope.sales).toEqual([]);
      });

    });

    describe('nextRank', function() {
      var deferredUpdate
        , returnedSales = [{ _id: '42', foo: 'bar' }];

      beforeEach(function () {
        deferredUpdate = $q.defer();
        deferredGetAllSales.resolve(returnedSales);
        $controller('SalesCtrl', {$scope: scope, SaleRepository: mockSaleRepository});
        scope.$root.$digest();
        mockSaleRepository.update.returns(deferredUpdate.promise);
      });

      it('updates rank by calling SaleRepoistory.update', function() {
        var sale = scope.sales[0];
        scope.nextRank(sale);
        sinon.assert.calledWith(mockSaleRepository.update, '42', {rank: '3' });
      });

      it('changes rank in order (null -> 3 -> 1 -> 2 -> 0 -> 3)', function() {
        var sale = {_id: '42'};
        expect(sale.rank).toEqual(null);
        scope.nextRank(sale);
        expect(sale.rank).toEqual('3');
        scope.nextRank(sale);
        expect(sale.rank).toEqual('1');
        scope.nextRank(sale);
        expect(sale.rank).toEqual('2');
        scope.nextRank(sale);
        expect(sale.rank).toEqual('0');
        scope.nextRank(sale);
        expect(sale.rank).toEqual('3');
      });

    });

  });

});




