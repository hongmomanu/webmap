/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-10
 * Time: 下午2:50
 * To change this template use File | Settings | File Templates.
 */


Ext.define('CF.view.cachePanel' ,{
    extend: 'Ext.form.Panel',
    alias : 'widget.cachepanel',
    //border: true,	
   // layout: 'fit',
    requires: [
	'Ext.form.*'
    ],
    initComponent: function() {
        Ext.apply(this, {
		frame:true,
		fieldDefaults: {
			labelAlign: 'right',
			labelWidth: 90,
			msgTarget: 'qtip'
	    	},
		   items: [
            // Contact info
            {
                xtype: 'fieldset',
                title: '地图服务及图层选择',
                defaultType: 'textfield',
		//collapsible: true,
                layout: 'anchor',


                defaults: {
                    anchor: '100%'
                },
                items: [
                    {
                        xtype: 'container',
                        layout: 'hbox',
                        defaultType: 'textfield',
                        margin: '0 0 10 0',
                        items: [
                            {
                                fieldLabel: '地图选择',
                                name: 'mapowner',
                                xtype: 'combo',
                                allowBlank: false,
                                blankText: "不能为空，请选择",
                                displayField: 'text',
                                valueField: 'name',
                                emptyText: '请选择地图服务',
                                listeners: {
                                    scope: this,
                                    'select': function (combo, records) {
                                    }
                                },
                                queryMode: 'remote',
                                flex: 1,
                                store: 'MapServers'

                            },
                            {
                                fieldLabel: '图层选择',
                                name: 'maplayer',
                                xtype: 'combo',
                                displayField: 'text',
                                valueField: 'layer',
                                emptyText: '请选择地图服务',
                                allowBlank: false,
                                blankText: "不能为空，请选择",
                                //margins: '6 6 6 6',
                                disabled: true,
                                listeners: {
                                    scope: this,
                                    'select': function (combo, records) {
                                    }
                                },
                                //queryMode: 'local',
                                flex: 1//,
                                //store: 'MapServers'
                            }

                        ]
                    }/**,
                    {
                        xtype: 'container',
                        layout: 'hbox',
                        defaultType: 'textfield',
                        items: []
                    }**/

                ]
            },
            {
                xtype: 'fieldset',
                title: '经纬度范围',
                defaultType: 'textfield',
                layout: 'anchor',
                //collapsible: true,
                defaults: {
                    anchor: '100%'
                },
                items: [
                    {
                        xtype: 'container',
                        layout: 'hbox',
                        items: [
                            {
                                xtype: 'textfield',
                                fieldLabel: '最小经度',
                                name: 'minx',
                                id: 'minxtext',
                                listeners: {
                                    change: function (field) {
                                        //Ext.getCmp('maxxtext').validator();

                                    }
                                },
                                validator: function () {
                                    if (Ext.getCmp('maxxtext').getValue() != "") {
                                        if (this.getValue() < Ext.getCmp('maxxtext').getValue()) {
                                            return true;
                                        } else {
                                            return "最大经度必须大于最小经度!";
                                        }


                                    }
                                    else {

                                        return true;
                                    }

                                },
                                width: 160,
                                allowBlank: false,
                                //maxLength: 10,
                                flex: 1,
                                allowBlank: false,
                                blankText: "不能为空，请填写",

                                //enforceMaxLength: true,
                                maskRe: /[\d\.]/,
                                regex: /^\d{3}(\.\d+)?$/,
                                regexText: '经度数值必须是 xxx or xxx.xxxx'
                            }
                            ,
                            {
                                xtype: 'textfield',
                                fieldLabel: '最大经度',
                                name: 'maxx',
                                id: 'maxxtext',
                                invalidText: '最大经度必须大于最小经度!',
                                listeners: {
                                    change: function (field) {
                                    }
                                },
                                validator: function () {
                                    if (this.getValue() > Ext.getCmp('minxtext').getValue()) {
                                        return true;
                                    } else {
                                        return "最大经度必须大于最小经度!";
                                    }

                                },
                                allowBlank: false,
                                flex: 1,
                                allowBlank: false,
                                blankText: "不能为空，请填写",

                                //enforceMaxLength: true,
                                maskRe: /[\d\.]/,
                                regex: /^\d{3}(\.\d+)?$/,
                                regexText: '经度数值必须是 xxx or xxx.xxxx'
                            },

                            {
                                xtype: 'textfield',
                                fieldLabel: '最小纬度',
                                name: 'miny',
                                id: 'minytext',
                                listeners: {
                                    change: function (field) {
                                    }
                                },
                                allowBlank: false,
                                //maxLength: 10,
                                flex: 1,
                                validator: function () {
                                    if (Ext.getCmp('maxytext').getValue() != "") {
                                        if (this.getValue() < Ext.getCmp('maxytext').getValue()) {
                                            return true;
                                        } else {
                                            return "最大经度必须大于最小经度!";
                                        }


                                    }
                                    else {

                                        return true;
                                    }

                                },
                                allowBlank: false,
                                blankText: "不能为空，请填写",
                                //enforceMaxLength: true,
                                maskRe: /[\d\.]/,
                                regex: /^\d{2}(\.\d+)?$/,
                                regexText: '经度数值必须是 xx or xx.xxxx'
                            },
                            {
                                xtype: 'textfield',
                                fieldLabel: '最大纬度',
                                name: 'maxy',
                                id: 'maxytext',
                                invalidText: '最大纬度必须大于最小纬度!',
                                validator: function () {
                                    if (this.getValue() > Ext.getCmp('minytext').getValue()) {
                                        return true;
                                    } else {
                                        return false;
                                    }

                                },
                                listeners: {
                                    change: function (field) {

                                    }
                                },
                                allowBlank: false,
                                //maxLength: 10,
                                flex: 1,
                                allowBlank: false,
                                blankText: "不能为空，请填写",
                                //enforceMaxLength: true,
                                maskRe: /[\d\.]/,
                                regex: /^\d{2}(\.\d+)?$/,
                                regexText: '经度数值必须是 xx or xx.xxxx'
                            }


                        ]
                    }
                ]
            },

            {
                xtype: 'fieldset',
                title: '其它',
                defaultType: 'textfield',
                layout: 'anchor',
                defaults: {
                    anchor: '100%'
                },
                items: [
                    {
                        xtype: 'container',
                        layout: 'hbox',
                        items: [
                            {
                                xtype: 'textfield',
                                fieldLabel: '用户',
                                //defaultValue:'jack',
                                //value: userobj.username,
                                name: 'username',
                                listeners: {
                                    change: function (field) {
                                    }
                                },
                                width: 160,
                                allowBlank: false,
                                //maxLength: 10,
                                // flex:1,
                                allowBlank: false,
                                blankText: "不能为空，请填写"
                            },
                            {
                                xtype: 'radiogroup',
                                fieldLabel: '是否覆盖',
                                columns: 2,

                                labelWidth: 200,
                                labelAlign: 'right',
                                width: 360,
                                defaults: {
                                    name: 'isenforce' //Each radio has the same name so the browser will make sure only one is checked at once
                                },
                                items: [
                                    {
                                        inputValue: 'false',
                                        width: 80,
                                        checked: true,
                                        boxLabel: '不覆盖'
                                    },
                                    {
                                        inputValue: 'true',
                                        width: 80,
                                        boxLabel: '覆盖'
                                    }
                                ]
                            },
                            {
                                xtype: 'radiogroup',
                                fieldLabel: '是否生成缓存数据',
                                columns: 2,
                                hidden: true,
                                labelWidth: 200,
                                labelAlign: 'right',
                                width: 300,
                                defaults: {
                                    name: 'iscache' //Each radio has the same name so the browser will make sure only one is checked at once
                                },
                                items: [
                                    {
                                        inputValue: 'false',
                                        width: 80,
                                        checked: true,
                                        boxLabel: '是'
                                    },
                                    {
                                        inputValue: 'true',
                                        width: 80,
                                        boxLabel: '否'
                                    }
                                ]
                            }

                        ]
                    }
                ]
            }


        ]

		
        });
        this.callParent(arguments);
        // store singleton selection model instance
    }
});
