<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-08
  Time: 오전 1:35
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.io.File" %>
<%@ page import="java.io.FileInputStream" %>
<%@ page import="java.io.OutputStream" %>
<%
    request.setCharacterEncoding("UTF-8");
    String fileId = request.getParameter("file_id");

    // 검색조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    String type = request.getParameter("type");

    Connection con = null;
    try {
        Class.forName("org.mariadb.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    String originalFileName = null;
    String systemFileName = null;
    int boardId = 0;
    try {
        sql = "select * from file where file_id = " + fileId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            originalFileName = rs.getString("original_file_name");
            systemFileName = rs.getString("system_file_name");
            boardId = rs.getInt("board_id");
        }
    } catch (SQLException e){
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) {
                rs.close();
            }
            if (pstmt != null) {
                pstmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    String downLoadFile = "C:\\Users\\alsrn\\Desktop\\Coding\\게시판\\게시판 V-01\\web\\resources\\files\\" + systemFileName;

    File file = new File(downLoadFile);
    FileInputStream in = new FileInputStream(downLoadFile);

    systemFileName = new String(systemFileName.getBytes("utf-8"), "8859_1");

    response.setContentType("application/octet-stream");
    response.setHeader("Content-Disposition", "attachment; filename=" + systemFileName);

    OutputStream os = response.getOutputStream();

    int length;
    byte[] b = new byte[(int)file.length()];

    while ((length = in.read(b)) > 0) {
        os.write(b, 0, length);
    }

    os.flush();
    os.close();
    in.close();

    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    //redirect
    if (type.equals("view")) {
        response.sendRedirect("view.jsp?board_id=" + boardId + "searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
    }

    if (type.equals("modify")) {
        response.sendRedirect("modify.jsp?board_id=" + boardId + "searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
    }

%>
