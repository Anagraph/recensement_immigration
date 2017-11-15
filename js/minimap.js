var miniMap = L.map('miniMap', {
       center: [30, -5],
       zoom: 0,
       zoomControl: false,
       attributionControl :false
   });

   var customControl =  L.Control.extend({

     options: {
       position: 'topleft'
     },

     onAdd: function (miniMap) {
       var container = L.DomUtil.create('div', 'leaflet-bar leaflet-control leaflet-control-custom fa fa-undo fa-2x');
       container.style.border = '0px';
       container.style.color = 'rgb(255,255,255)';
       container.onclick = function(){
        resetHighlight()
       }

       return container;
     }
   });

   miniMap.addControl(new customControl());

/*
   L.control.zoom({
       position: 'topright'
   }).addTo(miniMap);
*/
  // L.tileLayer('https://api.mapbox.com/styles/v1/clementg123/cj7t110a70sfy2snvbs73dnsk/tiles/256/{z}/{x}/{y}?access_token=pk.eyJ1IjoiY2xlbWVudGcxMjMiLCJhIjoiY2o2M3ZhODh3MWxwNDJxbnJnaGZxcWNoMiJ9.YroDniTcealGFJgHtQ2hDg').addTo(miniMap);


  function getColor(d) {
    return  d == "Afrique_autre"? 'rgb(0,107,16)':
             d =="Afrique_Est"? 'rgb(85,255,0)':
             d =="Afrique_Nord"? 'rgb(163,255,115)':
             d =="Afrique_Ouest"? 'rgb(185,255,0)':
             d =="Afrique_Sud"? 'rgb(0,115,76)':
             d =="Amerique_centrale"? 'rgb(0,92,230)':
             d =="Amerique_Nord"? 'rgb(171,255,253)':
             d =="Amerique_Sud"? 'rgb(115,178,255)':
             d =="Amerique_autre"? 'rgb(0,255,255)':
             d =="Antilles_Bermudes"? 'rgb(190,210,255)':
             d =="Asie_autre"? 'rgb(255,164,255)':
             d =="Asie_Est"? 'rgb(255,127,127)':
             d =="Asie_Ouest_centrale_Moyen_Orient"? 'rgb(115,0,0)':
             d =="Asie_Sud"? 'rgb(255,0,0)':
             d =="Asie_Sud_Est"? 'rgb(255,0,197)':
             d =="Canada"? 'rgb(192,192,192)':
             d =="Europe_autre"? 'rgb(215,215,158)':
             d =="Europe_Est"? 'rgb(255,159,65)':
             d =="Europe_Nord"? 'rgb(255,211,127)':
             d =="Europe_Ouest"? 'rgb(255,255,0)':
             d =="Europe_Sud"? 'rgb(255,221,41)':
             d =="Oceanie_et_autres"? 'rgb(115,76,0)':
                                 'rgb(192,192,192)';

};


function style(feature) {
      return {
          fillColor: getColor(feature.properties.Region),
          weight: 0.15,
          opacity: 1,
          color: 'white',
          fillOpacity: 0.7
      };
  }


function highlightFeature(e) {
    var layer = e.target;
      layer.setStyle({
        weight: 1,
        color: 'white',
        dashArray: '',
        fillOpacity: 0.7
    });

    if (!L.Browser.ie && !L.Browser.opera && !L.Browser.edge) {
        layer.bringToFront();
    };
  }

function resetHighlight() {

    miniMap.removeLayer(geojson);
    geojson= L.geoJson(worldRegions, { style: style,onEachFeature: onEachFeature}).addTo(miniMap);
    map.setFilter('immigration-3857geojson', null);
    map.setLayoutProperty('immigration-3857geojson', 'visibility', 'visible');
    map.setLayoutProperty('immigration-3857geojson_can', 'visibility', 'visible');
    document.getElementById("nonimmFa").className = "fa fa-dot-circle-o"
    document.getElementById("immFa").className = "fa fa-dot-circle-o"
  };

function miniMapFilter(e,color) {
  geojson.setStyle(
    function(feature) {
      if (feature == e ){
        return {
            fillColor: getColor(color),
        }
      }
    else {
      return {fillColor: 'rgb(192,192,192)'}}
    })
  };




  function resetgeoJson(e) {
      var layer = e.target;
        layer.setStyle({
          weight: 0.15,
          color: 'white',
          dashArray: '',
          fillOpacity: 0.7
      });}


function onEachFeature(feature, layer) {
  layer.bindTooltip(feature.properties.RegionTip.replace(/_/g,' '), {closeButton: false,sticky: true});
  layer.on({
        mouseover: highlightFeature,
        mouseout: resetgeoJson,
        click: returnMyRegion

/*
        function(feature){
            if (map.getLayer('immigration-3857geojson').filter) {
              //return console.log(map.getFilter('immigration-3857geojson'))
              return resetHighlight()
            }
            else {
              //return console.log(map.getFilter('immigration-3857geojson'))
              //map.setFilter('immigration-3857geojson', null);
              return returnMyRegion(feature)
            };
      }*/
        });
};

function onOcean(feature, layer) {
    layer.on({
      click: resetHighlight });
};
function oceanstyle(feature) {
      return {
          weight: 0,
          opacity: 0,
          fillOpacity: 0
      };
  }
var geojson;
geojson =  L.geoJson(worldRegions, { style: style,onEachFeature: onEachFeature}).addTo(miniMap);
var ocean ;
ocean = L.geoJson(ocean,{ style: oceanstyle ,onEachFeature: onOcean}).addTo(miniMap);
