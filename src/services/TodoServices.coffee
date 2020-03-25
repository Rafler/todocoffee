define [],
() ->
  class TodoServices
    constructor: () ->
      @todos = []
      @list = document.getElementById('app-list')
      @queue = null
      @connected = false
      @mode = 'all'
      self = @

      @_initialiseListener(self)

      if window.navigator.onLine then @_initializeBC(self)

    _initializeBC: (self) ->
      @bc  = new BroadcastChannel('test_channel');
      @connected = true

      if @queue
        @bc.postMessage(@queue)
        @queue = null

      @bc.onmessage = (e) -> self._getMessage(e)

      @bc.onmessageerror = () -> self.connected = false

    _getMessage: (event) ->
      message = JSON.parse(event.data)

      if message.type == 'todos'
        todos = message.data
        @todos = todos

        @filter(@mode)
      else
        alert('Not correct message type')

    _createMessage: (type, data) ->
      message =
        type: type,
        data: data

      return JSON.stringify(message)

    _sentTodos: () ->
      message = @_createMessage('todos', @todos)
      console.log(@connected)

      if @connected
        @bc.postMessage(message)
      else
        @queue = message

    _generateId: () ->
      id = "f#{(~~(Math.random()*1e8)).toString(16)}"

      return id

    _createTodo:(todo) ->
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

    _checkBoxHandleClick: (element, todo, value) ->
      element.children[0].checked = value
      element.classList.toggle('completed')

      checkedTodo = {todo..., complete: value}

      return checkedTodo


    addTodo: (todoText) ->
      id  = @_generateId()

      todo =
        id: id,
        text: todoText.value,
        complete: false

      if @mode != 'completed'
        @_createTodo(todo)

      @todos.push(todo)
      @_sentTodos()

    _render: (todos) ->
      @list.removeChild(@list.firstChild) while @list.firstChild

      for todo in todos
        @_createTodo(todo)

    delete: (id) ->
      todo = document.getElementById(id)

      @list.removeChild(todo)
      res = []

      for el in @todos
        if id != el.id
          res.push(el)

      @todos = res
      @_sentTodos()

    complete: (id) ->
      el = document.getElementById(id)
      res = []

      for todo in @todos
        if id == todo.id
          checkedTodo =  @_checkBoxHandleClick(el, todo, !todo.complete)

          res.push(checkedTodo)
        else
          res.push(todo)

      @todos = res
      @_sentTodos()

      if @mode != 'all' then @filter(@mode, @todos)

    filter: (type) ->
      @mode = type

      switch type
        when 'all'
          @_render(@todos)

        when 'completed'
          res = []

          for todo in @todos
            if todo.complete
              res.push(todo)

          @_render(res)

        when 'active'
          res = []

          for todo in @todos
            unless todo.complete
              res.push(todo)

          @_render(res)

    completeAll: () ->
      res = []

      for todo in @todos
        el = document.getElementById(todo.id)

        if not todo.complete and el
          checkedTodo =  @_checkBoxHandleClick(el, todo, !todo.complete)

          res.push(checkedTodo)
        else
          res.push(todo)

      @todos = res
      @_sentTodos()

      if @mode == "active" then @filter(@mode, @todos)

    clearCompleted: () ->
      res = []

      for todo in @todos
        el = document.getElementById(todo.id)

        if el then @list.removeChild(el) else res.push(todo)

      @todos = res
      @_sentTodos()

    _initialiseListener: (self) ->
      window.addEventListener("online",  () -> self._initializeBC(self))
