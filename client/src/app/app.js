angular.module( 'app', [
  'templates-app',
  'templates-common',
  'app.sales',
  'app.home',
  'app.about',
  'ui.state',
  'ui.route'
])

.config( function myAppConfig ( $stateProvider, $urlRouterProvider ) {
  $urlRouterProvider.otherwise( '/home' );
})

.run( function run ( titleService ) {
  titleService.setSuffix( ' | ngBoilerplate' );
})

.controller( 'AppCtrl', function AppCtrl ( $scope, $location ) {
})

;

