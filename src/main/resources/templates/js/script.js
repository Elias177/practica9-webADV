var indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB || window.msIndexedDB;

var long;
var lati;


var map = new ymaps.Map("map", {
    center: [19.44, -70.677],
    zoom: 7
});


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
    alert("No tiene permiso de localizacion");
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


            var place;
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


