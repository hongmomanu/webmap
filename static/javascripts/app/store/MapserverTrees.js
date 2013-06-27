

/**
 * The store used for maptree
 */
Ext.define('CF.store.MapserverTrees', {
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
  
    
});
