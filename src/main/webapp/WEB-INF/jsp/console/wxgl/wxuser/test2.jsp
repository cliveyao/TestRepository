<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>存放地点测试页面</title>

	
	<link rel="stylesheet" type="text/css" href="${pageContext.servletContext.contextPath }/js/easyui/themes/default/easyui.css">
	<link rel="stylesheet" type="text/css" href="${pageContext.servletContext.contextPath }/js/easyui/themes/icon.css">
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/js/easyui/jquery.min.js"></script>
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/js/easyui/jquery.easyui.min.js"></script>
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/js/easyui/locale/easyui-lang-zh_CN.js"></script>
	<script type="text/javascript" src="${pageContext.servletContext.contextPath }/js/swh_admin.js"></script>
	<style type="text/css">
	body {
		margin-left: 0px;
		margin-top: 0px;
		margin-right: 0px;
		margin-bottom: 0px;
	}
	</style>
</head>
<body>
<div style="margin-top: 25%;">
	<h1 align="center">存放地点测试页面</h1>
	<table align="center">
		<tr>
			<td align="right">选择存放地点：</td>
			<td><input id="selectCFDD" disabled="disabled" name="wxdept" /></td>
			<td><a id="searchCFDD" href="#"></a></td>
			<td><input id="ss" class="easyui-numberspinner" style="width:80px;">  </td>
		</tr>
	</table>
</div>
<script type="text/javascript">
	$('#selectCFDD').textbox({
		required : true,
		editable : false,
	});
	$('#searchCFDD').linkbutton({    
		iconCls: 'icon-search'   
	});
	
	$('#searchCFDD').bind('click', function(){ 
		testDialog.newDialog("selectCFDD");
		
	});    
	
	$('#ss').numberspinner({    
	    min: 0,    
	    max: 1000,    
	    value : 0
	});  

	var testDialog = {
			newDialog : function (textboxName) {
				var queryCFDDUI = $("<div id='queryCFDDUI'></div>");
				queryCFDDUI.appendTo("body");
				vfj = null;
				$("#queryCFDDUI").dialog({
					title : "查找存放地点",
					href : getContextPath() + "/console/catalog/fjgl/queryCFDDUI.do",
					height : 300,
					width : 512,
					closed : false,
					 onClose: function() {
						 if (vfj != null){
							 queryCFDDUI.remove();
							 $('#' + textboxName).textbox("setText",vfj.xqmc + vfj.jzw + vfj.floor+vfj.room);
						 }
	                 }
				});
			}
	};
</script>
</body>
</html>