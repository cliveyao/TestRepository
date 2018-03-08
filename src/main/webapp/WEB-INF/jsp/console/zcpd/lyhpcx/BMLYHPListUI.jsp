<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
<body>
<div id="dlgBMLYHPListUI">
	<div id="tbBMLYHPListUI" style="width: 100%;height:30px;padding-top: 10px;">
		<div style="float:right;">
			<div style="float:left;line-height: 25px;">操作人：</div><div style="float:left;padding-right: 10px;"><input id="BMLYHPListUI_scbczr" name="czr" style="width: 120px;"/></div>
			<div style="float:left;line-height: 25px;">操作类型：</div><div style="float:left;padding-right: 10px;"><input id="BMLYHPListUI_cmbCzlx" name="czlx" style="width: 120px;"/></div>
			<div style="float:left;line-height: 25px;">易耗品类型：</div><div style="float:left;padding-right: 10px;"><input id="BMLYHPListUI_scbYhplx" name="lx" style="width: 120px;"/></div>
			<div style="float:left;padding-right: 10px;"><a class="easyui-linkbutton" data-options="iconCls:'icon-search'" href="#" onclick="BMLYHPListUI.query()">筛选</a></div>
		</div>
	</div>
	<div id="dgBMLYHPListUI"></div>		
</div>
<script type="text/javascript">
	$.ajax({
		url:getContextPath() + "/console/zcpd/lyhpcx/validFzr.do",
		cache:false,
		dataType:"text",
		success:function(result){
			if (result != "success") {
				$.messager.alert('警告',result,'warning');
			}
		},
		error:function(XMLHttpRequest){
			alert("Ajax Error!");
		}
		
	});
	
	var BMLYHPListUI = {
			
		query:function () {
			$("#dgBMLYHPListUI").datagrid("reload",{
				czr: $("#BMLYHPListUI_scbczr").attr("userid"),
				czlx:$("#BMLYHPListUI_cmbCzlx").combobox("getValue"),
				lxId:$("#BMLYHPListUI_scbYhplx").attr("yhplxid"),
			});
		},
		queryWXUser: function(){
    		dialogObj = $('<div id="dlgBMLYHPListUI_czrNewDlg"></div>');
    		wxuser=null;
			dialogObj.appendTo("body");
			$("#dlgBMLYHPListUI_czrNewDlg").dialog({
                href: getContextPath() + "/console/wxgl/wxuser/queryWXUserUI.do",
                title: "操作人列表",
                width: 512,
                height: 300,
                cache: false,
                collapsible: true,
                modal: true,
                draggable: true,
                inline: true,
                onClose: function() {
                    if(wxuser!=null){
                    	$("#BMLYHPListUI_scbczr").searchbox("setValue",wxuser.name);
                    	$("#BMLYHPListUI_scbczr").attr("userid",wxuser.userid);
                    }
                    dialogObj.remove();// 关闭时remove对话框
                }
            });
    	},
    	queryYhplx: function () {
    		dialogObj = $('<div id="dlgBMLYHPListUI_yhplxNewDlg"></div>');
    		cyhplx=null;
			dialogObj.appendTo("body");
			$("#dlgBMLYHPListUI_yhplxNewDlg").dialog({
                href: getContextPath() + "/console/catalog/yhplxgl/queryYhplxUI.do",
                title: "易耗品类型列表",
                width: 512,
                height: 300,
                cache: false,
                collapsible: true,
                modal: true,
                draggable: true,
                inline: true,
                onClose: function() {
                    if(cyhplx!=null){
                    	$("#BMLYHPListUI_scbYhplx").searchbox("setValue",cyhplx.mc);
                   		$("#BMLYHPListUI_scbYhplx").attr("yhplxid",cyhplx.lxId);
                    }
                    dialogObj.remove();// 关闭时remove对话框
                }
            });
    	}
	};
	
		$("#BMLYHPListUI_scbczr").searchbox({
			editable:false,
			searcher:function(value,name){
				//value：输入框内的值，name输入框对应的name
				BMLYHPListUI.queryWXUser();
			}
		});
		
		$("#BMLYHPListUI_cmbCzlx").combobox({
			editable:false,
			url: getContextPath() + "/console/zcpd/lyhpcx/getCZLXComboWithAll.do",
			value: " ",
			valueField: 'id',
			textField:'text',
		});
		
		$("#BMLYHPListUI_scbYhplx").searchbox({
			editable:false,
			searcher:function(value,name){
				//value：输入框内的值，name输入框对应的name
				BMLYHPListUI.queryYhplx();
			}
		});
		
		$("#dlgBMLYHPListUI").dialog({
			title: "部门易耗品出入库记录列表",
			width: 1024,
			height: 600,
	        cache: false,
	        shadow: true, // 显示阴影
	        resizable: false, // 不允许改变大小
	        modal: true, // 模式化窗口，锁定父窗口
	        inline: true, // 是否在父容器中，若不在会出现很多BUG
		});
		
		$("#dgBMLYHPListUI").datagrid({
			url: getContextPath() + "/console/zcpd/lyhpcx/getBMLYHPList.do",
			fit: true,
	        singleSelect: true,
	        pagination: true,
	        striped: true,
	        rownumbers: true,
	        toolbar: "#tbBMLYHPListUI",
	        pageSize: 15,
	        pageList: [15],
	        emptyMsg : "没有数据",
	        columns: [
	                  [{
	                      field: 'czrmc',
	                      title: '操作人',
	                      align: 'center',
	                      width: '10%',
	                      resizable: false,
	                      formatter:function(value,row){ 
		                   var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                   return content;  
		             	  }
	                  },{
	                      field: 'czlx',
	                      title: '操作类型',
	                      align: 'center',
	                      width: '10%',
	                      resizable: false,
	                      formatter:function(value,row){
	                        if (value==0) {
	                        	value="登记";
	                        } else if (value==1) {
	                        	value="调拨";
	                        } else if (value==2) {
	                        	value="领用";
	                        } else if (value==3) {
	                        	value="报损";
	                        } else if (value==4) {
	                        	value="补货";
	                        } 
		                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                    return content;  
		             	  }
	                  }, {
	                      field: 'deptName',
	                      title: '持有部门',
	                      align: 'center',
	                      width: '36%',
	                      resizable: false,
	                      formatter:function(value,row){ 
		                   var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                   return content;  
		             	  }

	                  }, {
	                      field: 'lx',
	                      title: '易耗品类型',
	                      align: 'center',
	                      width: '15%',
	                      resizable: false,
	                      formatter:function(value,row){ 
		                   var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                   return content;  
		             	  }

	                  }, {
	                      field: 'xh',
	                      title: '规格型号',
	                      align: 'center',
	                      width: '12%',
	                      resizable: false,
	                      formatter:function(value,row){ 
		                   if(value==null){
		                   	value="";
		                   }
		                   var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                   return content;  
		             	  }
	                      

	                  },{
	                      field: 'ccbh',
	                      title: '出厂编号',
	                      align: 'center',
	                      width: '12%',
	                      resizable: false,
	                      formatter:function(value,row){
	                    	if (value == null) {
	                    		value = "";
	                    	}
		                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                    return content;  
		             	  }

	                  },{
	                      field: 'num',
	                      title: '操作数量',
	                      align: 'center',
	                      width: '7%',
	                      resizable: false,
	                      formatter:function(value,row){ 
		                   var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
		                   return content;  
		             	  }

	                  }]
	              ],
	              onLoadSuccess : function(data) {
	            	  $(".tip").tooltip({ 
                		  trackMouse: true,
                          onShow: function(){ 
                              $(this).tooltip('tip').css({   
                                  width:300, 
                                  height:300,
                                  boxShadow: '1px 1px 3px #292929',
                              });  
                          }  
                      });
	      		},	
		});
	
	
	

</script>
</body>
</html>
