<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//w3c//DTD HTML 4.01 Transtional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
  <head>
    <title>新增低值易耗品申领单</title>
    <style type="text/css">
        body{
           margin-left:0px;             
           margin-top:0px;
           margin-right:0px;
           margin-bottom:0px;
        }
    </style>           
  </head>
  
  <body>   
     <div id="insertInfoDiv">
        <div id="divGRYHPSQToolbar" style="padding:3px">          
           <table>
              <tr>                 	 	
                 <td style="padding-left:400px;padding-right:10px">持有部门:</td>
                 <td><input id="selectZcbm" name="deptName"/></td>            
              </tr>
           </table>
        </div>
        <table id="YHPSQXZList"></table>
        <table align="center">
        	<tr>
       			<td width="30%"/></td>
				<td width='10%' align="center"><a href="#" id="GRYHP_Submit">确定</a></td>
				<td width='20%'></td>
				<td width='10%' align="center"><a href="#" id="GRYHP_Cancel">取消</a></td>
				<td></td>
        	</tr>
        </table>
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
				$("#YHPSQXZList").datagrid('options').queryParams={deptNo: deptNo};
				$("#YHPSQXZList").datagrid('reload');
			}
	};
	 $("#selectZcbm").searchbox({
		required:true,  
		width:200,
		editable : false,
		onClickIcon:function(){
			var change = $("#YHPSQXZList").datagrid("getData");
			for(var i = 0; i < change.total;i++){
				var num = $("#insertGRNum" + i).numberspinner("getValue");
				if(num != 0){
					$.messager.confirm('确认','本申领单不能跨部门申领。如果点击确认，您已申请的易耗品将清空。',function(sure){ 
						if(sure){
							testOpt.queryDeptName("queryDeptName", "/console/wxgl/wxdept/queryQYWXDeptUI.do", "查找持有部门", {isEdit: false,isQY: true},"selectZcbm"); 
						}
					});
					break;
				}
			}
			if(i==change.total){
				testOpt.queryDeptName("queryDeptName", "/console/wxgl/wxdept/queryQYWXDeptUI.do", "查找持有部门", {isEdit: false,isQY: true},"selectZcbm"); 
			}
		},
	 });
	 
    $("#GRYHP_Submit").linkbutton({
		plain: true,
		iconCls:'icon-ok',
	});
	$("#GRYHP_Submit").click(function(){
		$.messager.progress();
		var insertGRParam=new Array();
		var data = $("#YHPSQXZList").datagrid("getData");
		for(var i = 0; i < data.total;i++){
			var num = $("#insertGRNum"+i).numberspinner("getValue");
			if(num > data.rows[i].num){
				$.messager.alert('提示',"第" + (i+1 ) + "行申请数量大于持有数量，请申请少于持有数量的易耗品。",'waring');
				$.messager.progress('close');
				return false;
			}
			if(num != 0){
				insertGRParam.push("{\"yhpId\":"+data.rows[i].yhpId+",\"yhpNum\":"+num+"}");
			}
		}
		if(data.total == 0 || $.trim(insertGRParam) == ''){
			$.messager.progress('close');
			$.messager.alert('提示',"请至少选择一个易耗品",'waring');
			return false;
		}
		$.ajax({
            type:"post",
            url:getContextPath() + "/console/yhpgl/yhpsl/insertGRYHPSQ.do",
            dataType:"text",
            cache: false,
            async: true,
            data:{"sqNumMap":insertGRParam.toLocaleString(),"deptNo":deptNo},
            success: function(data){
            	$.messager.progress('close');
            	if(data == "success"){
            	    $("#insertInfoDiv").dialog("close");
            	    $("#YHPSQXZList").datagrid('reload');
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
	
	$("#GRYHP_Cancel").linkbutton({
		plain: true,
		iconCls:'icon-cancel',
	});
	
	$("#GRYHP_Cancel").click(function(){
		$("#insertInfoDiv").dialog('close');
	});
  
   $("#YHPSQXZList").datagrid({
	   height : 530,
	   url: getContextPath() + "/console/yhpgl/yhpsl/getYHPList.do",	
	   queryParams: {deptNo: -1},
	   method: "post",
       fitColumns: true,
       striped: true, //斑马线效果
       loadMsg: "数据正在加载当中，请稍等...", //加载数据时的提示消息
       rownumbers: true, //显示行列号
       singleSelect: true, //只允许选中一行
       nowrap: true, //是否在一行显示所有，自动换行
       emptyMsg : "没有找到符合条件的记录",
	   toolbar: "#divGRYHPSQToolbar",
	   onLoadSuccess : function() {
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
		columns: [[
		     {
		    	  field: "lx",
		    	  title: "易耗品类型",
		    	  width: "41%",
		    	  halign:"center",
		    	  align: "left",
		    	  resizable: false,
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
		    	  field: "xh",
		    	  title: "规格型号",
		    	  width: "16%",
		    	  align: "center",
		    	  resizable: false,
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
		      	  field: "ccbh",
		    	  title: "出厂编号",
		    	  width: "15%",
		    	  align: "center",
		    	  resizable: false,
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
		      	  field: "num",
		    	  title: "持有数量",
		    	  width: "15%",
		    	  align: "center",
		    	  resizable: false,
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
		      	  field: "sqNum",
		    	  title: "申请数量",
		    	  width: "15%",
		    	  align: "center",
		    	  resizable: false,	
		    	  formatter: function(value, row, index) {
	            	   return '<div><input id="insertGRNum'+ index +'" class="sqslSpinner"></div>';
	               },
		      }
		 ]], 
	});
          
   </script>
  </body>
 </html>