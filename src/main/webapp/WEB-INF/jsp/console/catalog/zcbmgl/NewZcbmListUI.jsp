<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML>
<html>
  <head>

    <title>My JSP 'NewZcbmList.jsp' starting page</title>
  </head>

  <body>
  <style type="text/css">
  	.tree-title {
  		font-size: 16px;
  		font-family: 微软雅黑;
  	}
  </style>
  <div id="NewZcbmListMain">
	<div id="cc" class="easyui-layout" style="width:100%;height:100%;">   
    <div data-options="region:'north',split:false" style="height:39px;">
  	 	 <form id="downLoadForm" method="post">
			<input type="hidden" name="randomInfo" value="<%=Math.random()%>"/>
		 </form>
	 	 <table> 
	 	 	<tr>
	 	 	<td style="padding-left:20px"><a href="#" class="easyui-linkbutton" plain="true" iconCls="icon-export"  onclick="objNewZCBM.ZCBMExcelExport()">导出</a></td>
	 	 	</tr>
	 	 </table>
    </div>   
    <div data-options="region:'west'" style="width:40%;">
    	<div  style="width: 100%; height: 100%;">
    		<ul  id="wxdeptTree" ></ul>
    	</div>
    </div>   
    <div data-options="region:'center'" style="padding:5px;background:#eee;">
    	<form id="ZcbmGLForm" method="post">
  			<table class="mytable" style="margin-top:25%">
				<tr><td align="right">&nbsp;易耗品负责人：</td><td><input type="text"  id="fzr" name="fzrmc"  /></td></tr>
				<tr><td align="right">固定资产管理员：</td><td><input type="text"  id="glr" name="glrmc"  /></td></tr>
			</table>
      		<table align="center" style="margin-top:40px">
				<tr>
					<td align="center"><a id="saveBtn" href="#">保存</a></td>
				</tr>
			</table>
    	</form>
    </div>   
	</div> 
</div>
  <script type="text/javascript">
  	$(function(){
		$("#NewZcbmListMain").dialog({
			title: "资产部门列表",
			width: 1024,
			height: 600,
			closed: false,
			shadow: true,	//是否显示阴影
			modal: true,	//是否窗口化
			cache: false,	//是否缓存
			inline: true,	//设置是否在父容器中显示，不在会出现很多问题
			resizable: false	//是否可改变大小
		});
		
		 var czcgl=null;
		
		function isJSON(str) {
		    if (typeof str == 'string') {
		        try {
		            JSON.parse(str);
		            return true;
		        } catch(e) {
		            console.log(e);
		            return false;
		        }
		    }
		    console.log('It is not a string!');    
		}
		
		
    	 //加载用户树
         $('#wxdeptTree').tree({
             url: getContextPath() + "/console/wxgl/wxdept/getWXQYDeptTree.do",
             lines: true,
             animate: true,	//定义节点在展开或折叠的时候是否显示动画效果。
             queryParams: {isQY: true},
             onClick: function(node){
				if(node.children.length==0){
					$.ajax({
						url: getContextPath()+"/console/catalog/zcbmgl/queryZCGL.do",
						type: "post",
						dataType: "text",
						data: {"dept_id": node.id},
						async: true,
						cache: false,
						success: function(data){
							if(!isJSON(data)){
								$.messager.alert('提示',data,"info");
							}else{
								czcgl=JSON.parse(data);
								$("#fzr").textbox("enable");
								$("#glr").textbox("enable");
								$("#saveBtn").linkbutton("enable");
								$("#fzr").textbox("setValue",czcgl.fzrmc);
								$("#fzr").attr("userid",czcgl.fzr);
								$("#glr").textbox("setValue",czcgl.glrmc);
								$("#glr").attr("userid",czcgl.glr);
							}
						},
						error: function(){
							alert("Ajax Error!");
						}
					});
				}else{
					$("#fzr").textbox("setValue",null);
					$("#fzr").textbox("disable");
					$("#glr").textbox("setValue",null);
					$("#glr").textbox("disable");
					$("#saveBtn").linkbutton("disable");
				}
			 }
         });
		
		$("#saveBtn").linkbutton({
			iconCls: 'icon-save',
			height: 39
		});
		
		$("#fzr").searchbox({
			searcher: function(value,name){
				objNewZCBM.queryWXUser("queryFZRUIDialog", "/console/wxgl/wxuser/queryWXUserUI.do", "查找部门负责人", {isEdit:true},"fzr");   
			},
			required: true,
			editable: false,
			width: 300
		});
		
		
		$("#glr").searchbox({
			searcher: function(value,name){
				objNewZCBM.queryWXUser("queryGLRUIDialog", "/console/wxgl/wxuser/queryWXUserUI.do", "查找资产管理员", {isEdit:true},"glr");
			},
			required: true,
			editable: false,
			width: 300
		});
		
		
		
		$("#saveBtn").click(function(){
			if($("#saveBtn").linkbutton('options').disabled==false){
				$.messager.progress();
				$("#ZcbmGLForm").form("submit",{
					url: getContextPath()+"/console/catalog/zcbmgl/updateZCBM.do",
					onSubmit: function(param){
						param.id = czcgl.id;
						var isValid = $(this).form('validate');
						if (!isValid){
							$.messager.progress('close');
							$.messager.alert('提示','请按照要求填写表单','info');  
						}
						param.fzr=$("#fzr").attr("userid");
						param.glr=$("#glr").attr("userid");
						return isValid;
					},
					
					success: function(result){
						$.messager.progress("close");
						if(result=="success"){
							$.messager.alert("提示","修改成功！","info");
						}else{
							$.messager.alert("提示",result,"info");
						}
					},
					error: function(){
						$.messager.alert("提示","修改失败！","info");
					}
				});
			}
		});
		
		});
		
	var objNewZCBM = {
 				ZCBMExcelExport : function(){
				$.messager.confirm('导出', '确定要导出资产部门表格吗？', function(r){
					if (r){
						downloadZCBMExcel();
					}
				});
			},
			queryWXUser: function(dialogId,url,title,param,searchboxId){
            		dialogObj = $('<div id="' + dialogId + '"></div>');
            		wxuser=null;
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
	                        if(wxuser!=null){
	                        	$("#"+searchboxId).searchbox("setValue",wxuser.name);
	                        	$("#"+searchboxId).attr("userid",wxuser.userid);
	                        }
	                        dialogObj.remove();// 关闭时remove对话框
	                    }
	                });
            	}
 		};
 		
 	function downloadZCBMExcel(){
 			$("#downLoadForm").form('submit', {
			url : getContextPath() + "/console/catalog/zcbmgl/exportZCBMExcel.do",
			success: function(data){
				if(data != '"success"'){
					$.messager.alert('失败',data,'warning');
				}
			}
		});
	};
	
 	</script>
  </body>
</html>
