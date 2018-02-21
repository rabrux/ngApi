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
  .factory 'token', [
    '$localStorage'
    ( $db ) ->
      $db.get 'token'
  ]
  .factory 'beforeRequest', [
    'token'
    'baseUri'
    ( token, uri ) ->
      {
        request : ( config ) ->
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
