<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
</head>
  
<body>
<div id="dlginsertRegistBMZCUI">
	<form id="insertRegistBMZCUIForm" method="post" enctype="multipart/form-data">
		<table align="center" cellspacing="5px" style="margin-top:1px">
			<tr>
				<td style="text-align:right;">资产代码：</td>
				<td>
		 			<table>
			  			<tr>
						  <td><input id="txbinsertRegistBMZC_dm" name="dm" style="width:110px;"/><span style="color:#FF0000;margin-left: 3px;">*</span></td>
					  	  <td style="text-align:right;">资产名称：</td>
						  <td><input id="txbinsertRegistBMZC_mc" name="mc"  style="width:110px;"/><span style="color:#FF0000;margin-left: 3px;">*</span></td>
				  		</tr>
		 			</table>
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">资产类型：</td>
				<td>
		 			<table>
			  			<tr>
				  			<td><input id="srbinsertRegistBMZC_lxid" name="lxmc" style="width:110px;" /><span style="color:#FF0000;margin-left: 3px;">*</span></td>
				  			<td style="text-align:right;">存放地点：</td>
				  			<td><input id="srbinsertRegistBMZC_cfdd" name="cfddmc" style="width:110px;"/><span style="color:#FF0000;margin-left: 3px;"></span></td>
				  		</tr>
		 			</table>
				</td>
				
			</tr>
		    <tr>
				<td style="text-align:right;">单价：</td>
				<td>
		 			<table>
			  			<tr>
				  			<td><input id="nbbinsertRegistBMZC_cost" name="cost" style="width:90px;" /><span style="margin-left: 3px;">&nbsp;元</span></td>
				  			<td style="text-align:right;">&nbsp;&nbsp;资产数量：</td>
				  			<td><input id="txbinsertRegistBMZC_num" name="num" style="width:110px;"/><span style="color:#FF0000;margin-left: 3px;">*</span></td>
				  		</tr>
		 			</table>
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">规格型号：</td>
				<td>
		 			<table>
			  			<tr>
				  			<td><input id="txbinsertRegistBMZC_xh" name="xh" /></td>
				  			<td style="padding-left:10px">出厂编号：</td>
				  			<td><input id="txbinsertRegistBMZC_ccbh" name="ccbh" /></td>
				  		</tr>
		 			</table>
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">购置时间：</td>
				<td>
					<table>
		 				<tr>
				  			<td><input id="dtbinsertRegistBMZC_gzsj" name="gzsj" /></td>
				  			<td style="padding-left:10px">折旧年限：</td>
				  			<td><input id="txbinsertRegistBMZC_zjnx" name="zjnx"/>&nbsp;&nbsp;年<span style="color:#FF0000;margin-left: 3px;">*</span></td>
			  			</tr>
		 			</table>
				</td>
			</tr>
			<tr>
				<td style="text-align:right;">资产照片：</td>
				<td><input id="fbinsertRegistBMZC_zczp" name="file_upload" style="width:300px;"/><span style="color:#FF0000;margin-left: 3px;">*</span></td>
			</tr>
		</table>
	<table>
        <tr>
            <td height="30px"></td>
            <td width="140px"></td>
            <td width="100px" style="text-align: center"><a data-options="iconCls:'icon-ok'" class="easyui-linkbutton" onclick="inserRegistBMZCUI.registZC()">确认</a></td>
            <td width="100px" style="text-align: center"><a data-options="iconCls:'icon-cancel'" onclick="inserRegistBMZCUI.cancel()" class="easyui-linkbutton">取消</a></td>
         </tr>
    </table>
	</form>
</div>
<script>

	function FormatDate(date){
		
		return date.getFullYear()+"-"+(date.getMonth()+1)+"-"+date.getDate();
		
	}
	
	var inserRegistBMZCUI = {
			
		registZC: function () {
			$.messager.progress();
			$("#insertRegistBMZCUIForm").form("submit",{
				url:getContextPath() + "/console/zcgl/regist/insertRegistBMZC.do",
				onSubmit: function (param) {
					
					var valid = $("#insertRegistBMZCUIForm").form("validate");
					if (!valid) {
						$.messager.progress('close');				
						return valid;
					}
					param.lxid=$("#srbinsertRegistBMZC_lxid").attr("lxid"); 
					param.cfdd=$("#srbinsertRegistBMZC_cfdd").attr("cfdd"); 
				},
				success: function (result) {
					$.messager.progress("close");
					if (result =="success") {
						$("#registBMZCList_newRegistdlg").dialog("close");
						$("#dgregistBMZCList").datagrid("reload");	
					} else if (result =="ZCDM_ERROR") {
						$.messager.alert("提示","该资产代码已经存在，请换一个！","info");
					} else if (result =="ZCMC_ERROR") {
						$.messager.alert("提示","资产名称不能为空或者是空格！","info");
					} else if (result =="ZJNX_ERROR") {
						$.messager.alert("提示","折旧年限必须是数字且不能小于0！","info");
					} else if (result =="NUM_ERROR") {
						$.messager.alert("提示","资产数量必须是正整数！","info");
					} else if (result=="PIC_ERROR") {
						$.messager.alert("提示","资产照片必须小于1MB！","info");
					} else if (result=="COST_ERROR") {
						$.messager.alert("提示","资产单价必须是正数！","info");
					} else {
						$.messager.alert("提示",resultStr,"info");
					}
					
				}
			});
		},
		
		cancel: function () {
			$("#registBMZCList_newRegistdlg").dialog("close");
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
						$("#srbinsertRegistBMZC_lxid").searchbox("setValue",czclx.mc);
						$("#srbinsertRegistBMZC_lxid").attr("lxid",czclx.id); 
					}
					dialogObj.remove();
				}
			});
		},
		query_cfdd: function () {
			dialogObj = $("<div id='queryCFDDUI'></div>");
			vfj = null;
			dialogObj.appendTo("body");
			$("#queryCFDDUI").dialog({
				href: getContextPath() + "/console/catalog/fjgl/queryCFDDUI.do",
				title: "存放地点查询",
				width: 512,
				height: 300,
				modal: true,
				onClose: function () {
					if(vfj != null) {
						$("#srbinsertRegistBMZC_cfdd").searchbox("setValue",vfj.room+vfj.floor);
						$("#srbinsertRegistBMZC_cfdd").attr("cfdd",vfj.fjId); 
					}
					dialogObj.remove();
				}
			});
		}
	};
	
	$("#txbinsertRegistBMZC_dm").textbox({
	    prompt: "必填项",
		required: true,
		onChange: function (newValue, oldValue) {
			$.ajax({
				url: getContextPath() + "/console/zcgl/regist/checkRegistZCByDM.do",
				cache: false,
				data: {"zcdm":newValue},
				dataType: "json",
				success: function (result) {
					if (result) {
						$.messager.alert("提示","该资产代码已经存在，请换一个！","info");
					}
				},
				error: function () {
					alert("Ajax error!");
				}
			});
		}
	});
	
	$("#txbinsertRegistBMZC_mc").textbox({
	    prompt: "必填项",
		required: true,
		onChange: function (newValue, oldValue) {
			$.ajax({
				url: getContextPath() + "/console/zcgl/regist/checkRegistZCByMC.do",
				cache: false,
				data: {"zcmc":newValue},
				dataType: "json",
				success: function (result) {
					if (result) {
						$.messager.alert("提示","资产名称不能为空或者是空格！","info");
					}
				},
				error: function () {
					alert("Ajax error!");
				}
			});
		}
	});
	
	$("#srbinsertRegistBMZC_lxid").searchbox({
		required:true,
		editable: false,
		searcher: function(value,name){
			inserRegistBMZCUI.query_zclx();
		}
	});
	
	$("#txbinsertRegistBMZC_xh").textbox({
		width:110,
	});
	
	$("#txbinsertRegistBMZC_ccbh").textbox({
		width:110,
	});
	
	$("#dtbinsertRegistBMZC_gzsj").datebox({
		width:110,
		required: true,
		value: FormatDate(new Date()),
	});
	
	$("#txbinsertRegistBMZC_num").numberbox({
		prompt: "只能输入数字",
		required: true,
		value: "1",
		onChange: function (newValue, oldValue) {
			$.ajax({
				url: getContextPath() + "/console/zcgl/regist/checkNum.do",
				cache: false,
				data: {"num":newValue},
				dataType: "json",
				success: function (result) {
					if (result) {
						$.messager.alert("提示","资产数量必须是正整数!","info");
					}
				},
				error: function () {
					alert("Ajax error!");
				}
			});
		}
	});	
	
	$("#txbinsertRegistBMZC_zjnx").numberbox({
		prompt: "只能输入数字",
		width:110,
		precision: 1,
		required: true,
		value: "3.0",
		onChange: function (newValue, oldValue) {
			$.ajax({
				url: getContextPath() + "/console/zcgl/regist/checkRegistZCByZJNX.do",
				cache: false,
				data: {"zjnx":newValue},
				dataType: "json",
				success: function (result) {
					if (result) {
						$.messager.alert("提示","折旧年限必须是数字且不能小于0！","info");
					}
				},
				error: function () {
					alert("Ajax error!");
				}
			});
		}
	});
	
	$("#nbbinsertRegistBMZC_cost").numberbox({
		required: true,
		width: 90,
		precision: 2,
		value: 0,
		onChange: function (newValue, oldValue) {
			$.ajax({
				url: getContextPath() + "/console/zcgl/regist/checkCost.do",
				cache: false,
				data: {"cost":newValue},
				dataType: "json",
				success: function (result) {
					if (result) {
						$.messager.alert("提示","单价必须是正数!","info");
					}
				},
				error: function () {
					alert("Ajax error!");
				}
			});
		}
	});
	
	$("#fbinsertRegistBMZC_zczp").filebox({
	    prompt: "必选项",
	    buttonText: "选择照片", 
	    buttonAlign: "right",
    	accept: "image/jpeg",
    	required: true
	});
	
	$("#srbinsertRegistBMZC_cfdd").searchbox({
		editable: false,
		searcher: function(value,name){
			inserRegistBMZCUI.query_cfdd();
		}
	});
</script>
</body>
</html>
