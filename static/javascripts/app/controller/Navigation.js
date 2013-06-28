/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-27
 * Time: 下午5:16
 * To change this template use File | Settings | File Templates.
 */


/**
 * Map controller
 * Used to manage map layers and showing their related views
 */
Ext.define('CF.controller.Navigation', {
    extend: 'Ext.app.Controller',

    models: ['Mission','Manager','MapTree'],
    stores: ['Missions','Managers','MapTrees','MapServers','MapserverTrees'],

    /*refs: [
        {ref: 'summitChart', selector: 'summitchart'},
        {ref: 'summitGrid', selector: 'summitgrid'}
    ],*/
    views: [
        // 'user.List'
        'navigation.missionGrid',
        'navigation.managerGrid',
        'navigation.mapTree'
    ],

    init: function() {
        var me = this;

        this.control({
            'missiongrid':{
                itemclick: this.showContent
            },
            'managergrid':{
                itemclick: this.showContent
            }
        }, this);
    },

    showContent: function(grid, record) {
        //console.log('Double clicked on ' + record.get('label'));
        var label=record.get('label');
        var widgetname=record.get('widget');
        var tabs=Ext.getCmp('mainContent-panel');
        if(tabs.getComponent('tab'+label)){
            tabs.getComponent('tab'+label).show();
        }else{
            tabs.add({
                closable: true,
                id: 'tab'+label,
                xtype: widgetname,
                autoScroll: true,
                iconCls: 'tabs',
                title: label
            }).show();
        }


    } ,



    onLaunch: function() {
        var me = this;

        // for dev purpose
        //ctrl = this;
    }


});

