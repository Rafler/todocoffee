define './TodoServices',
[],
() ->
  class TodoServices
    constructor: () ->
      @todos = []

      @list = document.getElementById('list')

      @mode = 'all'

    _generateId: () ->
      id = "f#{(~~(Math.random()*1e8)).toString(16)}"
      return id

    createTodo:(todo) ->
      todoDestroyButton = document.createElement("button")
      todoDestroyButton.classList.add("destroy")

      todoLabel = document.createElement("label")
      todoLabel.textContent = todo.text

      checkbox = document.createElement("input")
      checkbox.classList.add("toggle")
      checkbox.type = "checkbox"
      checkbox.checked = todo.complete

      newTodo = document.createElement('li')
      newTodo.id = todo.id

      if todo.complete then newTodo.classList.add("completed")

      newTodo.append(checkbox, todoLabel, todoDestroyButton)

      @list.appendChild(newTodo)

    addTodo: (todoText) ->
      id  = @_generateId()
      todo =
        id: id,
        text: todoText.value,
        complete: false

      if @mode != 'completed'
        @createTodo(todo)

      @todos.push(todo)

    render: (todos) ->
      @list.removeChild(@list.firstChild) while @list.firstChild

      for todo in todos
        @createTodo(todo)

    delete: (id) ->
      todo = document.getElementById(id)

      @list.removeChild(todo)
      res = []

      for el in @todos
        if id != el.id
          res.push(el)

      @todos = res

    complete: (id) ->
      todo = document.getElementById(id)
      res = []

      for el in @todos
        if id == el.id
          todo.children[0].checked = !el.complete
          todo.classList.toggle('completed')
          checkedTodo = {el..., complete: !el.complete}

          res.push(checkedTodo)
        else
          res.push(el)

      @todos = res

      if @mode != 'all' then @filter(@mode, @todos)

    filter: (type) ->
      @mode = type

      switch  type
        when 'all'
          @render(@todos)

        when 'completed'
          res = []

          for todo in @todos
            if todo.complete
              res.push(todo)

          @render(res)

        when 'active'
          res = []

          for todo in @todos
            unless todo.complete
              res.push(todo)

          @render(res)

    completeAll: () ->
      res = []
      for todo in @todos
        el = document.getElementById(todo.id)

        unless todo.complete and el
          el.children[0].checked = !el.complete
          el.classList.toggle('completed')
          checkedTodo = {todo..., complete: !todo.complete}
          res.push(checkedTodo)
        else
          res.push(todo)

      @todos = res

      if @mode == "active" then @filter(@mode, @todos)

    clearCompleted: () ->
      res = []

      for todo in @todos
        el = document.getElementById(todo.id)

        unless todo.complete
          res.push(todo)
        else if el
          @list.removeChild(el)
      @todos = res
