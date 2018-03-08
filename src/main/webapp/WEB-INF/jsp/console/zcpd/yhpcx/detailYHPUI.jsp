<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" >
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>易耗品操作记录</title>
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
	<div id="yhpDetailListMain">  
	<table align="right" id="yhpDetailListToolbar" width="100%">
			<tr>
			<td width="740"></td>
				<td >操作类型 : </td>
				<td><input id="selectYhpCzlx"  name="czlx"  style="width:125px"></td>
				<td ><a href="#"  id="searchYhpBtn">筛选</a></td>
			</tr>
	 </table>
	 <table id ="tbYhpDetailDateGrid"></table>
	</div>
<script type="text/javascript">
  	$("#selectYhpCzlx").combobox({    
        required:true,  
     	url: getContextPath()+"/console/zcpd/yhpcx/getYHPCZLXComboWithAll.do",
        valueField: 'id',
		textField: 'text',
		editable: false,
		//panelHeight: 80,
		onLoadSuccess : function(){
			var data =$(this).combobox("getData");
			$(this).combobox("select",data[0].id);
		}
    });
  	
  	
  	$("#tbYhpDetailDateGrid").datagrid({
  		width : "100%",
		height : 561,
		method : "post",
		toolbar:"#yhpDetailListToolbar",
		url : getContextPath() + "/console/zcpd/yhpcx/getYHPDetail.do?yhpId="+${yhpId},
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
	columns : [[
			{
				width : "17%",
				field : "czbmDeptName",
				title : "操作部门",
				halign : "center",
				align : "center",
				resizable : true
				
			},
			
			{
				width : "17%",
				field : "czrmc",
				title : "操作人",
				halign : "center",
				align : "center",
				resizable : true	
			},
			{
				width : "14%",
				field : "czlx",
				title : "操作类型",
				halign : "center",
				align : "center",
				resizable : true,
				formatter:function(value){
					if(value == "0"){
						return "登记";
					}else if(value == "1"){
						return "调拨";
					}else if(value == "2"){
						return "领用";
					}else if(value == "3"){
						return "报损";
					}else if(value == "4"){
						return "补货";
					}
				}
			},
			{
				width : "17%",
				field : "num",
				title : "操作数量",
				halign : "center",
				align : "center",
				resizable : true
			},
			{
				width : "17%",
				field : "jlsj",
				title : "记录时间",
				halign : "center",
				align : "center",
				resizable : true,
				formatter : function(value){
                    var date = new Date(value);
                    var y = date.getFullYear();
                    var m = date.getMonth() + 1;
                    var d = date.getDate();
                    var h = date.getHours();
                    var mi = date.getMinutes();
                    var s = date.getSeconds();
                    return y + '-' +m + '-' + d + '  '+ h + ':'+ mi + ':' + s;
	              }
			},
			{
				width : "17%",
				field : "jlrmc",
				title : "记录人",
				halign : "center",
				align : "center",
				resizable : true
				
			}
			
			 ] ]
	});
  	
	$("#searchYhpBtn").linkbutton({
		iconCls: 'icon-search',
		plain : true,
		onClick: function (){
			doSearch();
		}
	});

	function doSearch(){
		var czlx = $("#selectYhpCzlx").combobox("getValue");
		var param ={"czlx":czlx};
		$("#tbYhpDetailDateGrid").datagrid("reload",param);
	};
	
</script>
</body>
</html>