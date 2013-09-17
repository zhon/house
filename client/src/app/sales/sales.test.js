
describe( 'sales', function() {

  beforeEach( module( 'app.sales' ) );

  describe('routing', function() {
    // good luck testing ui-routing
    // let me know when you figure it out
  });

  describe('SalesCtrl', function() {
    var mockScope,
        mockSaleRepository;

    beforeEach( inject(function($rootScope, _$controller_) {
      mockScope = $rootScope.$new();
      mockSaleRepository = sinon.stub({getAllSales: function(){}});
      $controller = _$controller_;
    }));

    describe('on create', function() {
      it('calls SaleRepository.getAllSales', function() {
        mockSaleRepository.getAllSales.returns({then: function() {}});
        $controller('SalesCtrl', {$scope: mockScope, SaleRepository: mockSaleRepository});

        sinon.assert.calledOnce(mockSaleRepository.getAllSales);
      });

    });
  });

});




