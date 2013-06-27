Ext.define('CF.store.MapServers', {
    extend: 'Ext.data.Store',
    model: 'CF.model.MapTree',
    autoLoad:true,
    proxy: {
                    type: 'ajax',
                    url: 'maptree'
           },
});

