<!DOCTYPE html>
<html>

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Mini Form</title>

    <link rel="stylesheet" href="css/demo.css">
    <link rel="stylesheet" href="css/form-mini.css">

    <script>
        //dependiendo el navegador busco la referencia del objeto.
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

        //indicamos el nombre y la versión
        var dataBase = indexedDB.open("programacion_web", 1);


        //se ejecuta la primera vez que se crea la estructura
        //o se cambia la versión de la base de datos.
        dataBase.onupgradeneeded = function (e) {
            console.log("Creando la estructura de la tabla");

            //obteniendo la conexión activa
            active = dataBase.result;

            //creando la colección:
            //En este caso, la colección, tendrá un ID autogenerado.
            var encuestas = active.createObjectStore("encuestas", { keyPath : 'nombre', autoIncrement : false });

            //creando los indices. (Dado por el nombre, campo y opciones)
            encuestas.createIndex('nombre_ord', 'nombre', {unique : false});

        };

        //El evento que se dispara una vez, lo
        dataBase.onsuccess = function (e) {
            console.log('Proceso ejecutado de forma correctamente');
        };

        dataBase.onerror = function (e) {
            console.error('Error en el proceso: '+e.target.errorCode);
        };


        function agregarEncuesta() {
            var dbActiva = dataBase.result; //Nos retorna una referencia al IDBDatabase.

            //Para realizar una operación de agreagr, actualización o borrar.
            // Es necesario abrir una transacción e indicar un modo: readonly, readwrite y versionchange
            var transaccion = dbActiva.transaction(["encuestas"], "readwrite");

            //Manejando los errores.
            transaccion.onerror = function (e) {
                alert(request.error.name + '\n\n' + request.error.message);
            };

            transaccion.oncomplete = function (e) {
                document.querySelector("#nombre").value = '';
                alert('Objeto agregado correctamente');
            };

            //abriendo la colección de datos que estaremos usando.
            var encuestas = transaccion.objectStore("encuestas");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            var request = encuestas.put({
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                nivel: document.querySelector("#nivel").value,
                latidud: document.querySelector("#latitud").value,
                longitud: document.querySelector("#longitud").value


            });

            request.onerror = function (e) {
                var mensaje = "Error: "+e.target.errorCode;
                console.error(mensaje);
                alert(mensaje)
            };

        }

        </script>
</head>

<body>
<header>
    <h1>Sistema de Encuestas</h1>
</header>


<div class="main-content">

    <!-- You only need this form and the form-mini.css -->

    <div class="form-mini-container">


        <h1>Informacion</h1>

        <form class="form-mini" method="post" action="#">

            <div class="form-row">
                <input type="text" name="nombre" placeholder="Nombre">
            </div>

            <div class="form-row">
                <input type="email" name="sector" placeholder="Sector">
            </div>

            <div class="form-row">
                <label>
                    <select name="nivel">
                        <option>Nivel Escolar...</option>
                        <option>Basico</option>
                        <option>Medio</option>
                        <option>Grado Universitario</option>
                        <option>Postgrado</option>
                        <option>Doctorado</option>
                    </select>
                </label>
            </div>

            <input type="hidden" value="" id="lat" name="latitud">
            <input type="hidden" value="" id="lon" name="longitud">

            <div class="form-row form-last-row">
                <button type="submit">Submit Form</button>
            </div>

        </form>
    </div>


</div>

</body>

</html>
