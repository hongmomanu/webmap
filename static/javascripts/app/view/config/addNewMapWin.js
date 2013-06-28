/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-27
 * Time: 下午2:58
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.view.config.addNewMapWin' ,{
    extend: 'Ext.window.Window',
    alias : 'widget.addnewmapwin',
    requires: [
        //'Ext.form.*'
    ],
    initComponent: function() {
        Ext.apply(this, {
            title: '新增地图',
            height: 400,
            width: 500,
            closeAction : 'hide',
            resizable:false,
            layout: 'fit',
            items: {  // Let's put an empty grid in just to illustrate fit layout
                xtype: 'form',

                layout: {
                    type: 'vbox',

                    align: 'stretch'
                },
                border: false,
                bodyPadding: 10,
                //xtype: 'fieldset',

                fieldDefaults: {
                    labelAlign: 'top',
                    labelWidth: 100,
                    labelStyle: 'font-weight:bold'
                },

                items: [
                    {
                        xtype: 'textfield',
                        fieldLabel: '地图服务名',
                        //afterLabelTextTpl: required,
                        name: 'text'
                    },
                    {
                        xtype: 'textfield',
                        fieldLabel: '服务标识',
                        //afterLabelTextTpl: required,
                        name: 'name'
                    },
                    {
                        xtype: 'textfield',
                        fieldLabel: '投影坐标',
                        //afterLabelTextTpl: required,
                        name: 'projection'
                    },
                    {
                        //xtype: 'datefield',
                        xtype: 'textfield',
                        //afterLabelTextTpl: required,
                        fieldLabel: '空间坐标系',
                        name: 'spatialreference'
                    },
                    {
                        xtype: 'radiogroup',
                        fieldLabel: '服务类型',
                        columns: 2,

                        //labelWidth:200,
                        // labelAlign : 'right',
                        //width:360,
                        defaults: {
                            name: 'maptype' //Each radio has the same name so the browser will make sure only one is checked at once
                        },
                        items: [
                            {
                                inputValue: '0',
                                width: 80,
                                checked: true,
                                boxLabel: '网络地图'
                            },
                            {
                                inputValue: '1',
                                width: 180,
                                boxLabel: 'arcgis紧凑数据'
                            }
                        ]
                    }
                ],
                buttons: [
                    {
                        text: '取消',
                        handler: function () {
                            //this.up('form').getForm().reset();
                            this.up('window').hide();
                        }
                    } ,
                    {
                        text: '添加',
                        action: 'add'

                    }
                ],
                border: false
            }

        });
        this.callParent(arguments);
    }

});