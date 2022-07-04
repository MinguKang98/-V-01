<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-04
  Time: 오전 12:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");

    Connection con = null;
    PreparedStatement pstmt = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    String categoryID = request.getParameter("category");
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
    String file1 = request.getParameter("file1");
    String file2 = request.getParameter("file2");
    String file3 = request.getParameter("file3");
    String fileArray[] = {file1, file2, file3};

    // 유효성 검사

    // board DB 저장
    sql = "INSERT INTO board(created_date,user,password,title,content,category_id,file_exist)" +
            "VALUES (?,?,?,?,?,?,?);";
    pstmt = con.prepareStatement(sql);

    Timestamp createDate = new Timestamp(System.currentTimeMillis());
    pstmt.setTimestamp(1, createDate);
    pstmt.setString(2, user);
    pstmt.setString(3, password); //비밀번호 암호화 해야함
    pstmt.setString(4, title);
    pstmt.setString(5, content);
    pstmt.setInt(6, Integer.parseInt(categoryID));
    // file_exist
    int fileExist = 0;
    for (String file : fileArray) {
        if (file != "") {
            fileExist = 1;
            break;
        }
    }
    pstmt.setInt(7, fileExist);

    pstmt.executeUpdate();

    // file DB 저장


    con.close();
    pstmt.close();

    // redirect
    response.sendRedirect("/_V_01_war_exploded/board/list.jsp");

%>

