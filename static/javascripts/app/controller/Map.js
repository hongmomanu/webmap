/**
 * Map controller
 * Used to manage map layers and showing their related views
 */
Ext.define('CF.controller.Map', {
    extend: 'Ext.app.Controller',

    models: ['Summit'],//,'Mission','Manager','MapTree'
    stores: ['Summits'],//,'Missions','Managers','MapTrees','MapServers','MapserverTrees'

    refs: [
        {ref: 'summitChart', selector: 'summitchart'},
        {ref: 'summitGrid', selector: 'summitgrid'}
    ],

    init: function() {
        var me = this;

					 var hideMask = function () {
							Ext.get('loading').remove();
							Ext.fly('loading-mask').animate({
							opacity:0,
							remove:true,
							callback: function(){}
						});
					};
					
					removejscssfile("bootstrap.css","css");

        Ext.defer(hideMask, 250);
        
        me.getSummitsStore().on({
            scope: me,
            load : me.onSummitsStoreLoad
        });

        this.control({
            'cf_mappanel': {
                'beforerender': this.onMapPanelBeforeRender
            }
        }, this);
    },

    onMapPanelBeforeRender: function(mapPanel, options) {
        var me = this;

        var layers = [];

        // OpenLayers object creating
        var wms = new OpenLayers.Layer.WMS(
            "OpenLayers WMS",
            "http://vmap0.tiles.osgeo.org/wms/vmap0?",
            {layers: 'basic'}
        );
        var tianditu_layer=new OpenLayers.Layer.TiandituLayer(1,
            //mapserverUrl+'?mapower='+mapower+"&maplabel="+maplabel
            "http://127.0.0.1/gnc/1"
            ,{
                //mapType:"tian",
                //id:"layerid",
                isBaseLayer:true,
                topLevel: 1,
                bottomLevel: 20,
                maxExtent: (new OpenLayers.Bounds(-180, -90, 180, 90)).transform(new OpenLayers.Projection("EPSG:4326"),mapPanel.map.getProjectionObject())
                //mirrorUrls:mirrorUrls
            });

        layers.push(tianditu_layer);
        //layers.push(wms);

        // create vector layer
        var context = {
            getColor: function(feature) {
                if (feature.attributes.elevation < 2000) {
                    return 'green';
                }
                if (feature.attributes.elevation < 2300) {
                    return 'orange';
                }
                return 'red';
            }
        };
        var template = {
            cursor: "pointer",
            fillOpacity: 0.5,
            fillColor: "${getColor}",
            pointRadius: 5,
            strokeWidth: 1,
            strokeOpacity: 1,
            strokeColor: "${getColor}",
            graphicName: "triangle"
        };
        var style = new OpenLayers.Style(template, {context: context});
        var vecLayer = new OpenLayers.Layer.Vector("vector", {
            styleMap: new OpenLayers.StyleMap({
                'default': style
            }),
            protocol: new OpenLayers.Protocol.HTTP({
                url: "static/javascripts/data/summits.json",
                format: new OpenLayers.Format.GeoJSON()
            }),
            strategies: [new OpenLayers.Strategy.Fixed()]
        });
        layers.push(vecLayer);

        // manually bind store to layer
        me.getSummitsStore().bind(vecLayer);

        mapPanel.map.addLayers(layers);

        // some more controls
        mapPanel.map.addControls([new OpenLayers.Control.DragFeature(vecLayer, {
            autoActivate: true,
            onComplete: function(feature, px) {
                var store = me.getSummitsStore();
                store.fireEvent('update', store, store.getByFeature(feature));
            }
        })]);

        // for dev purpose
        map = mapPanel.map;
        mapPanel = mapPanel;

        var lon = 120.144;
        var lat = 30.246;
        var zoom = 12;
        var center= new OpenLayers.LonLat(lon, lat);
        map.setCenter(center, zoom);

    },

    onLaunch: function() {
        var me = this;

        // for dev purpose
        ctrl = this;
    },

    onSummitsStoreLoad: function(store, records) {
        // do custom stuff on summits load if you want, for example here we
        // zoom to summits extent
        var lon = 120.144;
        var lat = 30.246;
        var zoom = 12;
        var center= new OpenLayers.LonLat(lon, lat);
        store.layer.map.setCenter(center, zoom);
        var dataExtent = store.layer.getDataExtent();
        if (dataExtent) {
            //store.layer.map.zoomToExtent(dataExtent);
        }
    }
});
