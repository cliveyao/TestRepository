<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>提交低值易耗品申领单</title>
</head>
<body>
<body>
	<div id="submitBMYHPSQ">
		<table id="submitBMYHPDatagrid"></table>
		<table align="center">
			<tr>
				<td width="30%"/></td>
				<td width='10%' align="center"><a href="#" id="BMYHP_SubmitBtn">确定</a></td>
				<td width='20%'></td>
				<td width='10%' align="center"><a href="#" id="BMYHP_SubCancel">取消</a></td>
				<td></td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
	var submitBMYHP = $("#leadingBMYHPDatagrid").datagrid("getSelected");
	$("#BMYHP_SubmitBtn").linkbutton({
		plain: true,
		iconCls:"icon-ok",
	});
	$("#BMYHP_SubmitBtn").click(function(){
		$.messager.progress();
		$.ajax({
            type:"post",
            url:getContextPath() + "/console/yhpgl/yhpsl/submitYHPSQ.do",
            dataType:"text",
            cache: false,
            async: true,
            data:{"sqDm":submitBMYHP.dm},
            success: function(data){
            	$.messager.progress('close');
            	if(data == "success"){
            	    $("#submitBMYHPSQ").dialog("close");
            	    $("#leadingBMYHPDatagrid").datagrid('reload');
            	}
            },
            error: function() {
                $.messager.progress('close');
                $.messager.alert('失败',"提交失败",'waring');
            }
     });
	});
	
	$("#BMYHP_SubCancel").linkbutton({
		plain: true,
		iconCls:"icon-cancel",
	});
	
	$("#BMYHP_SubCancel").click(function(){
		$("#submitBMYHPSQ").dialog('close');
	});
	$("#submitBMYHPDatagrid").datagrid({
		height : 530,
		method : "post",
		url : getContextPath() + "/console/yhpgl/yhpsl/getYHPSQXZList.do",
		queryParams: {"sqdm":submitBMYHP.dm},
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
						width : "20%",
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
				emptyMsg : "没有找到符合条件的记录",
			});
	</script>
</body>
</html>