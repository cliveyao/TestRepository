<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
    <meta charset="UTF-8">
<title>同步微信用户</title>
</head>
<body>
  <div id="syncWXUser" class="easyui-layout" fit="true">
    <div data-options="region:'north'" align="center" style="height:35px;" >
		<table align="center" cellspacing="1px" style="padding-top: 2px;">
			<tr>
				<td style="text-align:right;">微信账号：</td>
				<td><input id="queryWXUser" style="width:175px"/></td>
				<td><a href="#" id="syncWXUserBtn"></a></td>
			</tr>
		</table>
	</div>
	<div data-options="region:'center',iconCls:'icon-more',collapsible:false" style="width:100%;padding-top:5%;" border="false">
		<table align="center" style="text-align:right;" cellspacing="5px">
			<tr><td>姓名：</td><td><input id="wxUserNaem"/></td></tr>
			<tr><td>电话：</td><td><input id="userTelephone"/></td></tr>
			<tr><td>所属部门：</td><td><input id="userDeptName"/></td></tr>
			<tr><td>标签：</td><td><input id="userLable"/></td></tr>
		</table>
	</div >
    <div data-options="region:'south'" style="height:35px;"border="false">
        <table align="center">
            <tr>
                <td><a id="cancelSyncBtn" href="#">关闭</a></td>
            </tr>
        </table>
     </div>
  </div>
<script type="text/javascript">
	$("#queryWXUser").textbox({
		required:true,
		editable:true,
		plain:true,
	});
	
	$("#syncWXUserBtn").linkbutton({
		iconCls:"icon-sync",
	});
	
	$("#syncWXUserBtn").tooltip({
		content : '同步',
		position : 'bottom',
	});
	
	$("#cancelSyncBtn").linkbutton({
		iconCls:"icon-cancel",
		pinal:true,
	});
	
	$("#cancelSyncBtn").bind('click',function(){
		$("#syncWXUser").dialog("close");
	});
	
	$("#wxUserNaem").textbox({
		editable:false,
		plain:true,
		width:300,
	});
	
	$("#userTelephone").textbox({
		editable:false,
		plain:true,
		width:300,
	});
	
	$("#userDeptName").textbox({
		editable:false,
		plain:true,
		width:300,
	});
	
	$("#userLable").textbox({
		editable:false,
		plain:true,
		width:300,
	});
	
	$("#syncWXUserBtn").bind('click',function(){
		var userid = $("#queryWXUser").textbox("getValue");
		if($.trim(userid) == null || $.trim(userid) == ''){
			$.messager.alert('提示',"微信账号不能为空！！！");
			return false;
		}
		$.messager.progress();
 		$.ajax({
 			url:getContextPath() + "/console/wxgl/wxuser/syncWXUser.do",
 			async:true,
 			cache:false,
 			type:'post',
 			dataType:"json",
 			data:{"userid":userid},
 			success: function(result) {
				$.messager.progress('close');
				if(result != null){
					var deptName = "";
					var tagName = "";
					for(var i=0;i < result.deptList.length;i++){
						deptName +=  result.deptList[i].deptName + "-";
					}
					for(var i=0;i < result.tagList.length;i++){
						tagName += result.tagList[i].tagName + "-";
					}
					deptName = deptName.substring(0,deptName.length - 1);
					tagName = tagName.substring(0,(tagName.length - 1));
					$("#wxUserNaem").textbox("setText",result.name);
					$("#userTelephone").textbox("setText",result.mobile);
					$("#userDeptName").textbox("setText",deptName);
					$("#userLable").textbox("setText",tagName);
					$("#wxuserList").datagrid("reload");
				}else{
					$.messager.alert('失败',result);
				}
            },
            error: function() {
                $.messager.progress('close');
                $.messager.alert('失败', '查询微信用户信息失败');
            }
 		});
	});
</script>
</body>
</html>