define './TodosList',
[
  '../services/TodoServices'
  '../css/index.css'
],
(TodoServices) ->
  class TodosList extends TodoServices
    constructor: () ->
      super()
      @input = document.getElementById('new-todo')

      @completeAllButton = document.getElementById('toggle-all')

      @_initialiseEventListener()

    _initialiseEventListener: () ->
      self = @

      @list.addEventListener('change',
        (event) ->
          eventTarget = event.target

          if eventTarget.type == 'checkbox'
            id = event.target.parentElement.id

            if id then self.complete(id)
      )
      @list.addEventListener('click',
        (event) ->
          eventTarget = event.target

          if eventTarget.className == "destroy"
            id = event.target.parentElement.id

            if id then self.delete(id)
      )
      @completeAllButton.onclick = () -> self.completeAll(self.todos)

      @input.onkeypress = (e) ->
        enterCode = 13

        if e.keyCode == enterCode
          self.addTodo(e.target)
          self.input.value = ''





