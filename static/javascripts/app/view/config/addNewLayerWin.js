/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-27
 * Time: 下午2:58
 * To change this template use File | Settings | File Templates.
 */
Ext.define('CF.view.config.addNewLayerWin' ,{
    extend: 'Ext.window.Window',
    alias : 'widget.addnewlayerwin',
    requires: [
        
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
                                            fieldLabel: '图层名称',
                                            name: 'mapname',
                                            //afterLabelTextTpl: required,
                                            allowBlank: false
                                        },
                                        {
                                            xtype: 'textfield',
                                            fieldLabel: '图层标识',
                                            name: 'maplabel',
                                            //afterLabelTextTpl: required,
                                            allowBlank: false
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