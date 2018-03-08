<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>易耗品列表</title>
<style type="text/css">
	body {
		margin-left: 0px;
		margin-top: 0px;
		margin-right: 0px;
		margin-bottom: 0px;
	}
</style>
</head>
<body>
	<div id="yhpListMain">  
	<table align="right" id="yhpcxListToolbar" width="100%">
			<tr>
			<td width="700"></td>
				<td >易 耗 品 类 型 : </td>
				<td><input id="bmSelectlx"  name="lx" style="width:125px"></td>
				<td ><a href="#"  id="searchYHPBMBtn"  align=right>筛选</a></td>
			</tr>
	 </table>
	 <table id ="tbYhpBMDateGrid"></table>
	 
	</div>
<script type="text/javascript">
var yhpBMManageOpt = {
		newMaxDialog: function(dialogId,url,title,param){
			// 弹出新的对话框
			var dialogObj = $('<div id="' + dialogId + '"></div>');
			dialogObj.appendTo("body");
			$("#" + dialogId).dialog({
                href: getContextPath() + url,
                title: title,
                top: 220,
                queryParams: param,
                width: 1024,
                height: 600,
                shadow : true, //显示阴影
        		resizable : false, //不允许改变大小
                modal: true,
                draggable: true,
                inline: true,
                onClose: function() {
                    dialogObj.remove();// 关闭时remove对话框
                }
            });
		},

		yhpCzxq: function(index){
			var rowInfo = $("#tbYhpBMDateGrid").datagrid("getRows")[index];
			var param = {"yhpId": rowInfo.yhpId};
			yhpBMManageOpt.newMaxDialog("BMczXqDialog","/console/zcpd/yhpcx/detailYHPUI.do","操作详情",param);
		},
	
		queryYhpLx: function(dialogId,url,title,param,searchboxId){
    		dialogObj = $('<div id="' + dialogId + '"></div>');
    		cyhplx=null;
			dialogObj.appendTo("body");
			$("#" + dialogId).dialog({
                href: getContextPath() + url,
                title: title,
                width: 512,
                height: 300,
                queryParams: param,
                cache: false,
                collapsible: true,
                modal: true,
                draggable: true,
                inline: true,
                onClose: function() {
                    if(cyhplx!=null){
                    	$("#"+searchboxId).searchbox("setValue",cyhplx.mc);
                    	$("#"+searchboxId).attr("lxId",cyhplx.lxId);
                    }
                    dialogObj.remove();// 关闭时remove对话框
                }
            });
    	}

};

  	$("#yhpListMain").dialog({
  		title : '部门易耗品列表',
  		height:600,
  		width:1024,
  		closed : false,
		cache : false,
		shadow : true, //显示阴影
		resizable : false, //不允许改变大小
		modal : true, //是否窗口化
		inline : true, //是否在父容器中，若不在会出现很多BUG
  	});	
  	
  	$("#bmSelectlx").searchbox({    
  		width: 120,
     	height: 25,
     	editable:false,
     	searcher:function(value,name){
     		yhpBMManageOpt.queryYhpLx("yhpLXDialog","/console/catalog/yhplxgl/queryYhplxUI.do","类型列表",{},"bmSelectlx");
     	}
    });
  	
  	$("#tbYhpBMDateGrid").datagrid({
  		width : "100%",
		height : "100%",
		method : "post",
		toolbar:"#yhpcxListToolbar",
		url : getContextPath() + "/console/zcpd/yhpcx/getBMYHPList.do",
		pagination : true, //是否有分页工具
		pagePosition : "bottom", //分页工具位置
		pageSize : 15, //分页默认大小
		pageList : [ 15 ],
		striped : true, //斑马线样式,
		nowrap : true, //是否在一行显示所有，自动换行
		loadMsg : "努力加载中，请稍后。。。。",//加载信息
		rownumbers : true, //是否显示行号
		singleSelect : true, //只能同时选择一行
		showHeader : true,//显示行头，默认true;
		emptyMsg : "没有数据",
		
		
		onBeforeLoad : function(){
			if(${isBMGLY}){
				return true;
			}else{
				 $.messager.alert('警告', '您不是部门易耗品管理员，无法查询部门易耗品列表！');
				 $("#yhpListMain").dialog('close');
				 return false;
			}
		},
		onLoadSuccess : function(data) {
			//查询详情使用
			$(".searchBtn").linkbutton({
				plain : true,
				height : 21,
				iconCls : 'icon-detail',
			});
			
			$(".searchBtn").tooltip({
	 			content : '详情',
	 			position : 'top',
	 			trackMouse: true,
 			});
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
		
		
	columns : [[
			{
				width : "16%",
				field : "lx",
				title : "易耗品类型",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }
			},
			{
				width : "14%",
				field : "xh",
				title : "规格型号",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }	
			},
			{
				width : "14%",
				field : "ccbh",
				title : "出厂编号",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }
				
			},
			{
				width : "14%",
				field : "deptName",
				title : "持有部门",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }
			},
			{
				width : "14%",
				field : "num",
				title : "持有数量",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }
			},
			{
				width : "14%",
				field : "leftLimit",
				title : "库存下限",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value,row){ 
                    var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                    if(value==null){
                 	   value="";
                 	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                    }
                    return content;  
                }
				
			},
			
			{
				width : '16%',
				field : "opt",
				title : "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作记录",
				align : "left",
                formatter: function(value, row, index) {
                	return '&nbsp;&nbsp;<a href="#" class="searchBtn" onclick="yhpBMManageOpt.yhpCzxq(' + index + ')"></a>';
                },
				resizable : false,
			} ] ],
	});
  	
	$("#searchYHPBMBtn").linkbutton({
		iconCls: 'icon-search',
		plain : true,
		onClick: function (){
			doSearchBM();
		}
	});

	function doSearchBM(){
		var lxId = $.trim($("#bmSelectlx").attr("lxId"));
		var param ={"lxId":lxId};
		$("#tbYhpBMDateGrid").datagrid("reload",param);
	};
	
</script>
</body>
</html>