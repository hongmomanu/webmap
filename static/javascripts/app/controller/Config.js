/**
 * Created with JetBrains WebStorm.
 * User: jack
 * Date: 13-6-27
 * Time: 下午5:16
 * To change this template use File | Settings | File Templates.
 */


/**
 * Map controller
 * Used to manage map layers and showing their related views
 */
Ext.define('CF.controller.Config', {
    extend: 'Ext.app.Controller',

    models: ['SpaceTable'],
    stores: ['SpaceTables'],

    views: [
        // 'user.List'
        'config.servertypesPanel',
        'config.doorPanel'
    ],

    refs: [
        {
            ref: 'servertypesPanel',
            selector: 'servertypespanel'
        },
        {
            ref: 'doorPanel',
            selector: 'doorpanel'
        }
        /*{ref: 'summitChart', selector: 'summitchart'},
         {ref: 'summitGrid', selector: 'summitgrid'}*/
    ],
    //初始化
    init: function () {
        var me = this;
        //testobj=this.getSchedulerSchedulerView();

        this.control({
            'addnewmapwin button[action=add]': {
                click: this.addMap
            },
            'addnewlayerwin button[action=add]': {
                click: this.addLayer
                //itemclick: this.showContent
            },
            'servertypespanel button[action=add]': {
                click: this.addMapWin
                //itemclick: this.showContent
            },
            'doorpanel button[action=connect]': {
                click: this.connectDb
                //itemclick: this.showContent
            },
            'doorpanel button[action=beginpattern]':{
                click :this.patternDoorplate

            },
            'servertypespanel': {
                itemcontextmenu: this.showMenu
            },
            'mapmenu > menuitem': {
                click: this.addLayerWin
            }

        }, this);
    },
    showMenu: function (panelView, record, item, index, e, eOpts) {
        var me = this;
        e.preventDefault();
        e.stopEvent();
        var menu = null;
        if (record.data.depth == 1) {
            menu = Ext.widget('mapmenu');


        } else if (record.data.depth == 2) {
            menu = new Ext.menu.Menu({
                items: [
                    {
                        text: '新增图层数据'
                    },
                    {
                        text: '删除图层'
                    }
                ]
            });


        } else if (record.data.depth == 2) {
            menu = new Ext.menu.Menu({
                items: [
                    {
                        text: '删除图层数据'
                    }
                ]
            });


        }


        menu.showAt(e.getXY());
    },
    addLayerWin: function (item, e, eOpts) {
        if (item.text === '删除地图') {
            var me = this;
            Ext.Msg.show({
                title: '确定要删除此地图?',
                msg: '你正在试图删除选中地图的操作.你想继续么?',
                buttons: Ext.Msg.YESNO,
                fn: function (btn) {
                    console.log(btn);
                    me.delMap();
                },
                icon: Ext.Msg.QUESTION
            });
        } else {
            if (!this.maplayerWin)this.maplayerWin = Ext.widget('addnewlayerwin');
            this.maplayerWin.show();
        }

    },
    delMap: function () {
        //console.log("hello delMap");
        //console.log(this.getServertypesPanel().getSelectionModel().getLastSelected());
    },
    addMapWin: function (button) {

        if (!this.mapserverWin)this.mapserverWin = Ext.widget('addnewmapwin');
        this.mapserverWin.show();
        //testobj=this.getServertypesPanel();

    },
    patternDoorplate:function(button){
        //Ext.Msg.alert("begin partten");
        var me = this;
        //testobj=button.up('form').items;
        if(button.up('form').items.items[0].getForm().findField("proptable").isDisabled()){
            Ext.Msg.alert("提示信息", "还未选择属性表");
            return ;
        }
        if(button.up('form').items.items[1].getForm().findField("proptable").isDisabled()){
            Ext.Msg.alert("提示信息", "还未选择空间表");
            return ;
        }


        var successFunc = function (form, action) {
            //var result = Ext.JSON.decode(action.response.responseText)
            Ext.Msg.alert("提示信息", "ok");

        };
        var failFunc = function (form, action) {
            // alert(Ext.JSON.decode(action.response.responseText).msg);
            Ext.Msg.alert("提示信息", "hh");

        };
        this.formSubmit(button, {}, 'patterndoor', successFunc, failFunc);


        //console.log(table_comb);findField("proptable");



    },
    connectDb: function (button) {
        //console.log("connect begin");
        var me = this;
        var successFunc = function (form, action) {
            var result = Ext.JSON.decode(action.response.responseText)
            Ext.Msg.alert("提示信息", result.msg);

            //testobj = me.getDoorPanel();


            Ext.regModel('Table', {
                fields: [//define the model field
                    {name: 'text', type: 'string'}
                ]
            });
            var table_comb = button.up('form').getForm().findField("proptable");
            table_comb.store.removeAll();
            Ext.each(result.tables, function (a) {
                    var table = Ext.ModelMgr.create({
                        text: a
                    }, 'Table');

                    table_comb.store.add(table);

                }
            );
            table_comb.enable();


        };
        var failFunc = function (form, action) {
            // alert(Ext.JSON.decode(action.response.responseText).msg);
            var table_comb = button.up('form').getForm().findField("proptable");
            Ext.Msg.alert("错误信息", Ext.JSON.decode(action.response.responseText).msg);
            table_comb.disable();

        };
        this.formSubmit(button, {}, 'checkconnect', successFunc, failFunc);

    },
    addLayer: function (button) {
        var params = {
            type: 'add',
            keyid: 0,
            treelevel: 0

        };
        var successFunc = function (form, action) {

            console.log(form);
            console.log(action);

        };
        var failFunc = function (form, action) {

        };
        this.formSubmit(button, params, 'mapinfotodb', successFunc, failFunc);

    },
    formSubmit: function (button, params, url, sucFunc, failFunc) {
        var form = button.up('form').getForm();
        if (form.isValid()) {
            //Ext.MessageBox.alert('Submitted Values', form.getValues(true));

            form.submit({
                waitTitle: '提示', //标题
                waitMsg: '正在保存数据请稍后...', //提示信息
                url: url,

                method: "POST",
                params: params,
                success: sucFunc,
                failure: failFunc
            });

        }


    },
    addMap: function (button) {
        var params = {
            type: 'add',
            keyid: 0,
            treelevel: -1
        };

        var successFunc = function (form, action) {

            console.log(form);
            console.log(action);

        };
        var failFunc = function (form, action) {

        };
        this.formSubmit(button, params, 'mapinfotodb', successFunc, failFunc);

    },

    onLaunch: function () {
        var me = this;

        // for dev purpose
        //ctrl = this;
    }


});

