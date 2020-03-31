define './TodosList',
[
  '../services/TodoServices'
  '../css/index.css'
],
(TodoServices) ->
  class TodosList extends TodoServices
    constructor: () ->
      super()

      @input = document.getElementById('app-new-todo')
      @completeAllButton = document.getElementById('app-toggle-all')

      @_initialiseEventListener()

    _eventHandler: (target) ->
      id = target.parentElement.id

      if target.className == "destroy"
        @delete(id)
      else if target.className == "toggle"
        @complete(id)

    _initialiseEventListener: () ->
      self = @

      @list.addEventListener('click',(e) -> self._eventHandler(e.target))

      @completeAllButton.onclick = () -> self.completeAll(self.todos)

      @input.onkeypress = (e) ->
        enterCode = 13

        if e.keyCode == enterCode
          self.addTodo(e.target)
          self.input.value = ''
