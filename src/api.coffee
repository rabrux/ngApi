angular
  .module 'ngApi', [ 'ngLocalStorage' ]
  .provider '$api', [ ->
    {
      baseUri : ''
      init : ( uri ) ->
        @baseUri = uri.replace /(\/)*$/i, ''
      $get : -> baseUri : @baseUri
    }
  ]
  .factory 'baseUri', [
    '$api'
    ( $api ) -> $api.baseUri
  ]
  .factory 'beforeRequest', [
    '$localStorage'
    'baseUri'
    ( $db, uri ) ->
      {
        request : ( config ) ->
          token = $db.get 'token'
          config.headers[ 'Authorization' ] = token if token and config.url.indexOf( uri ) is 0
          config
      }
  ]
  .config [
    '$httpProvider'
    ( $httpProvider ) ->
      $httpProvider.defaults.useXDomain = true
      $httpProvider.interceptors.push 'beforeRequest'
      return
  ]
