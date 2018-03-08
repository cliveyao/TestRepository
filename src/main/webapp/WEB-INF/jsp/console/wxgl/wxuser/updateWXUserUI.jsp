<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
<head>
<meta charset="UTF-8">
<title>编辑微信用户</title>
<style type="text/css">

</style>
</head>
<body>
   <div id="eidtWXUser">
   		<form id="updateWXUserInfo" method="post">
   			<table style="text-align:left;margin-top:40px" cellspacing="10px">
   				<tr><td width="100px" align="right">姓名：</td><td colspan="5"><input id="editWXUserName" name="name"/></td></tr>
   				<tr><td align="right" width="100px">所属部门：</td><td colspan="5"><input id="editWXUserDept"/></td></tr>
   				<tr>
   					<td align="right" width="100px">标签：</td>
   					<td>
						<input style="width:20px;" type="checkbox" name="lable" id="question1" value="维修组">维修组
						<input style="width:20px;" type="checkbox" name="lable" id="question2" value="巡检组">巡检组
						<input style="width:20px;" type="checkbox" name="lable" id="question3" value="部门资产管理员组">部门资产管理员组<br>
						<input style="width:20px;" type="checkbox" name="lable" id="question4" value="后勤管理人员组">后勤管理人员组
						<input style="width:20px;" type="checkbox" name="lable" id="question5" value="使用人组">使用人组
					</td>
				</tr>
		  </table>
   		</form>
        <table align="center"  style="padding-top: 40px;">
            <tr>
            	<td width="25%"></td>
                <td width="20%"><a id="submitUpdateBtn" href="#">确定</a></td>
                <td width="10%"></td>
                <td width="20%"><a id="cancelUpdateBtn" href="#">取消</a></td>
                <td width="25%"></td>
            </tr>
        </table>
   </div>
<script type="text/javascript">
	var userInfo =  $("#wxuserList").datagrid("getSelected");
	var question1 = document.getElementById('question1');
	var question2 = document.getElementById('question2');
	var question3 = document.getElementById('question3');
	var question4 = document.getElementById('question4');
	var question5 = document.getElementById('question5');
	var lableList = document.getElementsByName("lable");
	var deptNo = userInfo.deptList[0].deptNo;
	$(function(){
		for(var i=0;i < userInfo.tagList.length;i++){
			switch (userInfo.tagList[i].tagName){
			case "维修组" :
				question1.checked = true;
				break;
			case "巡检组" :
				question2.checked = true;
				break;
			case "部门资产管理员组" :
				question3.checked = true;
				break;
			case "后勤管理人员组" :
				question4.checked = true;
				break;
			case "使用人组" :
				question5.checked = true;
				break;
			default:
				break;
			}
		}
	});
	$("#editWXUserName").textbox({
		plain: true,
		required:true,
		value:userInfo.name,
	});
	
	$("#editWXUserDept").searchbox({
		plain: true,
		editable:false,
		required:true,
		value:userInfo.deptList[0].deptName,
		searcher:function(){
			testOpt.queryDeptName("queryWXUserDeptName", "/console/wxgl/wxdept/queryQYWXDeptUI.do", "查找申请部门", {isEdit: false,isQY: true},"editWXUserDept");
		}
	});
	
	$("#submitUpdateBtn").linkbutton({
		plain:true,
		iconCls:"icon-ok",
	});
	
	$("#cancelUpdateBtn").linkbutton({
		plain:true,
		iconCls:"icon-cancel",
	});
	
	$("#cancelUpdateBtn").bind('click',function(){
		$("#editWXUser").dialog("close");
	});
	
	$("#submitUpdateBtn").bind('click',function(){
    	$.messager.progress();	
    	$("#updateWXUserInfo").form('submit',{
    		url : getContextPath() + "/console/wxgl/wxuser/updateWXUser.do",    
   		    onSubmit: function(param){
   		    	var isValid = $(this).form('validate');
   		    	param.userid = userInfo.userid;
   		    	param.deptNo = deptNo;
   		    	var tagNoString = [];
   		    	for(k in lableList){
   		    		if(lableList[k].checked){
   		    			tagNoString.push(lableList[k].value);
   		    		}
   		    	}
   		    	param.tagNoString = tagNoString;
				if (!isValid){
					$.messager.progress('close');	
				}
				 return isValid;
   		    },
   		    success:function(data){
   		    	$.messager.progress('close');
   		    	if(data == "success"){
   		    		$("#editWXUser").dialog("close");
   		    		$("#wxuserList").datagrid("reload");
   					$.messager.alert('成功','编辑微信用户成功','info');
   				} else{
   					$.messager.alert('失败',data,'waring');
   				}
   		    },
    	});
	});
	
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
                      }
                      dialogObj.remove();// 关闭时remove对话框
                  }
              });
	      	},
	};
</script>
</body>
</html>