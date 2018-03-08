<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
  <head>
  </head>
  
 <body>
 	<div>
 		<form id="importBMZCExcel_uploadForm" enctype="multipart/form-data" method="post">
	 		<table align="center" cellspacing="5px" style="padding-top: 50px;">
	 			<tr>
	 				<td>选择文件：</td>
	 				<td><input id="importBMZCExcel_fbfile" name="file_upload" type="text" style="width:250px"/><span style="color:#FF0000;margin-left: 3px;">*</span></td>
	 				<td><a id="importBMZCExcel_doUploadBtn" href="#" class="easyui-linkbutton" iconCls="icon-ok" style="color:black" onclick="importBMZCExcel.doUpload()">确定</a></td>
	 			</tr>
	 		</table>
 		</form>
 	</div> 
 <script type="text/javascript">
 
 	$("#importBMZCExcel_fbfile").filebox({
	    buttonText: '选择文件', 
	    buttonAlign: 'left' ,
	    multiple: false,
	    accept:"application/vnd.ms-excel",  //重要
	    required: true,
 	});
 	$("#importBMZCExcel_doUploadBtn").linkbutton({
 		iconCls : 'icon-ok',
 		onClick : function(){
 			objUpd.doUpload();
 		},
 	});
 	
 	var importBMZCExcel  = {
 			
 			doUpload : function(){
 	 			if($.trim($("#importBMZCExcel_fbfile").filebox("getText")) == ""){
 	 				$.messager.progress('close');
 	 				$.messager.alert('警告','请选择excel文件','warning');
 	 				return false;
 	 			};
 	 			$.messager.confirm('确定','您确认要上传选中的Excel吗？',function(result){
 	 				if(result){
 	 					$.messager.progress();
 	 					$('#importBMZCExcel_uploadForm').form('submit',{
 	 						url : getContextPath() + "/console/zcgl/regist/importBMZCExcel.do",
 	 						success : function(data){
 	 							$.messager.progress('close');
 	 							if(data == 'success') {
 	 								$("#dgregistBMZCList").datagrid('reload');
 	 								$("#registBMZCList_newImportZCDlg").dialog('close');
 	 								$.messager.alert('成功','导入成功','info');
 	 							}else{
 	 								$.messager.alert('失败',data,'warning');
 	 							}
 	 						}
 	 					});
 	 				}
 	 			});
 			}
 	};
 </script>  
 </body>
</html>
