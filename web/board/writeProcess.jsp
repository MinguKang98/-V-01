<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-04
  Time: 오전 12:50
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="encryption.SHA256" %>
<%@ page import="encryption.Salt" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.Enumeration" %>

<%
    request.setCharacterEncoding("UTF-8");

    // 이전 검색조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    // MultipartRequest 객체
    String downloadLocation = "C:\\Users\\alsrn\\Desktop\\Coding\\게시판\\게시판 V-01\\web\\resources\\files";
    int maxSize = 1024 * 1024 * 5;
    MultipartRequest multi = new MultipartRequest(request, downloadLocation, maxSize, "utf-8", new DefaultFileRenamePolicy());

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    String categoryID = multi.getParameter("category");
    String user = multi.getParameter("user");
    String password = multi.getParameter("password");
    String title = multi.getParameter("title");
    String content = multi.getParameter("content");
    String file1 = multi.getParameter("file1");
    String file2 = multi.getParameter("file2");
    String file3 = multi.getParameter("file3");
    String fileArray[] = {file1, file2, file3};

    // 유효성 검사
    // 카테고리
    if (categoryID.equals("0")) {
        response.sendRedirect("write.jsp");
        return;
    }
    // 작성자
    if (user.length() < 3 || user.length() >= 5) {
        response.sendRedirect("write.jsp");
        return;
    }
    // 비밀번호
    if (password.length() < 4 || password.length() >= 16) {
        response.sendRedirect("write.jsp");
        return;
    } else {
        if (!Pattern.matches("^(?=.*[A-Za-z])(?=.*\\d)(?=.*[$@$!%*#?&])[A-Za-z\\d$@$!%*#?&]{4,15}$", password)) {
            response.sendRedirect("write.jsp");
            return;
        }
    }

    // 제목
    if (title.length() < 4 || title.length() >= 100) {
        response.sendRedirect("write.jsp");
        return;
    }
    // 내용
    if (content.length() < 4 || content.length() >= 2000) {
        response.sendRedirect("write.jsp");
        return;
    }

    // 비밀번호 암호화
    String salt = Salt.getSalt();
    String encryptPassword = SHA256.encryptSHA256(password, salt);

    // board DB 저장
    sql = "INSERT INTO board(created_date,user,password,title,content,category_id,file_exist,salt)" +
            "VALUES (?,?,?,?,?,?,?,?);";
    pstmt = con.prepareStatement(sql);

    Timestamp createDate = new Timestamp(System.currentTimeMillis());
    pstmt.setTimestamp(1, createDate);
    pstmt.setString(2, user);
    pstmt.setString(3, encryptPassword);
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
    pstmt.setString(8, salt);

    pstmt.executeUpdate();


    // file 업로드

    sql = "select LAST_INSERT_ID()";
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();
    int boardId = 0;
    if (rs.next()) {
        boardId = rs.getInt("LAST_INSERT_ID()");
    }

    Enumeration files = multi.getFileNames();

    while (files.hasMoreElements()) {
        String element = (String) files.nextElement();

        String originalFileName = multi.getOriginalFileName(element);
        String filesystemName = multi.getFilesystemName(element);

        // null이 아니면 db 저장
        if (originalFileName != null) {
            sql = "INSERT INTO file(original_file_name,system_file_name,board_id)" +
                    "VALUES (?,?,?);";
            pstmt = con.prepareStatement(sql);

            pstmt.setString(1,originalFileName);
            pstmt.setString(2, filesystemName);
            pstmt.setInt(3, boardId);

            pstmt.executeUpdate();
        }
    }

    rs.close();
    pstmt.close();
    con.close();

    //redirect
    response.sendRedirect("list.jsp?searchCreatedDateFrom="+searchCreatedDateFrom+"&searchCreatedDateTo="+searchCreatedDateTo
            +"&searchCategory="+searchCategoryId+"&searchText="+searchText);
%>
