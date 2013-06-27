/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:56
 * To change this template use File | Settings | File Templates.
 */

/**
 * The store used for mission
 */
Ext.define('CF.store.Missions', {
    extend: 'Ext.data.Store',
    model: 'CF.model.Mission',
    data: [
        {label: '任务状态',widget:'missiongridpanel'},
        {label: '抓取切片',widget:'cachepanel'}
    ]
});
