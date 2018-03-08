<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
  
<body>
	<div id="dlgregistBMZCList">
		<div id="tbregistBMZCList" style="width: 100%;height:30px;padding-top: 10px;">
			<div style="float:left;">
				<div style="float:left;line-height: 25px;padding-left: 10px;"><a class="easyui-linkbutton" data-options="iconCls: 'icon-add'" plain=true onclick="registBMZCList.registZC()">登记</a></div>
				<div style="float:left;line-height: 25px;padding-left: 10px;"><a class="easyui-linkbutton" data-options="iconCls: 'icon-import'" plain=true onclick="registBMZCList.importZC()">导入</a></div>
				<div style="float:left;line-height: 25px;padding-left: 10px;"><a class="easyui-linkbutton" data-options="iconCls: 'icon-download'" plain=true onclick="registBMZCList.exportZC()">模板</a></div>
				<form id="BMZCList_downLoadForm" method="post">
					<input type="hidden" name="randomInfo" value="<%=Math.random()%>"/>
				 </form>
			</div>
			<div style="float:right;">
				<div style="float:left;line-height: 25px;">资产名称：</div><div style="float:left;padding-right: 10px;"><input id="registBMZC_txbZcmc" name="zcmc"/></div>
				<div style="float:left;line-height: 25px;">资产类型：</div><div style="float:left;padding-right: 10px;"><input id="registBMZC_searchbZclx" name="zclx"/></div>
				<div style="float:left;line-height: 25px;padding-right: 10px;"><a class="easyui-linkbutton" data-options="iconCls: 'icon-search'" href="#" onclick="registBMZCList.query()" plain= "true">筛选</a></div>
			</div>
		</div>
		<div id="dgregistBMZCList"></div>		
	</div>
<script>

	
	var registBMZCList = {
			
		query: function () {
			
			$("#dgregistBMZCList").datagrid("reload",{
				zcmc:$("#registBMZC_txbZcmc").val(),
				zclx:$("#registBMZC_searchbZclx").attr("lxid"),
			});
		},
		
		assignZC: function (index) {
			assignRow = $("#dgregistBMZCList").datagrid("getData").rows[index];
			var registBMZCList_newAssignDlg = $("<div id='registBMZCList_newAssignDlg'></div>");
			registBMZCList_newAssignDlg.appendTo("body");
			$("#registBMZCList_newAssignDlg").dialog({
				
				href: getContextPath() + "/console/zcgl/regist/assignBMZCUI.do",
				title: "资产分配",
				width: 512,
				height: 300,
				modal:true,
				
				onClose: function(){
					registBMZCList_newAssignDlg.remove();
				}
			});
		},
			
		revertZC: function (index) {
			revertRow = $("#dgregistBMZCList").datagrid("getData").rows[index];
			var registBMZCList_newRevertDlg = $("<div id='registBMZCList_newRevertDlg'></div>");
			registBMZCList_newRevertDlg.appendTo("body");
			$("#registBMZCList_newRevertDlg").dialog({
				
				href: getContextPath() + "/console/zcgl/regist/revertZCUI.do",
				title: "申请归还资产",
				width: 512,
				height: 300,
				modal:true,
				
				onClose: function(){
					registBMZCList_newRevertDlg.remove();
				}
			});
		},
		
		reassignZC: function (index) {
			reassignRow = $("#dgregistBMZCList").datagrid("getData").rows[index];
			var registBMZCList_newReassignDlg = $("<div id='registBMZCList_newReassignDlg'></div>");
			registBMZCList_newReassignDlg.appendTo("body");
			$("#registBMZCList_newReassignDlg").dialog({
				
				href: getContextPath() + "/console/zcgl/regist/reassignZCUI.do",
				title: "资产重新分配",
				width: 512,
				height: 300,
				modal:true,
				
				onClose: function(){
					registBMZCList_newReassignDlg.remove();
				}
			});
		},
		query_zclx: function () {
			dialogObj = $("<div id='dialogObj'></div>");
			czclx  = null;
			dialogObj.appendTo("body");
			$("#dialogObj").dialog({
				href: getContextPath() + "/console/catalog/zclxgl/queryZCLXUI.do",
				title: "资产类型查询",
				width: 512,
				height: 300,
				modal: true,
				onClose: function () {
					if(czclx != null) {
						dialogObj.remove();
						$("#registBMZC_searchbZclx").searchbox("setValue",czclx.mc);
						$("#registBMZC_searchbZclx").attr("lxid",czclx.lxId); 
					}
					dialogObj.remove();
				}
			});
		},
		
		importZC: function () {
			var registBMZCList_newImportZCDlg = $("<div id='registBMZCList_newImportZCDlg'></div>");
			registBMZCList_newImportZCDlg.appendTo("body");
			$("#registBMZCList_newImportZCDlg").dialog({
				
				href: getContextPath() + "/console/zcgl/regist/importBMZCExcelUI.do",
				title: "部门资产导入",
				width: 512,
				height: 200,
				modal:true,
				onClose: function(){
					registBMZCList_newImportZCDlg.remove();
				}
			});
		},
		
		exportZC: function () {
			$.messager.confirm("导出","确定下载部门资产模板表格吗？",function(result){
				if(result){
					$("#BMZCList_downLoadForm").form('submit', {
	 				url : getContextPath() + "/console/zcgl/regist/exportBMZCTempExcel.do",
	 				success: function(data){
	 					if(data != "success"){
	 						$.messager.alert('失败',data,'warning');
	 					}
	 				}
	 				});
				}
			});
		},
		registZC:function () {
			var registBMZCList_newRegistdlg = $("<div id='registBMZCList_newRegistdlg'></div>");
			registBMZCList_newRegistdlg.appendTo("body");
			$("#registBMZCList_newRegistdlg").dialog({
				
				href: getContextPath() + "/console/zcgl/regist/insertRegistBMZCUI.do",
				title: "资产登记",
				width: 512,
				height: 300,
				modal:true,
				inline: true,
				onClose: function(){
					registBMZCList_newRegistdlg.remove();
				}
			});
		}

	};

	$("#dlgregistBMZCList").dialog({
		title: "部门资产登记列表",
		width: 1024,
		height: 600,
        cache: false,
        shadow: true, // 显示阴影
        resizable: false, // 不允许改变大小
        modal: true, // 模式化窗口，锁定父窗口
        inline: true, // 是否在父容器中，若不在会出现很多BUG
	});
	
	$("#registBMZC_txbZcmc").textbox({});
	
	$("#registBMZC_searchbZclx").searchbox({
		editable:false,
     	searcher: function(value,name){
     		registBMZCList.query_zclx();
     	}
	});
	
	$("#registBMZC_searchbBM").searchbox({
		editable:false,
     	searcher: function(value,name){
     		registBMZCList.query_dept();
     	}
	});
	
	$("#dgregistBMZCList").datagrid({
		url: getContextPath() + "/console/zcgl/regist/bmzcList.do",
		fit: true,
        singleSelect: true,
        pagination: true,
        striped: true,
        rownumbers: true,
        toolbar: "#tbregistBMZCList",
        pageSize: 15,
        pageList: [15],
        emptyMsg : "没有数据", 
        columns: [
                  [{
                      field: 'zcdm',
                      title: '资产编号',
                      align: 'center',
                      width: '10.2%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,
                  }, {
                      field: 'zc',
                      title: '资产名称',
                      align: 'center',
                      width: '15.1%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,
                  }, {
                      field: 'zclx',
                      title: '资产类型',
                      align: 'center',
                      width: '12.8%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,
                  }, {
                      field: 'syrmc',
                      title: '使用人',
                      align: 'center',
                      width: '9%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,

                  }, {
                      field: 'num',
                      title: '资产数量',
                      align: 'center',
                      width: '10%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,

                  }, {
                      field: 'deptName',
                      title: '所属部门',
                      align: 'center',
                      width: '10%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,
                      

                  }, {
                      field: 'glrmc',
                      title: '部门资产管理员',
                      align: 'center',
                      width: '10%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,

                  }, {
                      field: 'zcztmc',
                      title: '资产状态',
                      align: 'center',
                      width: '10%',
                      formatter:function(value,row){ 
                           var content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";   
                           if(value==null){
                        	   value="";
                        	   return  content = "<span title='<div><img src="+getContextPath()+row.picUrl+"_m.jpg /></div>' class='tip'>"+value+"</span>";
                           }
                           return content;  
                       },
                      resizable: false,


                  }, {
                      field: 'opt',
                      title: '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;操作',
                      align: 'left',
                      width: '15%',
                      resizable: false,
                      formatter:function (value,row,index) {
                    	  if (row.zczt==0) {
	                    	  return "&nbsp;&nbsp;<a class='registBMZC_assignZcBtn' onclick='registBMZCList.assignZC("+index+")' href='#'></a>&nbsp;&nbsp;<a class='registBMZC_revertZcBtn' onclick='registBMZCList.revertZC("+index+")' href='#'></a>";
                    	  }
                    	  if (row.zczt == 10) {
                    		  return "&nbsp;&nbsp;<a class='registBMZC_reassignZcBtn' onclick='registBMZCList.reassignZC("+index+")' href='#'></a>";
                    	  }
                    	  if (row.zczt == 13) {
                    		  return "&nbsp;&nbsp;<a class='registBMZC_checkZcBtn' onclick='registBMZCList.check("+index+")' href='#'></a>&nbsp;&nbsp;<a class='registBMZC_delZcBtn' onclick='registBMZCList.del("+index+")' href='#'></a>";
                    	  }
                      }
                  }]
              ],

              onLoadSuccess: function () {
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
            	  
            	  $(".registBMZC_assignZcBtn").linkbutton ({
            		  height : 22,
            		  iconCls:"icon-assign",
            	  });
            	  
            	  $(".registBMZC_assignZcBtn").tooltip({
            		  position: 'bottom',    
            		  content: '分配资产',
            	  });
            	  
            	  $(".registBMZC_revertZcBtn").linkbutton ({
            		  height : 22,
            		  iconCls:"icon-guihuan",
            	  });
            	  
            	  $(".registBMZC_revertZcBtn").tooltip({
            		  position: 'bottom',    
            		  content: '申请归还',
            	  });
            	  
            	  $(".registBMZC_reassignZcBtn").linkbutton ({
            		  height : 22,
            		  iconCls:"icon-reassign",
            	  });
            	  
            	  $(".registBMZC_reassignZcBtn").tooltip({
            		  position: 'bottom',    
            		  content: '重新分配',
            	  });
            	  
            	  
              },
	});
	
</script>
</body>
</html>
