Observable = (value) ->

  return value if typeof value?.observe is "function"

  listeners = []

  notify = (newValue) ->
    listeners.forEach (listener) ->
      listener(newValue)

  if typeof value is 'function'
    fn = value
    self = ->
      # Automagic dependency observation
      magicDependency(self)

      return value

    self.observe = (listener) ->
      listeners.push listener

    changed = ->
      value = fn()
      notify(value)

    value = computeDependencies(fn, changed)

  else

    self = (newValue) ->
      if arguments.length > 0
        if value != newValue
          value = newValue

          notify(newValue)
      else
        # Automagic dependency observation
        magicDependency(self)

      return value

    self.observe = (listener) ->
      listeners.push listener

  self.each = (args...) ->
    if value?
      [value].forEach(args...)

  if Array.isArray(value)
    [
      "concat"
      "every"
      "filter"
      "forEach"
      "indexOf"
      "join"
      "lastIndexOf"
      "map"
      "reduce"
      "reduceRight"
      "slice"
      "some"
    ].forEach (method) ->
      self[method] = (args...) ->
        value[method](args...)

    [
      "pop"
      "push"
      "reverse"
      "shift"
      "splice"
      "sort"
      "unshift"
    ].forEach (method) ->
      self[method] = (args...) ->
        notifyReturning value[method](args...)

    notifyReturning = (returnValue) ->
      notify(value)

      return returnValue

    extend self,
      each: (args...) ->
        self.forEach(args...)

        return self

      remove: (object) ->
        index = value.indexOf(object)

        if index >= 0
          notifyReturning value.splice(index, 1)[0]

      get: (index) ->
        value[index]

      first: ->
        value[0]

      last: ->
        value[value.length-1]

  extend self,
    stopObserving: (fn) ->
      remove listeners, fn

    toggle: ->
      self !value

    increment: (n) ->
      self value + n

    decrement: (n) ->
      self value - n

    toString: ->
      "Observable(#{value})"

  return self

window.Observable = Observable

extend = (target, sources...) ->
  for source in sources
    for name of source
      target[name] = source[name]

  return target

window.OBSERVABLE_ROOT_HACK = undefined

magicDependency = (self) ->
  if base = window.OBSERVABLE_ROOT_HACK
    self.observe base

withBase = (root, fn) ->
  window.OBSERVABLE_ROOT_HACK = root
  value = fn()
  window.OBSERVABLE_ROOT_HACK = undefined

  return value

base = ->
  window.OBSERVABLE_ROOT_HACK

computeDependencies = (fn, root) ->
  withBase root, ->
    fn()

remove = (array, value) ->
  index = array.indexOf(value)

  if index >= 0
    array.splice(index, 1)[0]
