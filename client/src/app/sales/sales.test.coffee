
describe 'sales', () ->

  beforeEach () ->
    module( 'app.sales' )
    inject( ( ) ->

    )

  describe 'routing', () ->
    route = undefined

    beforeEach () ->

      inject( ( $route ) ->
        route = $route
      )

    it '', inject( () ->
      expect( false ).toEqual( false )
    )

