<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오전 1:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="encryption.SHA256" %>
<%@ page import="com.oreilly.servlet.MultipartRequest" %>
<%@ page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy" %>
<%@ page import="java.util.Enumeration" %>
<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");

    // 이전 검색 조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    // MultipartRequest 객체
//    String downloadLocation = "C:\\Users\\alsrn\\Desktop\\Coding\\게시판\\게시판 V-01\\web\\resources\\files";
//    int maxSize = 1024 * 1024 * 5;
//    MultipartRequest multi = new MultipartRequest(request, downloadLocation, maxSize, "utf-8", new DefaultFileRenamePolicy());

    Connection con = null;

    try {
        Class.forName("org.mariadb.jdbc.Driver");
    } catch (ClassNotFoundException e) {
        e.printStackTrace();
    }
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    // modify.jsp 에서 받아온 parameter
    String user = request.getParameter("user");
    String password = request.getParameter("password");
    String title = request.getParameter("title");
    String content = request.getParameter("content");
//    String file1 = multi.getParameter("file1");
//    String file2 = multi.getParameter("file2");
//    String file3 = multi.getParameter("file3");

    // 기존 data
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    boolean fileExist;
    String originUser = null;
    String originPassword = null;
    String originTitle = null;
    String originContent = null;
    String salt = null;

    try {
        sql = "select * from board where board.board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rs.next();

        fileExist = rs.getBoolean("file_exist");
        originUser = rs.getString("user");
        originPassword = rs.getString("password");
        originTitle = rs.getString("title");
        originContent = rs.getString("content");
        salt = rs.getString("salt");
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

    //유효성 검사
    // 비밀번호 일치
    String encryptPassword = SHA256.encryptSHA256(password, salt); // 암호화한 입력 비밀번호
    if (!encryptPassword.equals(originPassword)) {
        response.sendRedirect("modify.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        return;
    }

    // 작성자
    if (user.length() < 3 || user.length() >= 5) {
        response.sendRedirect("modify.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        return;
    }
    // 제목
    if (title.length() < 4 || title.length() >= 100) {
        response.sendRedirect("modify.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        return;
    }
    // 내용
    if (content.length() < 4 || content.length() >= 2000) {
        response.sendRedirect("modify.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
                + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
        return;
    }

    // ==== 미완성 ====

//    //file update
//    sql = "select * from file where file.board_id = " + boardId;
//    pstmt = con.prepareStatement(sql);
//    rs = pstmt.executeQuery();
//    rs.next();
//
//    Enumeration files = multi.getFileNames();
//    while (files.hasMoreElements()) {
//        String element = (String) files.nextElement();
//
//        String originalFileName = multi.getOriginalFileName(element);
//        String filesystemName = multi.getFilesystemName(element);
//
//        // null이 아니면 db 저장
//        if (originalFileName != null) {
//            sql = "INSERT INTO file(original_file_name,system_file_name,board_id)" +
//                    "VALUES (?,?,?);";
//            pstmt = con.prepareStatement(sql);
//
//            pstmt.setString(1,originalFileName);
//            pstmt.setString(2, filesystemName);
//            pstmt.setInt(3, Integer.parseInt(boardId));
//
//            pstmt.executeUpdate();
//        }
//    }

    // ==== 미완성 ====



    //정보 비교해서 다른 것만 update
    boolean userChanged = (!user.equals(originUser));
    boolean titleChanged = (!title.equals(originTitle));
    boolean contentChanged = (!content.equals(originContent));

    String userUpdateQuery = (userChanged) ? ("user = \"" + user + "\", ") : "";
    String titleUpdateQuery = (titleChanged) ? ("title = \"" + title + "\", ") : "";
    String contentUpdateQuery = (contentChanged) ? ("content = \"" + content + "\", ") : "";

    //board update
    try {
        sql = "update board set " + userUpdateQuery + titleUpdateQuery + contentUpdateQuery + "updated_date = now() " +
                "where board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        pstmt.executeUpdate();
    } catch (SQLException e){
        e.printStackTrace();
    } finally {
        try {
            if (pstmt != null) {
                pstmt.close();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }

    // redirect
    response.sendRedirect("view.jsp?board_id=" + boardId + "&searchCreatedDateFrom=" + searchCreatedDateFrom + "&searchCreatedDateTo=" + searchCreatedDateTo
            + "&searchCategory=" + searchCategoryId + "&searchText=" + searchText);
%>

