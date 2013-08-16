
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

.controller( 'SalesCtrl', function SalesController( $scope ) {
  $scope.items = [
    {
      rank: 1,
      bid: '$42',
      address: '430 N Main, Layton',
      date: new Date(),
      county: 'Davis',
      seller: 'Lundberg',
      owner: 'Jack & Jill',
      updated: new Date()
    }
  ];

})


;
