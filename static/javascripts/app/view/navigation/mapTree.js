/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.navigation.mapTree', {
    extend: 'Ext.tree.Panel',
    alias: 'widget.mapTree',
    requires: [
        'Ext.tree.*',
        'Ext.data.*'
    ],
    xtype: 'tree-reorder',


    //height: 400,
    //width: 350,
    //title: 'Files',
    rootVisible: false,
    border: false,
    useArrows: true,
    initComponent: function () {
        Ext.apply(this, {
           /** store: new Ext.data.TreeStore({
                proxy: {
                    type: 'ajax',
                    url: 'maptree'
                },
                root: {
                    text: '地图浏览',
                    id: 'src',
                    expanded: true
                },
                folderSort: true,
                sorters: [
                    {
                        property: 'text',
                        direction: 'ASC'
                    }
                ]
            }),**/
	    store:'MapTrees',
            viewConfig: {
                plugins: {
                    ptype: 'treeviewdragdrop',
                    containerScroll: true
                }
            }

        });
        this.callParent(arguments);
    }
});
