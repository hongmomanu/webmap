/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-20
 * Time: 下午5:39
 * To change this template use File | Settings | File Templates.
 */

Ext.define('CF.store.Managers', {
    extend: 'Ext.data.Store',
    model: 'CF.model.Manager',
    data: [
        {label: '地图设置',widget:'servertypespanel'},
        {label: '参数设置'}
    ]
});
