Instalaciones:
    Módulos:
        Express: manejo de backend, es un frame work de nodejs para manejar las url para el usuario
        Morgan: ver las peticiones del usuario
        Cors: recibir peticiones de otros servidores
        Dotenv: variables de entorno (contraseñas, etc)

Carpetas:
    controllers: funciones que se ejecutan cuando se llaman las rutas
    database: conexión a la base de datos
    routes: rutas de html

Algunos apuntes:
    llamar al get connection va a retornar un pool de conexiones, si esto se asigna a una variable, esta debe ser llamada con await