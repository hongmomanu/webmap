/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:56
 * To change this template use File | Settings | File Templates.
 */

/**
 * The store used for maptree
 */
Ext.define('CF.store.MapTrees', {
    extend: 'Ext.data.TreeStore',
    autoLoad:true,
    model: 'CF.model.MapTree',
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
    
});
