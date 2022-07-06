<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오후 11:38
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");

    // 이전 검색 조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    Connection con = null;
    PreparedStatement pstmt = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    // board delete
    sql = "delete from board where board_id=" + boardId;
    pstmt = con.prepareStatement(sql);

    pstmt.executeUpdate();

    // redirect
    response.sendRedirect("list.jsp?searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
            + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);

%>