define './Footer',
['./TodosList'],
(TodosList) ->
  class Footer extends TodosList
    constructor: () ->
      super()

      @clearButton = document.getElementById('app-clear-completed')
      @allFilter = document.getElementById('app-allTodos')
      @activeFilter = document.getElementById('app-activeTodos')
      @completedFilter = document.getElementById('app-completedTodos')

      @_initEventListener()

    _resetFiltersClasses:(e) ->
      @allFilter.classList.remove('selected')
      @completedFilter.classList.remove('selected')
      @activeFilter.classList.remove('selected')
      e.target.classList.add('selected')

    _filterClick: (type, e) ->
      @filter(type, self.todos)
      @_resetFiltersClasses(e)


    _initEventListener: () ->
      self = @

      @clearButton.onclick = () -> self.clearCompleted(self.todos)

      @activeFilter.onclick = (e) -> self._filterClick('active', e)

      @allFilter.onclick = (e) -> self._filterClick('all', e)

      @completedFilter.onclick = (e) -> self._filterClick('completed', e)

  footer = new Footer
