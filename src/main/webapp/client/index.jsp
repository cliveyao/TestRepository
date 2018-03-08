<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1,user-scalable=0">
<meta name="apple-mobile-web-app-capable" content="yes">
<title>资产管理微助手</title>
</head>
<body>
	<%	
		String appFlag = request.getParameter("appFlag");
		String appId = request.getParameter("appId");
		String params = "/index.jsp?appId=" + appId + "&appFlag=" + appFlag;
		if ("message".equals(appFlag)) {
			response.sendRedirect("msgCenter" + params);
		} else if ("admin".equals(appFlag)) {
			response.sendRedirect("zcglAdmin" + params);
		} else if ("bmadmin".equals(appFlag)) {
			response.sendRedirect("zcglBMAdmin" + params);
		} else if ("gzwx".equals(appFlag)) {
			response.sendRedirect("zcglGZWX" + params);
		} else if ("my".equals(appFlag)) {
			response.sendRedirect("zcglMy" + params);
		} else if ("rcxj".equals(appFlag)) {
			response.sendRedirect("zcglRCXJ" + params);
		}
	%>
</body>
</html>