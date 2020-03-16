define './TodoServices',
[],
() ->
  class TodoServices
    constructor: () ->
      @todos = []
      @list = document.getElementById('list')
      @mode = 'active'

    addTodo: (todoText) ->
      todo =
        id: "f#{(~~(Math.random()*1e8)).toString(16)}",
        text: todoText.value,
        complete: false,

      if @mode != 'completed'
        todoDestroyButton = document.createElement("button")
        todoDestroyButton.className = "destroy"

        todoLabel = document.createElement("label")
        todoLabel.textContent = todo.text

        checkbox = document.createElement("input")
        checkbox.className = "toggle"
        checkbox.type = "checkbox"
        checkbox.checked = todo.complete

        newTodo = document.createElement('li')
        newTodo.id = todo.id
        newTodo.append(checkbox, todoLabel, todoDestroyButton)

        @list.appendChild(newTodo)

      @todos.push(todo)

    render: (todos) ->
      @list.removeChild(@list.firstChild) while @list.firstChild

      for todo in todos
        todoDestroyButton = document.createElement("button")
        todoDestroyButton.className = "destroy"

        todoLabel = document.createElement("label")
        todoLabel.textContent = todo.text

        checkbox = document.createElement("input")
        checkbox.className = "toggle"
        checkbox.type = "checkbox"
        checkbox.checked = todo.complete

        newTodo = document.createElement('li')
        newTodo.id = todo.id
        newTodo.className = if todo.complete then "completed" else ""
        newTodo.append(checkbox, todoLabel, todoDestroyButton)

        @list.appendChild(newTodo)

    delete: (id) ->
      todo = document.getElementById(id)
      @list.removeChild(todo)

      @todos = for el in @todos
        if id != el.id
          el
        else

    complete: (id) ->
      todo = document.getElementById(id)

      @todos = for el in @todos
        if id == el.id
          todo.children[0].checked = !el.complete
          todo.className = if !el.complete then "completed" else ""
          {el..., complete: !el.complete}
        else
          el

      if @mode != 'all'
        @filter(@mode, @todos)

    filter: (type) ->
      @mode = type
      switch  type
        when 'all'
          @render(@todos)

        when 'completed'
          res = for todo in @todos
            if todo.complete
              todo
            else
          @render(res)
        when 'active'
          res = for todo in @todos
            if !todo.complete
              todo
            else
          @render(res)

    completeAll: () ->
      @todos = for todo in @todos
        if not todo.complete and document.getElementById(todo.id)
          el = document.getElementById(todo.id)
          el.children[0].checked = !el.complete
          el.className = if !todo.complete then "completed" else ""
          {todo..., complete: !todo.complete}
        else
          todo

      if @mode == "active" then @filter(@mode, @todos)

    clearCompleted: () ->
      res = []
      for todo in @todos
        if not todo.complete
          res.push(todo)
        else if document.getElementById(todo.id)
          el = document.getElementById(todo.id)
          @list.removeChild(el)
      @todos = res





