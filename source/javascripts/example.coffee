window.Example = (I={}) ->
  compile = (sourceCode) ->
    $(".alert-danger").text("")
      .addClass("hidden")

    $("#{I.selector} .data textarea").removeClass("error")

    try
      compiledCode = CoffeeScript.compile(sourceCode, {bare: true})
    catch e
      position = ""
      if l = e.location
        position = "on line #{l.first_line}, character #{l.first_column}"

      message = "#{e.message} #{position}"

      $(".alert-danger").text(message)
        .removeClass("hidden")

      $("#{I.selector} .data textarea").addClass("error")

  evaluate = ->
    sourceCode = $("#{I.selector} .data textarea").val()
    compiledCode = compile(sourceCode)

    eval.call(self, compiledCode)
    I.output($("#{I.selector} pre.output"))

  self =
    render: ->
      $("#{I.selector} textarea").on "keyup", evaluate
      $("#{I.selector} .data textarea").val(I.data)
      $("#{I.selector} .explanation").text(I.explanation)

      evaluate()
