<!DOCTYPE html>
<html manifest="offline.appcache">

<head>

    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />

    <title>Sistema de Encuestas PUCMM</title>

    <link rel="stylesheet" href="css/demo.css">
    <link rel="stylesheet" href="css/form-mini.css">
    <script src="js/jquery-3.3.1.slim.js"></script>
    <script src="js/script.js"></script>
    <link rel="stylesheet" href="css/bootstrap.min.css">
    <script src="https://api-maps.yandex.ru/2.1/?lang=en_US" type="text/javascript"></script>
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


        <button id="myBtn" class="btn btn-success btn-xs my-xs-btn" type="button">
            <span class="glyphicon glyphicon-plus-sign"></span> Agregar Encuesta
        </button>
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


    <button id="btnMap" class="btn btn-default btn-xs my-xs-btn">
        <span class="glyphicon glyphicon-map-marker"></span>Mapa
    </button>
    <div id="myModalMap" class="modal">
        <div class="modal-content">
            <span class="close" id="closeMap">&times;</span>
            <div id="map" style="min-height: 200px; min-width: 200px; margin: auto; max-height: 300px; max-width: 400px;">
            </div>
        </div>
    </div>

    <div id="myModalBorrar" class="modal">
        <div class="modal-content">
            <div class="form-mini" >
                <span class="close" id="closeBorrar">&times;</span>
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
                <span class="close" id="closeEditar">&times;</span>
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

    var spanEditar = document.getElementById("closeEditar");


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

    var spanBorrar = document.getElementById("closeBorrar");

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

    var spanMap = document.getElementById("closeMap");

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

</script>


</body>

</html>
