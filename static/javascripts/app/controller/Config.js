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

    models: [],
    stores: [],
    views: [
       // 'user.List'
        'config.servertypesPanel'
    ],

    refs: [
        {
            ref: 'servertypesPanel',
            selector: 'servertypespanel'
        }
        /*{ref: 'summitChart', selector: 'summitchart'},
        {ref: 'summitGrid', selector: 'summitgrid'}*/
    ],

    init: function() {
        var me = this;
        //testobj=this.getSchedulerSchedulerView();

        this.control({
            'addnewmapwin button[action=add]': {
                click: this.addMap
            },
            'servertypespanel button[action=add]':{
                click:this.addMapWin
                //itemclick: this.showContent
            }, 
            'servertypespanel':{
                itemcontextmenu: this.showMenu
            },
            'mapmenu > menuitem' : {
                click : this.addLayerWin
            }
                
        }, this);
    },
    showMenu:function (panelView, record, item, index, e, eOpts){
     var me = this;
     e.preventDefault();  
     e.stopEvent(); 
     var menu=null;
     if(record.data.depth==1){
        menu=Ext.widget('mapmenu');
					 
					 
     
     }else if (record.data.depth==2){
					 menu = new Ext.menu.Menu({     
						      items:[{     
						          text: '新增图层数据'
						      },{     
						          text: '删除图层'    
						      }]     
						});
					 
     
     }else if (record.data.depth==2){
        menu= new Ext.menu.Menu({     
						      items:[{     
						          text: '删除图层数据'    
						      }]     
						});
     
     
     
     }
             
        
        menu.showAt(e.getXY()) ; 
    },
    addLayerWin:function(item, e, eOpts){
    		if(item.text==='删除地图'){
    		var me =this;
    		  Ext.Msg.show({
          title:'确定要删除此地图?',
          msg: '你正在试图删除选中地图的操作.你想继续么?',
          buttons: Ext.Msg.YESNO,
          fn:function(btn) {
             console.log(btn);
             me.delMap();
    				 },
          icon: Ext.Msg.QUESTION
           });
    		}else{
    		  if(!this.maplayerWin)this.maplayerWin=Ext.widget('addnewlayerwin');
        this.maplayerWin.show();
    		}
    						
    },
    delMap:function(){
          console.log("hello delMap");
          console.log(this.getServertypesPanel().getSelectionModel().getLastSelected());
    },
    addMapWin:function(button){

            if(!this.mapserverWin)this.mapserverWin=Ext.widget('addnewmapwin');
            this.mapserverWin.show();
            //testobj=this.getServertypesPanel();

    },
    addMap:function(button){
        var form = button.up('form').getForm();
        if (form.isValid()) {
            //Ext.MessageBox.alert('Submitted Values', form.getValues(true));

            form.submit({
                waitTitle: '提示', //标题
                waitMsg: '正在保存数据请稍后...', //提示信息
                url: 'mapinfotodb',

                method: "POST",
                params: {
                    type: 'add',
                    keyid: 0,
                    treelevel: -1
                },
                success: function (form, action) {

                    Ext.Msg.alertmaplayer_win = null;

                },
                failure: function (form, action) {
                    Ext.Msg.alert('失败!', "添加数据失败!");

                }
            });

        }

    },

    onLaunch: function() {
        var me = this;

        // for dev purpose
        //ctrl = this;
    }


});

