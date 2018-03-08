<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
  
<body>
<form id="assignBMZCForm" method="post">
		<table class="mytable">
		  <tr><td style="text-align: right;">资产代码：</td><td><input id="assignBMZCUI_txbzcdm" name="dm"/></td><td></td></tr>
		  <tr><td style="text-align: right;">资产名称：</td><td><input id="assignBMZCUI_txbzcmc" name="mc"/></td><td></td></tr>
		  <tr><td style="text-align: right;">资产类型：</td><td><input id="assignBMZCUI_txbzclx" name="lxid"/></td><td></td></tr>
		  <tr><td style="text-align: right;">资产管理部门：</td><td><input id="assignBMZCUI_txbzcgl" name="zcgl"/></td></tr>
		  <tr><td style="text-align: right;">资产使用人：</td><td><input id="assignBMZCUI_txbsyr" name="syrname" userid="syr"/><span style="color:#FF0000;margin-left: 3px;">*</span></td></tr>
		</table>
	</form>
	<table>
	  <tr><td style="height: 10px;"></td></tr>
	  <tr><td style="width:120px;"></td><td style="width:100px;text-align: center;"><a onclick="assignBMZCUI.submitAssignZC()" data-options="iconCls:'icon-ok'" class="easyui-linkbutton">确认</a></td><td style="width:150px;text-align: center;"><a data-options="iconCls:'icon-cancel'" onclick="assignBMZCUI.cancel()" class="easyui-linkbutton">取消</a></td></tr>
	</table>
<script>

var assignBMZCUI = {
		
	cancel: function () {
		$("#registBMZCList_newAssignDlg").dialog("close");
	},
	
	query_syr: function (){
		
		dialogObj = $("<div id='dialogObj'></div>");
		wxuser  = null;
		dialogObj.appendTo("body");
		$("#dialogObj").dialog({
			href: getContextPath() + "/console/wxgl/wxuser/queryWXUserUI.do",
			title: "资产使用人查询",
			width: 512,
			height: 300,
			modal: true,
			inline: true,
			queryParams: {isEdit:true},
			onClose: function () {
				if(wxuser!=null){
					$("#assignBMZCUI_txbsyr").searchbox("setValue",wxuser.name);
					$("#assignBMZCUI_txbsyr").attr("userid",wxuser.userid);
				}
				dialogObj.remove(); 
			}
		});
		
			
	},
	
	submitAssignZC: function () {
		$.messager.progress();
		$("#assignBMZCForm").form("submit",{
			url:getContextPath() + "/console/zcgl/regist/assignBMZC.do",
			onSubmit: function (param) {
				var valid = $("#assignBMZCForm").form("validate");
				if (!valid){
					$.messager.progress("close");
					return false;
				}
				param.zcid = assignRow.zcid;
				param.syr=$("#assignBMZCUI_txbsyr").attr("userid");
			},
			success: function (result) {
				$.messager.progress('close');
				if (result=="success") {
					
				  $("#registBMZCList_newAssignDlg").dialog("close");
			      $("#dgregistBMZCList").datagrid("reload");
			      
				} else {
					$.messager.alert("提示",result,"info");
				}
				
			},

			
		});
		
	}
	
};

$("#assignBMZCUI_txbzcdm").textbox({
	disabled: true,
	iconCls:'icon-lock', 
    iconAlign:'right' ,
	value: assignRow.zcdm
});
$("#assignBMZCUI_txbzcmc").textbox({
	disabled: true,
	iconCls:'icon-lock', 
    iconAlign:'right' ,
	value: assignRow.zc
});

$("#assignBMZCUI_txbzclx").textbox({
	disabled: true,
	iconCls:'icon-lock', 
    iconAlign:'right' ,
	value: assignRow.zclx	
});

$("#assignBMZCUI_txbzcgl").textbox({
	disabled: true,
	iconCls:'icon-lock', 
    iconAlign:'right' ,
    value:assignRow.deptName
});

$("#assignBMZCUI_txbsyr").searchbox({
	required: true,
	editable: false,
	searcher: function(value,name){
		assignBMZCUI.query_syr();
	}
});


</script>
</body>
</html>
