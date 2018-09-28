<!DOCTYPE html>
<html manifest="offline.appcache">

<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />

    <title>Sistema de Encuestas PUCMM</title>

    <link rel="stylesheet" href="css/demo.css">
    <link rel="stylesheet" href="css/form-mini.css">
    <script src="js/jquery-3.3.1.slim.js"></script>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="https://maps.googleapis.com/maps/api/js?key=AIzaSyA_dBRkreJdC4jm80OJW6eR_rSFFQcArLI&language=ja&region=JP">
    </script>
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


</head>

<body>
<header>
    <h1>Sistema de Encuestas</h1>
</header>


<div class="main-content">

    <!-- You only need this form and the form-mini.css -->

    <div class="form-mini-container">


        <button id="myBtn" class="btn btn-success">Agregar Encuesta</button>
        <button class="btn btn-primary btn-xs my-xs-btn" type="button" id="myBtnEditar">
        <span class="glyphicon glyphicon-pencil"></span> Editar
        </button>
        <button class="btn btn-danger btn-xs my-xs-btn" type="button" id="btnBorrar">
        <span class="glyphicon glyphicon-alert"></span>
        Borrar</button>
        <!-- The Modal -->
        <input type="hidden" id="lati" >
        <input type="hidden" id="long" >

        <div id="myModal" class="modal">
    <div class="modal-content">
        <span  class="close">&times;</span>
        <div class="form-mini" >

            <div class="form-row">
                <input type="text" id="nombre" placeholder="Nombre" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;">
            </div>

            <div class="form-row">
                <input type="text" id="sector" placeholder="Sector" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;">
            </div>


            <div class="form-row">
                <label>
                    <select id="nivel" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;">
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


<button id="btnMap" class="btn btn-primary">Mapa</button>
    <div id="myModalMap" class="modal">
        <div class="modal-content">
            <span class="closeMap">&times;</span>
            <div id="map" style="min-height: 200px; min-width: 200px; margin: auto; max-height: 300px; max-width: 400px;">
            </div>
            </div>
    </div>

    <div id="myModalBorrar" class="modal">
        <div class="modal-content">
            <div class="form-mini" >
            <span class="closeBorrar">&times;</span>
            <div class="form-row">
                <input type="text" id="idBorrar" placeholder="Id de la Encuesta">
            </div>
            <div class="form-row form-last-row">
                <a class="text-danger">UNA VEZ BORRADA LA ENCUESTA NO SE PUEDE RECUPERAR</a>
                <button class="btn-danger" onclick="borrarEncuesta()">Borrar Encuesta</button>
            </div>
            </div>
        </div>
        </div>

    <div id="myModalEditar" class="modal">
        <div class="modal-content">
            <div class="form-mini" >
                <span class="closeEditar">&times;</span>
                <div class="form-row">
                    <label for="idEditar">ID:</label><input type="text" id="idEditar" style="min-height: 30px; min-width: 70px; margin: auto; max-height: 30px; max-width: 80px;">

                </div><button class="btn btn-danger btn-xs my-xs-btn" type="button" id="btnBuscar" onclick="buscarEncuesta()">
                <span class="glyphicon glyphicon-search"></span>
                Buscar</button>

                <div class="form-row">
                    <label for="nombreEditar">Nombre:</label><input type="text" id="nombreEditar" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;" disabled>
                </div>

                <div class="form-row">
                    <label for="sectorEditar">Sector</label><input type="text" id="sectorEditar" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;" disabled>
                </div>

                <div class="form-row">
                    <label>
                        <select id="nivelEditar" style="min-height: 42px; min-width: 172px; margin: auto; max-height: 42px; max-width: 180px;" disabled>
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
                    <button class="btn-danger" onclick="editarEncuesta()">Editar Encuesta</button>
                </div>
            </div>
        </div>
    </div>

    <table id="encuestasTabla" class="table">

    </table>


</div>

<script>
    var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

    var long;
    var lati;
    var locati = {};

    var loc = {};
    var geoSettings = {
        enableHighAccuracy: true,
        timeout: 6000,
        maximumAge: 0
    };

    navigator.geolocation.getCurrentPosition(function(pos){
        var coor = pos.coords;
        lati = coor.latitude;
        long = coor.longitude;
    }, function(){
        alert("No tiene permiso");
    }, geoSettings);


    var dataBase = indexedDB.open("encuestasPUCMM", 1);

    dataBase.onupgradeneeded = function (e) {

        active = dataBase.result;


        var encuestas = active.createObjectStore("encuestas", { keyPath : 'id', autoIncrement : true });

        encuestas.createIndex('ind_id', 'id', {unique : false});

    };

    dataBase.onsuccess = function (e) {
        console.log('Proceso ejecutado de forma correctamente');

        encuestasListado();
    };

    dataBase.onerror = function (e) {
        console.error('Error en el proceso: '+e.target.errorCode);
    };

    window.onload = function() {
        encuestasListado();
    };

    function hayTabla(encuestaList) {
        var tabla = document.createElement("table");
        tabla.className = "table";
        var row = tabla.insertRow();
        row.style.backgroundColor = "lightblue";
        row.insertCell().textContent = "ID";
        row.insertCell().textContent = "Nombre";
        row.insertCell().textContent = "Sector";
        row.insertCell().textContent = "Nivel";

        for (var key in encuestaList) {

            row = tabla.insertRow();
            row.insertCell().textContent = ""+encuestaList[key].id;
            row.insertCell().textContent = ""+encuestaList[key].nombre;
            row.insertCell().textContent = ""+encuestaList[key].sector;
            row.insertCell().textContent = ""+encuestaList[key].nivel;



        }

        document.getElementById("encuestasTabla").innerHTML="";
        document.getElementById("encuestasTabla").appendChild(tabla);
    }

    function encuestasListado() {

        var data = dataBase.result.transaction(["encuestas"]);
        var encuestas = data.objectStore("encuestas");
        var contador = 0;
        var encuestaDatos=[];


        encuestas.openCursor().onsuccess=function(e) {
            var cursor = e.target.result;
            if(cursor){
                contador++;

                encuestaDatos.push(cursor.value);


                cursor.continue();

            }else {
                console.log("La cantidad de registros recuperados es: "+contador);
            }
        };

        data.oncomplete = function () {

            try {
                var map = new google.maps.Map(document.getElementById('map'), {
                    zoom: 10,
                    center: new google.maps.LatLng(19.44, -70.677),
                    mapTypeId: google.maps.MapTypeId.ROADMAP
                });

                var infowindow = new google.maps.InfoWindow();
                var marker, i = 0;
                for (var key in encuestaDatos) {

                    marker = new google.maps.Marker({
                        position: new google.maps.LatLng(parseFloat(encuestaDatos[key].latitud), parseFloat(encuestaDatos[key].longitud)),
                        map: map
                    });

                    google.maps.event.addListener(marker, 'click', (function(marker, i) {
                        return function() {
                            infowindow.setContent(encuestaDatos[key].nombre);
                            infowindow.open(map, marker);
                        }
                    })(marker, i));
                    i = i +1;
                }
                hayTabla(encuestaDatos);
                return encuestaDatos;

            } catch (e) {
                hayTabla(encuestaDatos);
                console.log("El mapa no esta disponible offline")  ;                   // "@Scratchpad/2:2:7\n"
            }



        }

    }



    function agregarEncuesta() {
        var db = dataBase.result;
        var transaccion = db.transaction(["encuestas"], "readwrite");

        transaccion.onerror = function (e) {
            alert(request.error.name + '\n\n' + request.error.message);
        };

        transaccion.oncomplete = function (e) {
            document.querySelector("#nombre").value = '';
            modal.style.display = "none";
            encuestasListado();
        };

        var encuestas = transaccion.objectStore("encuestas");


        var request = encuestas.put({
            nombre: document.querySelector("#nombre").value,
            sector: document.querySelector("#sector").value,
            nivel: document.querySelector("#nivel").value,
            latitud: lati,
            longitud: long



        });


        request.onerror = function (e) {
            var mensaje = "Error: "+e.target.errorCode;
            console.error(mensaje);
            alert(mensaje)
        };

    }

    function borrarEncuesta() {

        var idEncuesta = parseInt(document.querySelector("#idBorrar").value);

        var data = dataBase.result.transaction(["encuestas"], "readwrite");
        var encuestas = data.objectStore("encuestas");

        encuestas.delete(idEncuesta).onsuccess = function (e) {
            modalBorrar.style.display = "none";
            encuestasListado();
        };
        encuestas.delete(idEncuesta).onerror = function (e) {
            console.log("Error al borrar")
        };
    }


    function buscarEncuesta() {
        var idEncuesta = parseInt(document.querySelector("#idEditar").value);



        var data = dataBase.result.transaction(["encuestas"], "readwrite");
        var encuestas = data.objectStore("encuestas");


        encuestas.get(idEncuesta).onsuccess = function(e) {

            var resultado = e.target.result;

            if(resultado !== undefined){

                document.getElementById('nombreEditar').value = resultado.nombre;
                document.getElementById("sectorEditar").value = resultado.sector;
                document.getElementById("nivelEditar").value = resultado.nivel;
                document.getElementById("nombreEditar").disabled = false;
                document.getElementById("sectorEditar").disabled = false;
                document.getElementById("nivelEditar").disabled = false;


            }else{
                console.log("Encuesta no encontrada.");
            }
        };

    }
    function editarEncuesta() {

        //recuperando la matricula.
        var idEncuesta = parseInt(document.querySelector("#idEditar").value);


        var nombre = document.querySelector("#nombreEditar").value;
        var sector = document.querySelector("#sectorEditar").value;
        var nivel = document.querySelector("#nivelEditar").value;

        //abriendo la transacción en modo escritura.
        var data = dataBase.result.transaction(["encuestas"],"readwrite");
        var encuestas = data.objectStore("encuestas");

        //buscando estudiante por la referencia al key.
        encuestas.get(idEncuesta).onsuccess = function(e) {

            var resultado = e.target.result;

            if(resultado !== undefined){

                resultado.nombre = nombre;
                resultado.sector = sector;
                resultado.nivel = nivel;

                var solicitudUpdate = encuestas.put(resultado);

                solicitudUpdate.onsuccess = function (e) {
                    modalEditar.style.display = "none"
                    encuestasListado();
                };

                solicitudUpdate.onerror = function (e) {
                    console.error("Error Datos Actualizados.");
                }

            }else{
                console.log("Encuesta no encontrada");
            }
        };


    }



</script>
<script>


    var modal = document.getElementById('myModal');

    var btn = document.getElementById("myBtn");

    var span = document.getElementsByClassName("close")[0];


    btn.onclick = function() {
        modal.style.display = "block";
    };

    span.onclick = function() {
        modal.style.display = "none";
    };

    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    };

    var modalEditar = document.getElementById('myModalEditar');

    var btnEditar = document.getElementById("myBtnEditar");

    var spanEditar = document.getElementsByClassName("closeEditar")[0];


    btnEditar.onclick = function() {
        modalEditar.style.display = "block";
    };

    spanEditar.onclick = function() {
        modalEditar.style.display = "none";
    };

    window.onclick = function(event) {
        if (event.target == modalEditar) {
            modalEditar.style.display = "none";
        }
    };


    var modalBorrar = document.getElementById('myModalBorrar');

    var btnBorrar = document.getElementById("btnBorrar");

    var spanBorrar = document.getElementsByClassName("closeBorrar")[0];

    btnBorrar.onclick = function() {
        modalBorrar.style.display = "block";
    };

    spanBorrar.onclick = function() {
        modalBorrar.style.display = "none";
    };

    window.onclick = function(event) {
        if (event.target == modalBorrar) {
            modalBorrar.style.display = "none";
        }
    };

    var modalMap = document.getElementById('myModalMap');

    var btnMap = document.getElementById("btnMap");

    var spanMap = document.getElementsByClassName("closeMap")[0];

    btnMap.onclick = function() {
        modalMap.style.display = "block";
    };

    spanMap.onclick = function() {
        modalMap.style.display = "none";
    };

    window.onclick = function(event) {
        if (event.target == modalMap) {
            modalMap.style.display = "none";
        }
    };


    var locations = [
        ['Cronulla Beach', -34.028249, 151.157507, 3],
        ['Manly Beach', -33.80010128657071, 151.28747820854187, 2],
        ['Maroubra Beach', -33.950198, 151.259302, 1]
    ];


</script>


</body>

</html>
