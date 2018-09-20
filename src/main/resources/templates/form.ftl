<!DOCTYPE html>
<html manifest="offline.appcache">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <title>Sistema de Encuestas PUCMM</title>

    <link rel="stylesheet" href="css/demo.css">
    <link rel="stylesheet" href="css/form-mini.css">
    <script src="js/jquery-3.3.1.slim.js"></script>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="js/bootstrap.min.js"></script>
    <style>
        body {font-family: Arial, Helvetica, sans-serif;}

        /* The Modal (background) */
        .modal {
            display: none; /* Hidden by default */
            position: fixed; /* Stay in place */
            z-index: 1; /* Sit on top */
            padding-top: 100px; /* Location of the box */
            left: 0;
            top: 0;
            width: 100%; /* Full width */
            height: 100%; /* Full height */
            overflow: auto; /* Enable scroll if needed */
            background-color: rgb(0,0,0); /* Fallback color */
            background-color: rgba(0,0,0,0.4); /* Black w/ opacity */
        }

        /* Modal Content */
        .modal-content {
            background-color: #fefefe;
            margin: auto;
            padding: 20px;
            border: 1px solid #888;
            width: 80%;
        }

        /* The Close Button */
        .close {
            color: #aaaaaa;
            float: right;
            font-size: 28px;
            font-weight: bold;
        }

        .close:hover,
        .close:focus {
            color: #000;
            text-decoration: none;
            cursor: pointer;
        }
    </style>

    <script>
        var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB

        var dataBase = indexedDB.open("encuestasPUCMM", 1);

        dataBase.onupgradeneeded = function (e) {

            active = dataBase.result;


            var encuestas = active.createObjectStore("encuestas", { keyPath : 'id', autoIncrement : true });

            //creando los indices. (Dado por el nombre, campo y opciones)
            encuestas.createIndex('ind_id', 'id', {unique : false});

        };

        //El evento que se dispara una vez, lo
        dataBase.onsuccess = function (e) {
            console.log('Proceso ejecutado de forma correctamente');
        };

        dataBase.onerror = function (e) {
            console.error('Error en el proceso: '+e.target.errorCode);
        };

        function hayTabla(encuestaList) {
            //creando la tabla...
            var tabla = document.createElement("table");
            tabla.className = "table";
            var filaTabla = tabla.insertRow();
            filaTabla.style.backgroundColor = "lightblue";
            filaTabla.insertCell().textContent = "Nombre";
            filaTabla.insertCell().textContent = "Sector";
            filaTabla.insertCell().textContent = "Nivel";

            for (var key in encuestaList) {
                //
                filaTabla = tabla.insertRow();
                filaTabla.insertCell().textContent = ""+encuestaList[key].nombre;
                filaTabla.insertCell().textContent = ""+encuestaList[key].sector;
                filaTabla.insertCell().textContent = ""+encuestaList[key].nivel;
            }

            document.getElementById("encuestasTabla").innerHTML="";
            document.getElementById("encuestasTabla").appendChild(tabla);
        }

        function encuestasListado() {
            //por defecto si no lo indico el tipo de transacción será readonly
            var data = dataBase.result.transaction(["encuestas"]);
            var encuestas = data.objectStore("encuestas");
            var contador = 0;
            var encuestaDatos=[];

            //abriendo el cursor.
            encuestas.openCursor().onsuccess=function(e) {
                //recuperando la posicion del cursor
                var cursor = e.target.result;
                if(cursor){
                    contador++;
                    //recuperando el objeto.
                    encuestaDatos.push(cursor.value);

                    //Función que permite seguir recorriendo el cursor.
                    cursor.continue();

                }else {
                    console.log("La cantidad de registros recuperados es: "+contador);
                }
            };

            //Una vez que se realiza la operación llamo la impresión.
            data.oncomplete = function () {
                hayTabla(encuestaDatos);
            }

        }


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
                modal.style.display = "none";
            };

            //abriendo la colección de datos que estaremos usando.
            var encuestas = transaccion.objectStore("encuestas");

            //Para agregar se puede usar add o put, el add requiere que no exista
            // el objeto.
            var request = encuestas.put({
                nombre: document.querySelector("#nombre").value,
                sector: document.querySelector("#sector").value,
                nivel: document.querySelector("#nivel").value,
                //latidud: document.querySelector("#latitud").value,
                //longitud: document.querySelector("#longitud").value


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


        <button id="myBtn">Agregar Encuesta</button>

        <!-- The Modal -->
        <div id="myModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <div class="form-mini" >

            <div class="form-row">
                <input type="text" id="nombre" placeholder="Nombre">
            </div>

            <div class="form-row">
                <input type="text" id="sector" placeholder="Sector">
            </div>

            <div class="form-row">
                <label>
                    <select id="nivel">
                        <option>Nivel Escolar...</option>
                        <option>Basico</option>
                        <option>Medio</option>
                        <option>Grado Universitario</option>
                        <option>Postgrado</option>
                        <option>Doctorado</option>
                    </select>
                </label>
            </div>



            <div class="form-row form-last-row">
                <button onclick="agregarEncuesta()">Crear Encuesta</button>
            </div>

        </div>
    </div>

    </div>
    </div>

<button onclick="encuestasListado()">Lista de Encuestas</button>
    <table id="encuestasTabla" class="table">

    </table>


</div>

<script>
    // Get the modal
    var modal = document.getElementById('myModal');

    // Get the button that opens the modal
    var btn = document.getElementById("myBtn");

    // Get the <span> element that closes the modal
    var span = document.getElementsByClassName("close")[0];

    // When the user clicks the button, open the modal
    btn.onclick = function() {
        modal.style.display = "block";
    }

    // When the user clicks on <span> (x), close the modal
    span.onclick = function() {
        modal.style.display = "none";
    }

    // When the user clicks anywhere outside of the modal, close it
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
</script>

</body>

</html>
