/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-27
 * Time: 下午2:58
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.view.config.addNewMapWin' ,{
    extend: 'Ext.window.Window',
    alias : 'widget.addnewmapwin',
    requires: [

    ],
    initComponent: function() {
        Ext.apply(this, {
            title: 'Hello',
            height: 200,
            width: 400,
            layout: 'fit',
            items: {  // Let's put an empty grid in just to illustrate fit layout
                xtype: 'grid',
                border: false,
                columns: [{header: 'World'}],                 // One header just for show. There's no data,
                store: Ext.create('Ext.data.ArrayStore', {}) // A dummy empty data store
            }

        });
        this.callParent(arguments);
    }

});