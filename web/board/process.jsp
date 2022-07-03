<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-04
  Time: 오전 12:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("UTF-8");
    String categoryID = request.getParameter("category");
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String file1 = request.getParameter("file1");
    String file2 = request.getParameter("file2");
    String file3 = request.getParameter("file3");

    // 유효성 검사

    // DB 저장

    // redirect

%>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <h3><%=categoryID%></h3>
    <h3><%=user%></h3>
    <h3><%=password%></h3>
    <h3><%=title%></h3>
    <h3><%=content%></h3>
    <h3><%=file1%></h3>
    <h3><%=file2%></h3>
    <h3><%=file3%></h3>
</body>
</html>
