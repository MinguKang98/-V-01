<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-03
  Time: 오후 6:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");

    // 검색조건
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

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

    // 조회수 업데이트
    try{
        sql = "update board set visit_count = visit_count + 1 where board_id = " + boardId;
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


    // 게시글 불러오기
    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");

    int categoryId = 0;
    boolean fileExist;
    String title = null;
    String user = null;
    int visitCount = 0;
    String createdDate = null;
    String updatedDate = "-";
    String content = null;
    try {
        sql = "select * from board where board.board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rs.next();

        categoryId = rs.getInt("category_id");
        fileExist = rs.getBoolean("file_exist");
        title = rs.getString("title");
        user = rs.getString("user");
        visitCount = rs.getInt("visit_count");
        createdDate = dateFormat.format(rs.getTimestamp("created_date"));
        if (rs.getTimestamp("updated_date") != null) {
            updatedDate = dateFormat.format(rs.getTimestamp("updated_date"));
        }
        content = rs.getString("content");
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

    // 댓글 불러오기
    String categoryName = null;
    try{
        sql = "select name FROM category where category_id = " + categoryId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if(rs.next()){

            categoryName = rs.getString("name");
%>
<html>
<head>
    <script src="https://kit.fontawesome.com/052e9eaead.js" crossorigin="anonymous"></script>
    <title>게시글</title>
</head>
<body>
    <!--게시글-->
    <div>
        <!--제목-->
        <div>
            <div>
                <span><%=user%></span>
                    <span>등록일시 <%=createdDate%></span>
                    <span>수정일시 <%=updatedDate%></span>
                </div>
            </div>
            <div>
                <h2>[<%=categoryName%>]    <%=title%></h2>
                <span>조회수: <%=visitCount%></span>
            </div>
        </div>

        <!--본문-->
        <div>
            <p><%=content%></p>
        </div>

        <%--첨부파일--%>
<%
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

    // 첨부파일 불러오기
    try{
        sql = "select * from file where board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()){
            int fileId = rs.getInt("file_id");
            String originalFileName = rs.getString("original_file_name");
%>
        <div><i class="fas fa-download"></i>
            <a href="/_V_01_war_exploded/board/fileDownloadProcess.jsp?file_id=<%=fileId%>&type=view&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>"><%=originalFileName%></a>
        </div>
<%
        }
    }  catch (SQLException e){
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
%>
    </div>

    <!--댓글-->
    <div>
<%
    // 댓글 불러오기
    try {
        sql = "select * from comment where board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();

        while (rs.next()){
            String commentCreatedDate = dateFormat.format(rs.getTimestamp("created_date"));
            String comment = rs.getString("content");
%>
        <div>
            <div><%=commentCreatedDate%></div>
            <div><%=comment%></div>
        </div>
<%
        }
    }  catch (SQLException e){
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
%>
        <form method="post" name="commentForm" id="commentForm" action="/_V_01_war_exploded/board/commentProcess.jsp?board_id=<%=boardId%>&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>">
            <input type="text" name="comment" id="comment" required placeholder="댓글을 입력해 주세요."/>
            <button type="submit">등록</button>
        </form>
    </div>

    <div>
        <button type="button" onclick="location.href='list.jsp?searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">목록</button>
        <button type="button" onclick="location.href='passwordConfirm.jsp?board_id=<%=boardId%>&type=modify&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">수정</button>
        <button type="button" onclick="location.href='passwordConfirm.jsp?board_id=<%=boardId%>&type=delete&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">삭제</button>
    </div>
<%
    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
</body>
</html>
