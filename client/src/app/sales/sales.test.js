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

    describe('$scope.deleteSale', function() {
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
  });

});




