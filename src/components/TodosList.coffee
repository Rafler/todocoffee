define './TodosList',
[
  '../services/TodoServices'
  '../css/base.css'
  '../css/index.css'
],
(TodoServices) ->
  class TodosList extends TodoServices
    constructor: () ->
      super()
      @input = document.getElementById('new-todo')
      @completeAllButton = document.getElementById('toggle-all')
      @initialiseEventListener()

    initialiseEventListener: () ->
      self = @
      @list.addEventListener('change',
        (event) ->
          if event.target.type == 'checkbox'
            id = event.target.parentElement.id
            self.complete(id)
      )
      @list.addEventListener('click',
        (event) ->
          if event.target.className == "destroy"
            id = event.target.parentElement.id
            self.delete(id)
      )
      @completeAllButton.onclick = (e) -> self.completeAll(self.todos)

      @input.onkeypress = (e) ->
        if e.keyCode == 13
          self.addTodo(e.target)
          self.input.value = ''





