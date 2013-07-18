/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.config.doorPanel' ,{
    extend: 'Ext.form.Panel',
    alias : 'widget.doorpanel', 
    frame: true,
    title: 'Company data',
    bodyPadding: 5,
    layout: 'column',
    requires: [
        
    ],
    initComponent: function() {
        Ext.apply(this, {
        title: '地名匹配工具',
        items: [
          		{
                columnWidth: 0.5,
                xtype: 'form',
                margin: '10 10 10 10',
                items:[
                 {
                
                xtype: 'fieldset',
                title:'属性数据',
                layout: 'anchor',
                defaultType: 'textfield',
                items: [{
                    fieldLabel: '数据库地址',
                    value:'192.168.2.141',
                    anchor:'100%',
                    name: 'host'
                },{
                    fieldLabel: '用户名',
                    value:'postgres',
                    anchor:'100%',
                    name: 'user'
                },{
                    fieldLabel: '密码',
                    anchor:'100%',
                    value:'hvit',
                    name: 'password'
                },{
                    fieldLabel: '数据库名',
                    value:'gnc',
                    anchor:'100%',
                    name: 'dbname'
                }, {
                    xtype: 'radiogroup',
                    fieldLabel: '数据库类型',
                    columns: 2,
                    defaults: {
                        name: 'databsetype' //Each radio has the same name so the browser will make sure only one is checked at once
                    },
                    items: [{
                        inputValue: '0',
                        checked: true,
                        boxLabel: 'postgres'
                    }, {
                        inputValue: '1',
                        boxLabel: 'oracle'
                    }]
                },{
                   xtype:'panel',
                   layout: 'column',

                   items:[
                       {
                           columnWidth: 0.7,
                           fieldLabel: '表选择',
                           name: 'proptable',
                           anchor:'100%',
                           xtype: 'combo',
                           allowBlank: true,
                           //blankText: "请选择",
                           displayField: 'text',
                           valueField: 'text',
                           emptyText: '请选择表',
                           disabled:true,
                           listeners: {
                               scope: this,
                               'select': function (combo, records) {
                               }
                           },
                           queryMode: 'local',
                           flex: 1,
                           store: Ext.widget('spacetables')

                       },

                       {
                           columnWidth: 0.3,
                           xtype:'button',
                           text : '连接数据库',
                           action:'connect'
                       }

                   ]

                },{
                    fieldLabel: '过滤条件',
                    value:'where doorplate is not null',
                    anchor:'100%',
                    name: 'sql'
                }]
            }
                ]
              },{
               columnWidth: 0.5,
                xtype: 'form',
                margin: '10 10 10 10',
                items:[
                    {

                        xtype: 'fieldset',
                        title:'空间数据',
                        layout: 'anchor',
                        defaultType: 'textfield',
                        items: [{
                            fieldLabel: '数据库地址',
                            value:'192.168.2.141',
                            anchor:'100%',
                            name: 'host'
                        },{
                            fieldLabel: '用户名',
                            value:'postgres',
                            anchor:'100%',
                            name: 'user'
                        },{
                            fieldLabel: '密码',
                            anchor:'100%',
                            value:'hvit',
                            name: 'password'
                        },{
                            fieldLabel: '数据库名',
                            value:'gnc',
                            anchor:'100%',
                            name: 'dbname'
                        }, {
                            xtype: 'radiogroup',
                            fieldLabel: '数据库类型',
                            columns: 2,
                            defaults: {
                                name: 'databsetype' //Each radio has the same name so the browser will make sure only one is checked at once
                            },
                            items: [{
                                inputValue: '0',
                                checked: true,
                                boxLabel: 'postgres'
                            }, {
                                inputValue: '1',
                                boxLabel: 'oracle'
                            }]
                        },{
                            xtype:'panel',
                            layout: 'column',

                            items:[
                                {
                                    columnWidth: 0.7,
                                    fieldLabel: '表选择',
                                    name: 'proptable',
                                    anchor:'100%',
                                    xtype: 'combo',
                                    allowBlank: true,
                                    //blankText: "请选择",
                                    displayField: 'text',
                                    valueField: 'text',
                                    emptyText: '请选择表',
                                    disabled:true,
                                    listeners: {
                                        scope: this,
                                        'select': function (combo, records) {
                                        }
                                    },
                                    queryMode: 'local',
                                    flex: 1,
                                    store: Ext.widget('spacetables')

                                },

                                {
                                    columnWidth: 0.3,
                                    xtype:'button',
                                    text : '连接数据库',
                                    action:'connect'
                                }

                            ]

                        }
                          ,{
                                fieldLabel: '过滤条件',
                                value:'where doorplate is not null',
                                anchor:'100%',
                                name: 'sql'
                            }
                        ]
                    }
                ]
              }
              ],
         buttons: [
            {
           text: '开始匹配',
           disabled:false,
           action:'beginpattern'

            }
                
		   ]
        });
        this.callParent(arguments);
        // store singleton selection model instance
    }
});
