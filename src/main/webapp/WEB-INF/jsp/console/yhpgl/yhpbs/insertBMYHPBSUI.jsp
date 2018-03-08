<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>新增低值易耗品部门申领</title>
</head>
<body>
	<div id="insertBMYHPBS">
		<table id="insertBMYHPDatagrid"></table>
		<div id="insertBMYHPToolbar">
			<table align="center">
				<tr>
					<td>持有部门：</td>
					<td><input id="inputDept"></td>
				</tr>
			</table>
		</div>    
		<div>
			<table align="center">
				<tr>   
					<td width="30%"/></td>
					<td width='10%' align="center"><a href="#" id="BMYHP_Submit">确定</a></td>
					<td width='20%'></td>
					<td width='10%' align="center"><a href="#" id="BMYHP_Cancel">取消</a></td>
					<td></td>
				</tr>
			</table>
		</div>
	</div>
	<script type="text/javascript">
	var deptNo = null;
	var testOpt = {
	      	queryDeptName: function(dialogId,url,title,param,searchBoxId){
	      		dialogObj = $('<div id="' + dialogId + '"></div>');
				dialogObj.appendTo("body");
				$("#" + dialogId).dialog({
                  href: getContextPath() + url,
                  title: title,
                  queryParams: param,
                  width: 512,
                  height: 300,
                  cache: false,
                  collapsible: true,
                  modal: true,
                  draggable: true,
                  inline: true,
                  onClose: function() {
                      if(wxdept!=null){
                      	$("#"+searchBoxId).searchbox("setValue",wxdept.deptName);
                      	deptNo = wxdept.deptNo;
                      	testOpt.queryBMYHPList(wxdept.deptNo);
                      }
                      dialogObj.remove();// 关闭时remove对话框
                  }
              });
	      	},
	      	queryBMYHPList: function(deptNo){
				$("#insertBMYHPDatagrid").datagrid('options').queryParams={deptNo: deptNo};
				$("#insertBMYHPDatagrid").datagrid('reload');
			}
	};
	$('#inputDept').searchbox({
		required:true,  
		editable : false,
		width:200,
		onClickIcon:function(){
			var isChange = $("#insertBMYHPDatagrid").datagrid("getData");
			for(var i = 0; i < isChange.total;i++){
				var num = $("#insertBMNum" + i).numberspinner("getValue");
				if(num != 0){
					$.messager.confirm('确认','本申领单不能跨部门申领。如果点击确认，您已申请的易耗品将清空。',function(sure){ 
						if(sure){
							testOpt.queryDeptName("queryDeptName", "/console/wxgl/wxdept/queryQYWXDeptUI.do", "查找持有部门", {isEdit: false,isQY: true},"inputDept"); 
						}
					});
					break;
				}
			}
			if(i==isChange.total){
				console.log(i);
				testOpt.queryDeptName("queryDeptName", "/console/wxgl/wxdept/queryQYWXDeptUI.do", "查找持有部门", {isEdit: false,isQY: true},"inputDept"); 
			}
		},
	});
	
	$("#BMYHP_Submit").linkbutton({
		plain: true,
		iconCls:"icon-ok",
	});
	$("#BMYHP_Submit").click(function(){
		$.messager.progress();
		var insertBMParam = new Array();
		var data = $("#insertBMYHPDatagrid").datagrid("getData");
		for(var i = 0; i < data.total;i++){
			var num = $("#insertBMNum" + i).numberspinner("getValue");
			if(num > data.rows[i].num){
				$.messager.alert('提示',"第" + (i+1 ) + "行申请数量大于持有数量，请申请少于持有数量的易耗品。",'waring');
				$.messager.progress('close');
				return false;
			}
			if(num != 0){
				insertBMParam.push("{\"yhpId\":"+data.rows[i].yhpId+",\"yhpNum\":"+num+"}");
			}
		}
		if(data.total == 0 || $.trim(insertBMParam) == ''){
			$.messager.progress('close');
			$.messager.alert('提示',"请至少选择一个易耗品",'waring');
			return false;
		}
		$.ajax({
            type:"post",
            url:getContextPath() + "/console/yhpgl/yhpbs/insertBMYHPBS.do",
            dataType:"text",
            cache: false,
            async: true,
            data:{"sqNumMap":insertBMParam.toLocaleString(),"deptNo":deptNo},
            success: function(data){
            	$.messager.progress('close');
            	if(data == "success"){
            	    $("#insertBMYHPBS").dialog("close");
            	    $("#lossingBMYHPDatagrid").datagrid('reload');
            	}else{
					$.messager.alert('失败',data,'waring');
				}
            },
            error: function() {
                $.messager.progress('close');
                $.messager.alert('失败',"新增失败",'waring');
            }
     });
	});
	
	$("#BMYHP_Cancel").linkbutton({
		plain: true,
		iconCls:"icon-cancel",
	});
	
	$("#BMYHP_Cancel").click(function(){
		$("#insertBMYHPBS").dialog('close');
	});
	$("#insertBMYHPDatagrid").datagrid({
		height : 530,
		method : "post",
		url : getContextPath() + "/console/yhpgl/yhpsl/getYHPList.do",
		queryParams: {deptNo: -1},
		onLoadSuccess : function(data) {					
			$(".sqslSpinner").numberspinner({
				min:0,
				max : 10000,
				editable: true,
				width:55,
				value:0
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
						field : "opt1",
						title : "申请数量",
						align : "center",
		               formatter: function(value, row, index) {
		            	   return '<div><input id="insertBMNum'+ index +'" class="sqslSpinner"></div>';
		               },
						resizable : false,
					}, ]],
				pagination : false, //是否有分页工具
				striped : true, //斑马线样式,
				nowrap : true, //是否在一行显示所有，自动换行
				loadMsg : "努力加载中，请稍后。。。。",//加载信息
				toolbar : '#insertBMYHPToolbar',
				rownumbers : true, //是否显示行号
				singleSelect : true, //只能同时选择一行
				showHeader : true,//显示行头，默认true;
				emptyMsg : "没有找到符合条件的记录",
			});
	</script>
</body>
</html>