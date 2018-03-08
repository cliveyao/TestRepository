<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<title>低值易耗品申领单列表</title>
</head>
<body>
	<div id="lossingGRYHPMain">
		<table id="lossingBMYHPDatagrid"></table>
		<div id="lossingGRYHPToolbar">
			<table>
				<tr>
					<td><a href="#" class="easyui-linkbutton" plain="true" iconCls="icon-add"  onclick="objGRYHPSQ.add()">新增</a></td>
				</tr>
			</table>
		</div>
		 <form id="delForm" method="post">
			<input type="hidden" name="randomInfo" value="<%=Math.random()%>"/>
		 </form>
	</div>
	
	<script type="text/javascript">
		var objGRYHPSQ = {
				add : function(){				
					var insertInfoDiv = $("<div id='insertInfoDiv'></div>");
					insertInfoDiv.appendTo("body");
					$("#insertInfoDiv").dialog({
						title: "新增低值易耗品个人申领单",
						width: 1024,
						height: 600,
						href: getContextPath() + "/console/yhpgl/yhpsl/insertGRYHPSQUI.do",
						closed: false,
						cache: false,
						modal: true,
						onClose: function(){
							insertInfoDiv.remove();
							$("#lossingBMYHPDatagrid").datagrid("reload");						
						}					
					});				
				},
				edit : function(){
					var updateBMYHPSQ = $("<div id='updateBMYHPSQ'></div>");
					updateBMYHPSQ.appendTo("body");
					$("#updateBMYHPSQ").dialog({
						title : "编辑低值易耗品申领单",
						height : 600,
						width : 1024,
						modal:true,
						inline:true,
						closed : false,
						onClose : function(){
							updateBMYHPSQ.remove();
							$("#lossingBMYHPDatagrid").datagrid('reload');
						},
					});
					$("#updateBMYHPSQ").dialog('open').dialog('refresh',getContextPath()+"/console/yhpgl/yhpsl/updateYHPSQUI.do");
				},
				del : function(sqdm){					
					$.messager.confirm('确认','您确认想要删除此记录吗？',function(sure){ 
						if(sure){
							$("#delForm").form('submit',{
								url : getContextPath() + "/console/yhpgl/yhpsl/delYHPSQ.do?sqdm="+sqdm,
								success : function(data){							 
									if(data != 'success'){
										$.messager.alert('失败', data, 'warning');
									}
									$("#lossingBMYHPDatagrid").datagrid('reload');
								}							
							 });
						}				
				  });
				},
				submit : function(){
					var submitBMYHPSQ = $("<div id='submitBMYHPSQ'></div>");
					submitBMYHPSQ.appendTo("body");
					$("#submitBMYHPSQ").dialog({
						title : "提交低值易耗品申领单",
						height : 600,
						width : 1024,
						modal:true,
						inline:true,
						closed : false,
						onClose : function(){
							$("#lossingBMYHPDatagrid").datagrid('reload');
							submitBMYHPSQ.remove();
						},
					});
					$("#submitBMYHPSQ").dialog('open').dialog('refresh',getContextPath()+"/console/yhpgl/yhpsl/submitYHPSQUI.do");
				},
				details : function(){
					var detailsBMYHPSQ = $("<div id='detailsBMYHPSQ'></div>");
					detailsBMYHPSQ.appendTo("body");
					$("#detailsBMYHPSQ").dialog({
						title : "低值易耗品申领单详情",
						height : 600,
						width : 1024,
						modal:true,
						inline:true,
						closed : false,
						onClose : function(){
							detailsBMYHPSQ.remove();
						},
					});
					$("#detailsBMYHPSQ").dialog('open').dialog('refresh',getContextPath()+"/console/yhpgl/yhpsl/detailsBMYHPSQUI.do");
				},
		};
		
		$("#lossingGRYHPMain").dialog({
			title : '低值易耗品个人申领单列表',
			height : 600,
			width : 1024,
			closed : false,
			cache : false,
			shadow : true,
			resizable : false,
			modal : true,
			inline : true,  //是否在父容器中，若不在会出现很多BUG
		});
	 	$("#lossingBMYHPDatagrid").datagrid({
	  		width : "100%",
			height : "100%",
			method : "post",
			url : getContextPath() + "/console/yhpgl/yhpsl/getGRYHPBSList.do",
			onLoadSuccess : function(data) {				
				$(".editBtn").linkbutton({
					plain : true,
					height : 21,
					iconCls : 'icon-edit'
				});
				$(".editBtn").tooltip({
					content : '编辑',
					position : 'top',
				});
				$(".deleteBtn").linkbutton({
					plain : true,
					height : 21,
					iconCls : 'icon-no'
				});
				$(".deleteBtn").tooltip({
					content : '删除',
					position : 'top',
				});
				$(".submitBtn").linkbutton({
					plain : true,
					height : 21,
					iconCls : 'icon-submitzc'
				});
				$(".submitBtn").tooltip({
					content : '提交',
					position : 'top',
				});
				$(".detailsBtn").linkbutton({
					plain : true,
					height : 21,
					iconCls : 'icon-detail'
				});
				$(".detailsBtn").tooltip({
					content : '详情',
					position : 'top',
				});
			},
		columns : [[
				{
					width : "19%",
					field : "sqrmc",
					title : "申请人",
					halign : "center",
					align : "center",
					resizable : true,
				},
				{
					width : "17%",
					field : "sqType",
					title : "申请类型",
					halign : "center",
					align : "center",
					resizable : true,
					formatter:function(value){
						if(value == 0){
							return "部门申领";
						}else if(value == 1){
							return "个人申领";
						}else if(value == 2){
							return "部门报损";
						}else {
							return "个人报损";
						}
					}
				},
				{
					width : "17%",
					field : "sqsj",
					title : "申请时间",
					halign : "center",
					align : "center",
					resizable : false,
					formatter:function(value){ 		    		  
						 var date=new Date(value);
			    		  var year=date.getFullYear();
			    		  var month = date.getMonth() + 1;
			    		  var day=date.getDate();
			    		  var hour=date.getHours();
			    		  var min=date.getMinutes();
			    		  var second=date.getSeconds();
			    		  month=checkTime(month);
			    		  day=checkTime(day);
			    		  hour=checkTime(hour);
			    		  min=checkTime(min);
			    		  second=checkTime(second);
			    		  return finalDate = year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + second;
			    	}
				},
				{
					width : "17%",
					field : "deptName",
					title : "申请部门",
					halign : "center",
					align : "center",
					resizable : true,
				},
				{
					width : "17%",
					field : "status",
					title : "审批结果",
					halign : "center",
					align : "center",
					resizable : true,
					formatter:function(value){
						if(value == 0){
							return "未提交";
						}else if(value == 1){
							return "待审批";
						}else if(value == 2){
							return "同意";
						}else {
							return "拒绝";
						}
					}
				},
				{
					width : "15%",
					field : "opt1",
					title : "&emsp;&emsp;&emsp;&emsp;&emsp;操作",
					align : "left",
	                formatter: function(value, row, index) {
	                	if(row.status == 0){
	                		return '&nbsp;&nbsp;<a href="#" class="editBtn" onclick="objGRYHPSQ.edit()"></a>&nbsp;&nbsp;<a href="#" class="deleteBtn" onclick="objGRYHPSQ.del('+'&quot;'+row.dm+'&quot;'+')" ></a>&nbsp;&nbsp;<a href="#" class="submitBtn" onclick="objGRYHPSQ.submit()" ></a>';
	                	}else{
	                		return '&nbsp;&nbsp;<a href="#" class="detailsBtn" onclick="objGRYHPSQ.details()"></a>';
	                	}
	                },
					resizable : false,
				}, ] ],
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
			toolbar : "#lossingGRYHPToolbar",
			emptyMsg : "没有找到符合条件的记录",
		});
		function checkTime(i){
			if(i<10){
				return "0"+i;
			}
			return i;
		}
	</script>
</body>
</html>