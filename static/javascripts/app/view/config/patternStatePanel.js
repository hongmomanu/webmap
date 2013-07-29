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
            viewConfig: {
                trackOver: false,
                loadMask: false,
                scrollToTop: Ext.emptyFn,
                stripeRows: true
            },

            //view: new Ext.grid.GridView({ scrollToTop: Ext.emptyFn }),

            //hideHeaders:true,
            columns: [


                {header: '用户', dataIndex: 'user',width: 150},
                {header: '表名', dataIndex: 'table',width: 250},
                {header: '时间', dataIndex: 'time',width: 150, renderer: function (val, obj, record) {
                    var time = new Date(val);
                    val = Ext.util.Format.date(time, 'Y-m-d H:i');
                    return val;
                }},
                {header: '状态', dataIndex: 'statue',width: 150},
                {
                    xtype: 'gridcolumn',
                    //width: 110,
                    flex:1,
                    dataIndex: 'value',
                    text: '进度',
                    renderer: function (value, metaData, record) {
                        var id = Ext.id();
                        var displayValue=Math.round(value*100);
                        metaData.tdAttr = 'data-qtip="'+displayValue+'%"';
                        Ext.defer(function () {
                            Ext.widget('progressbar', {
                                renderTo: id,
                                value:value,
                                //height:20,
                                width: 150,
                                text:displayValue+'%'
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
