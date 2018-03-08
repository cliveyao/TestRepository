<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>低值易耗品申领单详情</title>
</head>
<body>
	<div id="detailsBMYHPSQ">
		<table id="detailsBMYHPDatagrid"></table>
		<div id="detailsBMYHPToolbar">
			<table align="center" >
				<tr>
					<td style="padding-left:15px">申请人：</td><td><input id="sqrTextbox"></td>
					<td style="padding-left:10px">申请类型：</td><td><input id="sqlxTextbox"></td>
					<td style="padding-left:10px">申请时间：</td><td><input id="sqsjTextbox"></td>					
					<td style="padding-left:10px">审批结果：</td><td><input id="spjgTextbox"></td>
				</tr>
				<tr>
					<td>申请部门：</td><td colspan="7"><input id="sqbmTextbox"></td>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	var detailsBMYHP = $("#leadingBMYHPDatagrid").datagrid("getSelected");
	var showDatails = detailsBMYHP;
	$(function(){
		if(detailsBMYHP.sqType == 0 || detailsBMYHP.sqType == "部门申领"){
			showDatails.sqType = "部门申领";
		}else if(detailsBMYHP.sqType == 1 || detailsBMYHP.sqType == "个人申领"){
			showDatails.sqType = "个人申领";
		}else if(detailsBMYHP.sqType == 2 || detailsBMYHP.sqType == "部门报损"){
			showDatails.sqType = "部门报损";
		}else {
			showDatails.sqType = "个人报损";
		}
		  var date=new Date(detailsBMYHP.sqsj);
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
		  showDatails.sqsj = year + "-" + month + "-" + day + " " + hour + ":" + min + ":" + second;
		  
		  if(detailsBMYHP.status == 0 || detailsBMYHP.status == "未提交"){
			  showDatails.status =  "未提交";
			}else if(detailsBMYHP.status == 1 || detailsBMYHP.status == "待审批"){
				showDatails.status = "待审批";
			}else if(detailsBMYHP.status == 2 || detailsBMYHP.status == "同意"){
				showDatails.status = "同意";
			}else {
				showDatails.status = "拒绝";
			}
	});
	
	$('#sqrTextbox').textbox({
		width:'125',
		editable:false,
		value:detailsBMYHP.sqrmc,
		iconCls: 'icon-lock', 
		readonly: true,
	});
	
	$('#sqlxTextbox').textbox({
		width:'125',
		editable:false,
		value:showDatails.sqType,
		iconCls: 'icon-lock', 
		readonly: true,
	});
	$('#sqsjTextbox').textbox({
		width:'125',
		editable:false,
		value:showDatails.sqsj,
		iconCls: 'icon-lock', 
		readonly: true,
	});
	$('#sqbmTextbox').textbox({
		width:'735',
		editable:false,
		value:showDatails.deptName,
		iconCls: 'icon-lock', 
		readonly: true,
	});
	$('#spjgTextbox').textbox({
		width:'125',
		editable:false,
		value:showDatails.status,
		iconCls: 'icon-lock', 
		readonly: true,
	});
	$("#detailsBMYHPDatagrid").datagrid({
		height : 560,
		method : "post",
		url : getContextPath() + "/console/yhpgl/yhpsl/getYHPSQXZList.do",
		queryParams: {"sqdm": detailsBMYHP.dm},
		onLoadSuccess : function() {
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
						width : "20%",
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
						width : "20%",
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
						width : "20%",
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
						width : "20%",
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
						width : "10%",
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
						width : "10%",
						field : "sqNum",
						title : "申请数量",
						align : "center",
						resizable : false,
					}, ]],
			pagination : false, //是否有分页工具
			striped : true, //斑马线样式,
			nowrap : true, //是否在一行显示所有，自动换行
			loadMsg : "努力加载中，请稍后。。。。",//加载信息
			rownumbers : true, //是否显示行号
			singleSelect : true, //只能同时选择一行
			showHeader : true,//显示行头，默认true;
			toolbar:"#detailsBMYHPToolbar",	
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