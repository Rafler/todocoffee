define './TodoServices',
[],
() ->
  class TodoServices
    constructor: () ->
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

      return todo

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

        list.appendChild(newTodo)

    delete: (id, todos) ->
      todo = document.getElementById(id)
      @list.removeChild(todo)

      res = for el in todos
        if id != el.id
          el
        else

      return res

    complete: (id, todos) ->
      todo = document.getElementById(id)

      res = for el in todos
        if id == el.id
          todo.children[0].checked = !el.complete
          todo.className = if !el.complete then "completed" else ""
          {el..., complete: !el.complete}
        else
          el

      if @mode != 'all'
        @filter(@mode, res)

      return res

    filter: (type, todos) ->
      @mode = type

      switch  type
        when 'all'
          @render(todos)
        when 'completed'
          res = for todo in todos
            if todo.complete
              todo
            else
          @render(res)
        when 'active'
          res = for todo in todos
            if !todo.complete
              todo
            else
          @render(res)

    completeAll: (todos) ->
      res = for todo in todos
        if not todo.complete and document.getElementById(todo.id)
          el = document.getElementById(todo.id)
          el.children[0].checked = !el.complete
          el.className = if !todo.complete then "completed" else ""
          {todo..., complete: !todo.complete}
        else
          todo

      if @mode == "active" then @filter(@mode, res)

      return res

    clearCompleted: (todos) ->
      res = []

      for todo in todos
        if not todo.complete
          res.push(todo)
        else if document.getElementById(todo.id)
          el = document.getElementById(todo.id)
          @list.removeChild(el)

      return res



