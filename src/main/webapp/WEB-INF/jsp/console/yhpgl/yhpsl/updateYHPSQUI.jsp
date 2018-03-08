<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>编辑低值易耗品申领单</title>
</head>
<body>
	<div id="updateBMYHPSQ">
		<table id="updateBMYHPDatagrid"></table>
		<table align="center">
			<tr>
				<td width="30%"/></td>
				<td width='10%' align="center"><a href="#" id="BMYHP_Update">确定</a></td>
				<td width='20%'></td>
				<td width='10%' align="center"><a href="#" id="BMYHP_UpdCancel">取消</a></td>
				<td></td>
			</tr>
		</table>
	</div>
	<script type="text/javascript">
	var updateBMYHP = $("#leadingBMYHPDatagrid").datagrid("getSelected");
	$("#BMYHP_Update").linkbutton({
		plain: true,
		iconCls:"icon-ok",
	});
	$("#BMYHP_Update").click(function(){
		$.messager.progress();
		var updateParam = new Array();
		var data = $("#updateBMYHPDatagrid").datagrid("getData");
		for(var i = 0; i < data.total;i++){
			var num = $("#insertSQNum"+i).numberspinner("getValue");
			if(num > data.rows[i].num){
				$.messager.alert('提示',"第" + (i+1) + "行申请数量大于持有数量，请申请少于持有数量的易耗品。",'waring');
				$.messager.progress('close');
				return false;
			}
			if(num != 0){
				updateParam.push("{\"yhpId\":"+data.rows[i].yhpId+",\"yhpNum\":"+num+"}");
			}
		}
		$.ajax({
            type:"post",
            url:getContextPath() + "/console/yhpgl/yhpsl/updateYHPSQ.do",
            dataType:"text",
            cache: false,
            async: true,
            data:{"sqNumMap":updateParam.toLocaleString(),"sqdm":updateBMYHP.dm},
            success: function(data){
            	$.messager.progress('close');
            	if(data == "success"){
            	    $("#updateBMYHPSQ").dialog("close");
            	    $("#leadingBMYHPDatagrid").datagrid('reload');
            	}else{
					$.messager.alert('失败',data,'waring');
				}
            },
            error: function() {
                $.messager.progress('close');
                $.messager.alert('失败',"编辑失败",'waring');
            }
     });
	});
	
	$("#BMYHP_UpdCancel").linkbutton({
		plain: true,
		iconCls:"icon-cancel",
	});
	
	$("#BMYHP_UpdCancel").click(function(){
		$("#updateBMYHPSQ").dialog('close');
	});
	$("#updateBMYHPDatagrid").datagrid({
			height : 530,
			method : "post",
			url : getContextPath() + "/console/yhpgl/yhpsl/getYHPSQXZList.do?sqdm=" + updateBMYHP.dm,
			onLoadSuccess : function(data) {
				$(".sqslSpinner").numberspinner({
					min:0,
					max : 10000,
					editable: true,
					width:55,
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
				for(var i=0;i<data.total;i++){
					$("#sqslSpinner" + i).numberspinner("setValue",data.rows[i].sqNum);
				}
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
							field : "opt1",
							title : "申请数量",
							align : "center",
			               formatter: function(value, row, index) {
			            	   return '<div><input id="insertSQNum'+ index +'" class="sqslSpinner" value="'+ row.sqNum +'"></div>';
			               },
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