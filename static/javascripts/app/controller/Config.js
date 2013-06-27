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
Ext.define('CF.controller.Config', {
    extend: 'Ext.app.Controller',

    models: [],
    stores: [],

    /*refs: [
        {ref: 'summitChart', selector: 'summitchart'},
        {ref: 'summitGrid', selector: 'summitgrid'}
    ],*/

    init: function() {
        var me = this;

        this.control({
            'addnewmapwin':{
                //itemclick: this.showContent
            },
            'servertypespanel':{
                //itemclick: this.showContent
            }
        }, this);
    },

    onLaunch: function() {
        var me = this;

        // for dev purpose
        //ctrl = this;
    }


});

