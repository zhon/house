/* jshint -W024 */

describe( 'sales', function() {

  beforeEach( module( 'app.sales' ) );

  describe('routing', function() {
    // good luck testing ui-routing
    // let me know when you figure it out
  });

  describe('SalesCtrl', function() {
    var scope,
      mockSaleRepository,
      deferredGetAllSales,
      $controller,
      $q;

    beforeEach( inject(function($rootScope, _$controller_, _$q_, SaleRepository, _$timeout_) {
      scope = $rootScope.$new();
      $q = _$q_;
      deferredGetAllSales = $q.defer();
      mockSaleRepository = sinon.stub(SaleRepository);
      mockSaleRepository.getAllSales.returns(deferredGetAllSales.promise);
      $controller = _$controller_;
      $timeout = _$timeout_;
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
      var deferredUpdate,
        returnedSales = [{ _id: '42', foo: 'bar' }];

      beforeEach(function () {
        deferredUpdate = $q.defer();
        deferredGetAllSales.resolve(returnedSales);
        $controller('SalesCtrl', {$scope: scope, SaleRepository: mockSaleRepository});
        scope.$root.$digest();
      });

      it('deletes the sale', function() {
        mockSaleRepository.delete.returns(deferredUpdate.promise);
        expect(scope.sales).toBe(returnedSales);
        expect(scope.filteredSales).toBe(returnedSales);
        scope.deleteSale(returnedSales[0]);
        deferredUpdate.resolve('');
        scope.$root.$digest();
        expect(scope.sales).toEqual([]);
        expect(scope.filteredSales).toEqual([]);
      });

    });

    describe('nextRank', function() {
      var deferredUpdate,
          returnedSales = [{ _id: '42', foo: 'bar' }];

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
        $timeout.flush();
        sinon.assert.calledWith(mockSaleRepository.update, '42', {rank: '3' });
      });

      it('does\'t update rank when cycled back to original rank', function() {
        var sale = scope.sales[0];
        scope.nextRank(sale);
        scope.nextRank(sale);
        scope.nextRank(sale);
        scope.nextRank(sale);
        $timeout.flush();
        sinon.assert.neverCalledWith(mockSaleRepository.update);
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

  describe('filter', function() {
    var filter;

    beforeEach(inject(function($filter) {
      filter = $filter;
    }));

    describe('bid', function() {

      it('adds $ to numbers', function() {
        expect(filter('bid')('56')).toEqual('$56');
        expect(filter('bid')('56 up to 95')).toEqual('$56 up to $95');
      });

      it('doesn\t add $ to single digit', function() {
        expect(filter('bid')('0')).toEqual('0');
      });

      it('strips off change', function() {
        expect(filter('bid')('$56.22')).toEqual('$56');
      });

      it('strips off change', function() {
        expect(filter('bid')('$56.22')).toEqual('$56');
      });

      it('does nothing with null', function() {
        expect(filter('bid')(null)).toEqual(null);
      });

      it('adds commas to bid', function() {
        expect(filter('bid')('$3000')).toEqual('$3,000');
        expect(filter('bid')('$30000')).toEqual('$30,000');
        expect(filter('bid')('$300000')).toEqual('$300,000');
        expect(filter('bid')('$3000000')).toEqual('$3,000,000');
      });

    });

    describe('address', function() {
      var address;

      beforeEach(function() {
        address = filter('address');
      });

      it("replaces '-' with &#8209; (non break hyphen)", function() {
        expect(address('-').toString()).toEqual('&#8209;');
        expect(address('-2-').toString()).toEqual('&#8209;2&#8209;');
      });

      it("replaces space with nbsp", function() {
        expect(address(' 9 ').toString()).toEqual('&nbsp;9&nbsp;');
      });

      it("replaces comma with newline", function() {
        expect(address(', ').toString()).toEqual('<br>');
      });

      it('deals gracefully with null and empty string', function() {
        expect(address('').toString()).toEqual('');
        expect(address(null).toString()).toEqual('');
      });

    });

  });


});




