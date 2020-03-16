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
      @initialiseFooterEventListener()

    resetFiltersClasses:(e) ->
      @allFilter.className = ''
      @completedFilter.className = ''
      @activeFilter.className = ''
      e.target.className = 'selected'

    initialiseFooterEventListener: () ->
      self = @
      @clearButton.onclick = (e) -> self.clearCompleted(self.todos)

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
