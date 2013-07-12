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
Ext.define('CF.store.SpaceTables', {
    extend: 'Ext.data.Store',
    model: 'CF.model.SpaceTable',
    alias : 'widget.spacetables',
    data: [
    ]
});
