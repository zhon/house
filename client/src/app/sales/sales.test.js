
describe( 'sales', function() {

  beforeEach( module( 'app.sales' ) );

  describe('routing', function() {
    // good luck testing ui-routing
    // let me know when you figure it out
  });

  describe('SalesCtrl', function() {
    var mockScope,
        mockSaleRepository,
        mockTitleService,
        mockQ,
        deferred;

    beforeEach( inject(function($rootScope, _$controller_, $q, SaleRepository) {
      mockScope = $rootScope.$new();
      mockSaleRepository = sinon.stub({getAllSales: function(){}});
      mockTitleService = sinon.stub();
      controller = _$controller_;
      //deferred = $q.defer();
    }));

    describe('on create', function() {
      it('calls SaleRepository.getAllSales', function() {

        mockSaleRepository.getAllSales.returns({then: function() {}});

        controller('SalesCtrl', {$scope: mockScope, SaleRepository: mockSaleRepository, TitleService: mockTitleService});

        sinon.assert.calledOnce(mockSaleRepository.getAllSales);
      });

    });
  });

});




