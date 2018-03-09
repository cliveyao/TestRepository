<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>资产信息</title>
</head>
<body>
	<div id="financeInfoDialog">
		<table id="financeDatagridToolbar"></table>
		<table id="financeDatagrid"></table>
	</div>
	<script type="text/javascript">
		$("#financeInfoDialog").dialog({
			title: '资产信息',    
		    width: 1024,    
		    height: 600,    
		    closed: false,    
		    cache: false,
		    //inline: true,
		    shadow: true, // 显示阴影
	        resizable: false // 不允许改变大小
		});
		
		var financeInfoObj={
			delFinance: function(financeId){
				$.ajax({
	       			  url: getContextPath()+"/console/zcxx/delFinance.do",
	       			  data: {id: financeId},
	       			  cache: false,
	       			  async: true,
	       			  dataType: 'text',
	       			  success: function(result){
	       				  if(result=="success"){
	       					$.messager.alert('提示','删除成功','info');
	       					$("#financeDatagrid").datagrid('reload');
	       				  }else{
	       					$.messager.alert('提示','删除失败','error');
	       				  }
	       			  },
	       			  error: function(){
	       				$.messager.alert('提示','AjaxError','error');
	       			  }
	       		  });
			}
		}
		
		$("#financeDatagrid").datagrid({
			url: getContextPath()+'/console/zcxx/getFinanceList.do',    
		    columns:[[    
		        {field:'transaction',title:'transaction',width:100},    
		        {field:'sendTime',title:'sendTime',width:100},    
		        {field:'pay',title:'pay',width:100,align:'right'},
		        {
		        	field:'operation',title:'operation',width:100,
		        	formatter: function (value,row,index) {
		        		return '<a class="delBtn" onclick="financeInfoObj.delFinance('+row.id+')">删除</a>';
		        	}
		        }
		    ]],
			onLoadSuccess: function () {
			  $(".delBtn").linkbutton ({
          		  height : 22,
          		  iconCls:"icon-del",
          		  plain : true,
          	  });
          	  $(".delBtn").tooltip({
          		  position: 'bottom',    
          		  content: '删除',
          	  });	
			},
			fit: true,
	        singleSelect: true,
	        pagination: true,
	        striped: true,
	        rownumbers: true,
	        emptyMsg : "没有数据", 
	        toolbar: "#financeDatagridToolbar",
	        pageSize: 15,
	        pageList: [15],
	        fitColumns: true
		});
	</script>
</body>
</html>