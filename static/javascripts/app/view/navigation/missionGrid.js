/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.navigation.missionGrid' ,{
    extend: 'Ext.grid.Panel',
    alias : 'widget.missiongrid',
    cls:'navigation-grid',
    requires: [
        'CF.view.mission.cachePanel'
    ],
    initComponent: function() {
        Ext.apply(this, {
            border: false,


            hideHeaders:true,
            columns: [


                {header: 'Lable', dataIndex: 'label',flex:1,renderer:this.formatLable}

            ],
            flex: 1,
            store: 'Missions'


        });
        this.callParent(arguments);
        // store singleton selection model instance
        CF.view.navigation.missionGrid.selectionModel = this.getSelectionModel();
    },
    formatLable:function(value, p, record) {
        return Ext.String.format('<div class="navitem-div"><span class="author">{0}</span></div>', value);
    }
});
