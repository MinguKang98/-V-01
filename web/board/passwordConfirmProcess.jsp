<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오후 10:47
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");
    String type = request.getParameter("type");
    String inputPassword = request.getParameter("password");

    // 이전 검색 조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    Connection con = null;
    PreparedStatement pstmt = null;
    String sql = null;
    ResultSet rs = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");


    sql = "select password from board where board.board_id = "+boardId;
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();
    rs.next();

    String originPassword = rs.getString("password");

    if (inputPassword.equals(originPassword)) {
        // 같으면 type 에 따라 다음 프로세스로
        if (type.equals("modify")) {
            response.sendRedirect("modify.jsp?board_id=" + boardId
                    + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                    + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        }

        if (type.equals("delete")) {
            response.sendRedirect("deleteProcess.jsp?board_id=" + boardId
                    + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                    + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        }
    }
    else{
        // 다르면 passwordConfirm 으로
        response.sendRedirect("passwordConfirm.jsp?board_id=" + boardId + "&type=" + type
                + "&confirm=fail&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);

    }
%>
