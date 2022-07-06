<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-06
  Time: 오후 6:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");

    // 이전 검색조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    Connection con = null;
    PreparedStatement pstmt = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    String comment = request.getParameter("comment");

    // comment DB 저장
    sql = "insert into comment(created_date,content,board_id) values (now(),?,?)";
    pstmt = con.prepareStatement(sql);

    pstmt.setString(1, comment);
    pstmt.setInt(2, Integer.parseInt(boardId));

    pstmt.executeUpdate();

    // 게시글 댓글 수 업데이트
    sql = "update board set comment_count = comment_count + 1 where board_id = " + boardId;
    pstmt = con.prepareStatement(sql);
    pstmt.executeUpdate();

    con.close();
    pstmt.close();

    // redirect
    response.sendRedirect("view.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
            + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
%>
