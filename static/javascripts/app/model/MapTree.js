Ext.define('CF.model.MapTree', {
	extend: 'Ext.data.Model',
    fields: [
        
        { name: 'text', type: 'string', mapping: 'text' },
        { name: 'leaf', type: 'boolean', mapping: 'leaf' },
        { name: 'expanded', defaultValue: true },
        { name: 'updatetime',type: 'string', mapping: 'updatetime' }
    ]

})
