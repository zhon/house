angular.module( 'app', [
  'templates-app',
  'templates-common',
  'app.sales',
  'app.home',
  'ui.state',
  'ui.route'
])

.config( function myAppConfig ( $stateProvider, $urlRouterProvider ) {
  $urlRouterProvider.otherwise( '/sales' );
})

.run( function run ( titleService ) {
  titleService.setSuffix( ' | Foreclosure' );
})

.controller( 'AppCtrl', function AppCtrl ( $scope, $location ) {
})

;

