class @api
  constructor: (url, api, ajaxAdapter) ->
    @ajaxAdapter = ajaxAdapter
    @url = url

    for method, rule of api
      @[method] = @_getConsumer rule

  _getConsumer: (rule) ->
    routeParams = []

    [method, route] = rule.split(' ')
    route = route.split('/')

    console.log 'building', method

    return =>
      args = Array::slice.call arguments

      for i in [1..2]
        temp = args.pop()
        switch typeof temp
          when 'function'
            callback = temp
          when 'object'
            options = temp
          else
            args.push temp

      route = @_constructRoute route args

      @ajaxAdapter method, url + route, options, callback

  _constructRoute: (route, args) ->
    fullRoute = ''
    while route.length isnt 0
      temp = route.shift()
      if temp[0] isnt ':'
        fullRoute += ('/' + temp)
      else
        fullRoute += ('/' + args.shift())
    return fullRoute
