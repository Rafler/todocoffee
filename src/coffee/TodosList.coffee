define './TodosList',
[
  './TodoServices'
  '../css/base.css'
  '../css/index.css'
],
(TodoServices) ->
  class TodosList extends TodoServices
    constructor: () ->
      super()
      @mode = 'default'
      @input = document.getElementById('new-todo')
      @completeAllButton = document.getElementById('toggle-all')
      @clearButton = document.getElementById('clear-completed')
      @allFilter = document.getElementById('allTodos')
      @activeFilter = document.getElementById('activeTodos')
      @completedFilter = document.getElementById('completedTodos')
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
      @completeAllButton.onclick = (e) ->
        self.completeAll(self.todos)

      @input.onkeypress = (e) ->
        if e.keyCode == 13
          self.addTodo(e.target)
          self.input.value = ''

      @clearButton.onclick = (e) ->
        self.clearCompleted(self.todos)

      @activeFilter.onclick = (e) ->
        self.filter('active', self.todos)
        self.allFilter.className = ''
        self.completedFilter.className = ''
        self.activeFilter.className = 'selected'

      @allFilter.onclick = (e) ->
        self.filter('all', self.todos)
        self.activeFilter.className = ''
        self.completedFilter.className = ''
        self.allFilter.className = 'selected'

      @completedFilter.onclick = (e) ->
        self.filter('completed', self.todos)
        self.activeFilter.className = ''
        self.allFilter.className = ''
        self.completedFilter.className = 'selected'






  todos = new TodosList

