<%@ page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML>

<html>
<head>
    <base href="<%=basePath%>">
    <title>资产管理云平台</title>
</head>
<body>
	<jsp:forward page="console/user/loginUI.do"></jsp:forward>
</body>
</html>
