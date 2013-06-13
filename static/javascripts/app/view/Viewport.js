/**
 * The main application viewport, which displays the whole application
 * @extends Ext.Viewport
 */
Ext.define('CF.view.Viewport', {
    extend: 'Ext.Viewport',
    layout: 'fit',

    requires: [
        'Ext.layout.container.Border',
        'Ext.layout.container.Accordion',
        'Ext.tab.*',
        'Ext.resizer.Splitter',
        'CF.view.Header',
        'CF.view.Map',
        'CF.view.summit.Chart',
        'CF.view.navigation.missionGrid',
        'CF.view.summit.Grid'
    ],

    initComponent: function() {
        var me = this;

        Ext.apply(me, {
            items: [{
                xtype: 'panel',
                border: false,
                layout: 'border',
                dockedItems: [
                    Ext.create('CF.view.Header')
                ],
                items: [
                    {
                        region: 'west',
                        id: 'west-panel', // see Ext.getCmp() below
                        title: '导航栏',
                        split: true,
                        width: 200,
                        minWidth: 175,
                        maxWidth: 400,
                        collapsible: true,
                        animCollapse: true,
                        margins: '0 0 0 5',
                        layout: 'accordion',
                        items: [{
                            html: '<p>Some settings in here.</p>',
                            title: 'Navigation',
                            iconCls: 'nav' // see the HEAD section for style used
                        }, {
                            title: 'Settings',
                            items:[
                                {
                                   xtype:'missiongrid'
                                }
                            ],

                            iconCls: 'settings'
                        }, {
                            title: 'Information',
                            html: '<p>Some info in here.</p>',
                            iconCls: 'info'
                        }]
                    },

                    Ext.create('Ext.tab.Panel', {
                        region: 'center', // a center region is ALWAYS required for border layout
                        deferredRender: false,
                        id: 'mainContent-panel',
                        activeTab: 0,     // first tab initially active
                        items: [
                            {
                                xtype: 'cf_mappanel',
                                title: '地图浏览',
                                autoScroll: true
                            }]
                    })]
            }]
        });

        me.callParent(arguments);
    }
});