mapboxgl.accessToken = 'pk.eyJ1IjoiY29kZWxmIiwiYSI6InJqWGhtbTAifQ.JxxPn_cs-FbjD0UP7Lqovg';
var map = new mapboxgl.Map({
    id: "immigration-3857geojson",
    container: 'map', // container id
    style: 'mapbox://styles/codelf/cj9imc39oaz3o2so2hmvqc4nc', // stylesheet location
    center: [-73.6397, 45.5095], // starting position [lng, lat]
    zoom: 8, // starting zoom,
    attributionControl: false,
    hash:true
});

map.addControl(new mapboxgl.AttributionControl());

map.addControl(new MapboxGeocoder({
        accessToken: mapboxgl.accessToken,
        placeholder: 'Rechercher',
        country : 'Ca'
}), 'top-left');


map.addControl(new mapboxgl.NavigationControl());
map.addControl(new mapboxgl.FullscreenControl());
map.addControl

    // wait for map to load before adjusting it
map.on('load', function() {
    // make a pointer cursor
    map.getCanvas().style.cursor = 'default';
    //map.setFilter('immigration-3857geojson', null);
    //map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'none');
});

// Change the cursor to a pointer when the mouse is over the places layer.
map.on('mouseenter', 'immigration-3857geojson', function () {
    map.getCanvas().style.cursor = 'pointer';
});
// When a click event occurs on a feature in the places layer, open a popup at the
// location of the feature, with description HTML from its properties.
map.on('click', 'immigration-3857geojson', function (e) {
  var regionATraduire = e.features[0].properties.region
    new mapboxgl.Popup()
        .setLngLat(e.features[0].geometry.coordinates)
        .setHTML("Région d'origine : " + renamePoints(regionATraduire))
        .addTo(map);

});

function renamePoints (d){
  if (d == "Afrique_autre") { return 'Afrique Autres'}
   else if(d=="Afrique_Est"){return 'Afrique de l\'Est'}
   else if(d=="Afrique_Nord"){return 'Afrique du Nord'}
   else if(d=="Afrique_Ouest"){return 'Afrique de l\'Ouest'}
   else if(d=="Afrique_Sud"){return 'Afrique du Sud'}
   else if(d=="Amerique_centrale"){return 'Amérique Centrale'}
   else if(d=="Amerique_Nord"){return 'États-Unis'}
   else if(d=="Amerique_Sud"){return 'Amérique du Sud'}
   else if(d=="Amerique_autre"){return 'Amérique Autres'}
   else if(d=="Antilles_Bermudes"){return 'Antilles et Bermudes'}
   else if(d=="Asie_autre"){return 'Asie Autres'}
   else if(d=="Asie_Est"){return 'Asie de l\'Est'}
   else if(d=="Asie_Ouest_centrale_Moyen_Orient"){return 'Asie de l\'Ouest, Centrale et du Moyen-Orient'}
   else if(d=="Asie_Sud"){return 'Asie du Sud'}
   else if(d=="Asie_Sud_Est"){return 'Asie du Sud-Est'}
   else if(d=="Canada"){return 'Canada'}
   else if(d=="Europe_autre"){return 'Europe Autres'}
   else if(d=="Europe_Est"){return 'Europe de l\'Est'}
   else if(d=="Europe_Nord"){return 'Europe du Nord'}
   else if(d=="Europe_Ouest"){return 'Europe de l\'Ouest'}
   else if(d=="Europe_Sud"){return 'Europe du Sud'}
   else if(d=="Oceanie_et_autres"){return 'Autres'}
};


map.on('click', 'immigration-3857geojson_can', function (e) {
    new mapboxgl.Popup()
        .setLngLat(e.features[0].geometry.coordinates)
        .setHTML("Région d'origine : " + e.features[0].properties.region.replace(/_/g,' '))
        .addTo(map);

});

function returnMyRegion(e){
    var layer = e.target;
    var feature = layer.feature
    regionNameFiltered = layer.feature.properties.Region;
    //console.log(regionNameFiltered)

    if (regionNameFiltered == 'Canada') {

        map.setLayoutProperty('immigration-3857geojson', 'visibility', 'none');
        map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'visible');
        miniMapFilter(feature,regionNameFiltered);
        document.getElementById("immFa").className = "fa fa-circle-o"
        document.getElementById("nonimmFa").className = "fa fa-dot-circle-o"
        }

    else  {
          //return console.log(map.getFilter('immigration-3857geojson'))
          //map.setFilter('immigration-3857geojson', null);
        map.setLayoutProperty('immigration-3857geojson', 'visibility', 'visible');
      //  map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'visible');
        map.setFilter('immigration-3857geojson', ['in', 'region', regionNameFiltered]);
        miniMapFilter(feature,regionNameFiltered);
      //  document.getElementById("nonimmFa").className = "fa fa-circle-o"
        document.getElementById("immFa").className = "fa fa-dot-circle-o"
      };
  }

/*
map.on('mouseleave', 'immigration-3857geojson', function() {
         map.getCanvas().style.cursor = '';
         map.setFilter('immigration-3857geojson', ['has', 'region']);
       });
*/

       $(document).ready(function() {
         $('#imm').on('click', function() {
           change_imm_button();
           //console.log(map.getStyle().layers)
             });
         $('#nonimm').on('click', function() {
           change_nonimm_button();
         });
        });

    function change_imm_button() {

         var visibility = map.getLayoutProperty('immigration-3857geojson', 'visibility');
             if (visibility === 'visible') {
                 map.setLayoutProperty('immigration-3857geojson', 'visibility', 'none');
             } else {
                 map.setLayoutProperty('immigration-3857geojson', 'visibility', 'visible');

                 //map.setFilter('immigration-3857geojson', ["!=", 'region', ' Canada']);
             };

         var $el = $('#imm');
         $el.find('i.fa').toggleClass('fa-dot-circle-o  fa-circle-o');
         $el.toggleClass('filtre');
         //geojson.setStyle({fillColor: 'rgb(192,192,192)'});
       }

    function change_nonimm_button() {

         var visibility = map.getLayoutProperty('immigration-3857geojson_can', 'visibility');
             if (visibility === 'visible') {
                 map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'none');
             } else {
                 map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'visible');
             };

         var $el = $('#nonimm');
         $el.find('i.fa').toggleClass('fa-dot-circle-o fa-circle-o');
         $el.toggleClass('filtre');

       }
