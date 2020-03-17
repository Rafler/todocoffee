define './Footer',
['./TodosList'],
(TodosList) ->
  class Footer extends TodosList
    constructor: () ->
      super()

      @clearButton = document.getElementById('clear-completed')

      @allFilter = document.getElementById('allTodos')

      @activeFilter = document.getElementById('activeTodos')

      @completedFilter = document.getElementById('completedTodos')

      @initEventListener()

    resetFiltersClasses:(e) ->
      @allFilter.classList.remove('selected')
      @completedFilter.classList.remove('selected')
      @activeFilter.classList.remove('selected')
      e.target.classList.add('selected')

    initEventListener: () ->
      self = @

      @clearButton.onclick = () -> self.clearCompleted(self.todos)

      @activeFilter.onclick = (e) ->
        self.filter('active', self.todos)
        self.resetFiltersClasses(e)

      @allFilter.onclick = (e) ->
        self.filter('all', self.todos)
        self.resetFiltersClasses(e)

      @completedFilter.onclick = (e) ->
        self.filter('completed', self.todos)
        self.resetFiltersClasses(e)

  footer = new Footer
