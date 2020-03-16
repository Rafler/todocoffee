define './TodosList',
[
  './TodoServices'
],
(TodoServices) ->
  class TodosList extends TodoServices
    constructor: () ->
      super()
      @todos = []
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
            console.log(id)
            res = self.complete(id, self.todos)
            self.todos = res
      )
      @list.addEventListener('click',
        (event) ->
          if event.target.className == "destroy"
            id = event.target.parentElement.id
            console.log(id)
            res = self.delete(id, self.todos)
            self.todos = res
      )
      @completeAllButton.onclick = (e) ->
        res = self.completeAll(self.todos)
        self.todos = res

      @input.onkeypress = (e) ->
        if e.keyCode == 13
          res = self.addTodo(e.target)
          self.todos.push(res)
          console.log(self.todos)
          self.input.value = ''

      @clearButton.onclick = (e) ->
        res = self.clearCompleted(self.todos)
        self.todos = res
        console.log(self.todos)

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

