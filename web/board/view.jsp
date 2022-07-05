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

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");

    sql = "select * from board where board.board_id = "+boardId;
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();
    rs.next();

    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
    int categoryId = rs.getInt("category_id");
    boolean fileExist = rs.getBoolean("file_exist");
    String title = rs.getString("title");
    String user = rs.getString("user");
    int count = rs.getInt("count");
    String createdDate = dateFormat.format(rs.getTimestamp("created_date"));
    String updatedDate = "-";
    if (rs.getTimestamp("updated_date") != null) {
        updatedDate = dateFormat.format(rs.getTimestamp("updated_date"));
    }
    String content = rs.getString("content");

    sql = "select name FROM category where category_id = " + categoryId;
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();
    rs.next();

    String categoryName = rs.getString("name");
%>
<html>
<head>
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
                <span>조회수: <%=count%></span>
            </div>
        </div>

        <!--본문-->
        <div>
            <p><%=content%></p>
        </div>
    </div>

    <!--댓글-->
    <div>
        <div>댓글1</div>
        <div>댓글2</div>
    </div>

    <div>
        <button type="button" onclick="location.href='/_V_01_war_exploded/board/list.jsp'">목록</button>
        <button type="button" onclick="location.href='/_V_01_war_exploded/board/passwordConfirm.jsp?board_id=<%=boardId%>&type=modify'">수정</button>
        <button type="button" onclick="location.href='/_V_01_war_exploded/board/passwordConfirm.jsp?board_id=<%=boardId%>&type=delete'">삭제</button>
    </div>
</body>
</html>
