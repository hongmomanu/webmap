/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-7-23
 * Time: 下午4:10
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.model.PatternProcess', {
    extend: 'Ext.data.Model',
    fields: [
        {
            name: 'mission',
            type:'string'
        },{
            name: 'process',
            type:'string'
        }
    ]
});
