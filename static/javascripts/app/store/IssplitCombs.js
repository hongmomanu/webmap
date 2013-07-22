/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-7-19
 * Time: 上午10:14
 * To change this template use File | Settings | File Templates.
 */

/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:56
 * To change this template use File | Settings | File Templates.
 */

/**
 * The store used for SpaceTables
 */
Ext.define('CF.store.IssplitCombs', {
    extend: 'Ext.data.Store',
    model: 'CF.model.IssplitComb',
    alias : 'widget.issplitcombs',
    data: [
        {text:"已分解",value:false},
        {text:"重新分解",value:true}
    ]
});

