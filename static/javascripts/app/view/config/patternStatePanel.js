/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-7-23
 * Time: 下午3:59
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.view.config.patternStatePanel' ,{
    extend: 'Ext.grid.Panel',
    alias : 'widget.patternstatepanel',
    cls:'navigation-grid',
    requires: [

    ],
    initComponent: function() {
        Ext.apply(this, {
            border: false,

            //hideHeaders:true,
            columns: [


                {header: '任务', dataIndex: 'mission'},
                {
                    xtype: 'gridcolumn',
                    //width: 110,
                    flex:1,
                    dataIndex: 'process',
                    text: '进度',
                    renderer: function (value, metaData, record) {
                        var id = Ext.id();
                        metaData.tdAttr = 'data-qtip="'+value*100+'%"';
                        Ext.defer(function () {
                            Ext.widget('progressbar', {
                                renderTo: id,
                                value:value,
                                //height:20,
                                width: 100,
                                text:value*100+'%'
                            });
                        }, 50);
                        return Ext.String.format('<div id="{0}"></div>', id); } }
            ],
            flex: 1,
            store: 'PatternProcesses'


        });
        this.callParent(arguments);
        // store singleton selection model instance
        CF.view.navigation.managerGrid.selectionModel = this.getSelectionModel();

    }
    /*,

    formatLable:function(value, p, record) {
        return Ext.String.format('<div class="navitem-div"><span class="author">{0}</span></div>', value);
    }*/
});
