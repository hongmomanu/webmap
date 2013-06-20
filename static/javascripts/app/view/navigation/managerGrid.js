/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-20
 * Time: 下午5:37
 * To change this template use File | Settings | File Templates.
 */

/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.navigation.managerGrid' ,{
    extend: 'Ext.grid.Panel',
    alias : 'widget.managergrid',
    cls:'navigation-grid',
    requires: [

    ],
    initComponent: function() {
        Ext.apply(this, {
            border: false,

            hideHeaders:true,
            columns: [


                {header: 'Lable', dataIndex: 'label',flex:1,renderer:this.formatLable}

            ],
            flex: 1,
            store: 'Managers'


        });
        this.callParent(arguments);
        // store singleton selection model instance
        CF.view.navigation.magagerGrid.selectionModel = this.getSelectionModel();

    },
    formatLable:function(value, p, record) {
        return Ext.String.format('<div class="navitem-div"><span class="author">{0}</span></div>', value);
    }
});
