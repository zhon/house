angular.module( 'app', [
  'templates-app',
  'templates-common',
  'app.sales',
  'app.sellers',
  'app.home',
])

.config( function myAppConfig ( $stateProvider, $urlRouterProvider ) {
  $urlRouterProvider.otherwise( '/sales' );
})

.run( function run ( titleService ) {
  titleService.setSuffix( ' | Foreclosure' );
})

/*jshint -W098 */
.controller( 'AppCtrl', function AppCtrl ( $scope, $location ) {
})

;

