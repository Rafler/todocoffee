define './TodoServices',
[],
() ->
  class TodoServices
    constructor: () ->
      @todos = []

      @list = document.getElementById('list')

      @queue = []

      @connected = false

      @mode = 'all'

      self = @

      @_initialiseListener(self)

      if window.navigator.onLine then @_initializeWS(self)

    _initializeWS: (self) ->
      path = 'wss://connect.websocket.in/v2/10?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6IjA1MGVmZTgzMzg5MGFlODg5ZDRhZWJmYjIyYWM3ODQ3NDljNGE2OWZmYTRlOTk0NWRkZDljMjMzODUyMjM5NGNlNTUzMDNmYjc1NDIxMWFmIn0.eyJhdWQiOiI4IiwianRpIjoiMDUwZWZlODMzODkwYWU4ODlkNGFlYmZiMjJhYzc4NDc0OWM0YTY5ZmZhNGU5OTQ1ZGRkOWMyMzM4NTIyMzk0Y2U1NTMwM2ZiNzU0MjExYWYiLCJpYXQiOjE1ODQ2MzQwNDMsIm5iZiI6MTU4NDYzNDA0MywiZXhwIjoxNjE2MTcwMDQzLCJzdWIiOiI3MDAiLCJzY29wZXMiOltdfQ.ugNIILM_sjSAbx7EK9PujMNtGNqGH74_f3cwdVmVMYMcH9Z81yy3YhhP5HrRVrkFoJ_V4XmmtM0nexqjzS8YXui8jeVFatM8rW5PwkPWzdVdU4eaCLQPz7y0e4o-f_yxvZcAk-Ek1fEChbJlJmGqLPztLnK7wXpvu90XPXdauUYRro0lVhvtYPHr6NdiOfzMw7MZDsZR2XGISKNCKoo-jY-kRQcNe0sOlRfDfQokYyWZJo4xdwidmnpwthK8RWzHrOCnn91K-RAPH9eCVnjbd97eWfJbAeNKg_5JW1L62pzRthjswiIHJ9R3IeOR4tkDUnluzngtRqABwPSjHRzFb6mj_7UevIpJ9U8AgIO6ngj8EGF0vJDE0tAQ7-tkOtUgn4ByghGagjjThX9eSLNMMgTZ0Ul1izLXZ2kwzYNCxx7EBP6o1jqrw-D4s-sUKtvomc8ZVLsa-Utp-42taAnQHnk_FFgG7lTnqTn6Jl71AM5m3agUAR46wj6-hDOKGJnI2-rlga0CmSOc77WZKlJFa4MMF-HA2ftp_C4pX-NB6zlhz8wIBFecWPDDrmP0bDZoyI-Jl7H7enkqo_kzWO8vH7XWO1pCFdR5k9J-0Ioj4UxrcK6-jDZzVgLyHy3WvMC5ihb9OBsgjlwvas35R9ncT72f2PnqR0GREnV0X-_h_Tc'

      @ws = new WebSocket path

      @ws.onmessage = (e) -> self._getMessage(e)

      @ws.onopen = () ->
        self.connected = true
        if self.queue.length > 0
          for message in self.queue
            @ws.send(message)

      @ws.onclose = () ->
        self.connected = false
        console.log(self.connected)

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

      if @connected
        @ws.send(message)
      else
        @queue.push(message)

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
      @_sentTodos()

      if @mode != 'all' then @filter(@mode, @todos)

    filter: (type) ->
      @mode = type

      switch  type
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

        unless todo.complete and el
          el.children[0].checked = !el.complete
          el.classList.toggle('completed')
          checkedTodo = {todo..., complete: !todo.complete}

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

        unless todo.complete
          res.push(todo)
        else if el
          @list.removeChild(el)

      @todos = res
      @_sentTodos()

    _initialiseListener: (self) ->
      window.addEventListener("online",  () -> self._initializeWS(self))
