Example
  data: """
    question = Observable ""
    answer = Observable ""

    question.observe ->
      answer "They sure are."

    question "Observables are pretty great, aren't they?"
  """
  output: ($pre) ->
    $pre.text """
      Question:
      #{question()}

      Answer:
      #{answer()}
    """
  selector: "#message"
  explanation: """
    The simplest case is to Observe a string for changes to its value.
  """
.render()

Example
  data: """
    firstName = Observable "Matt"
    lastName = Observable "Diebolt"

    fullName = Observable ->
      firstName() + ' ' + lastName()
  """
  output: ($pre) ->
    output = """
      First Name: #{firstName()}
      Last Name: #{lastName()}

      Full Name: #{fullName()}
    """

    $pre.text(output)

  selector: "#full-name"
  explanation: """
    Moving to something a bit more complicated, we can set up firstName and lastName to be observed. Declaring fullName as an Observable function watches any Observables in the function body and is updated when those components are changed.
  """
.render()

Example
  data: """
    list = Observable [1, 2, 3]

    list.push(6)
    list.remove(2)
  """
  selector: "#arrays"
  explanation: """
    Setting up an Observable array will track items as they're added or removed from the array.
  """
  output: ($pre) ->
    $pre.text """
      Array Contains:
      [#{list()}]
    """
.render()
