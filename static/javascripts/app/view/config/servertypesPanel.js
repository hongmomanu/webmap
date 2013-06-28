/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.config.servertypesPanel' ,{
    extend: 'Ext.tree.Panel',
    alias : 'widget.servertypespanel',
    requires: [
        'CF.view.config.addNewMapWin'
    ],
    initComponent: function() {
        Ext.apply(this, {
        title: '服务资源管理',
        layout: 'fit',
        anchor: '100% 60%',
        useArrows: true,
        rootVisible: false,
        store: 'MapserverTrees',
        multiSelect: false,
        columns: [
            {
                xtype: 'treecolumn', //this is so we know which column will show the tree
                text: '资源名',
                flex: 2,
                sortable: true,
                dataIndex: 'text'
            },
            {
                text: '更新时间',
                flex: 1,
                dataIndex: 'updatetime',
                renderer: function (val) {
                    var time = new Date(val);
                    val = Ext.util.Format.date(time, 'Y-m-d H:i');
                    return val;
                },
                sortable: false
            }
        
        ],
         buttons: [
            {
           text: '新增地图',
           action:'add'

            },
             '->',
             {
            text: '删除',
            disabled:true,
           	handler: function () {
               
            }
             
             }
                
		   ]
        });
        this.callParent(arguments);
        // store singleton selection model instance
    }
});
