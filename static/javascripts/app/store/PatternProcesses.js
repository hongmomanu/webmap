/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-7-23
 * Time: 下午4:07
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.store.PatternProcesses', {
    extend: 'Ext.data.Store',
    model: 'CF.model.PatternProcess',
    autoLoad:true,
    proxy:{
        type: 'ajax',
        url: '/static/javascripts/data/test.json'
    }

});