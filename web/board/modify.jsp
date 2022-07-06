<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오전 1:15
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
    int visitCount = rs.getInt("visit_count");
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
    <title>게시판 수정</title>
</head>
<body>
<form method="post" name="modifyForm" id="modifyForm" action="/_V_01_war_exploded/board/modifyProcess.jsp?board_id=<%=boardId%>">
    <table>
        <tr>
            <th>카테고리</th>
            <td>
                <span name="category" id="category"><%=categoryName%></span>
            </td>
        </tr>
        <tr>
            <th>등록 일시</th>
            <td>
                <span name="createdDate" id="createdDate"><%=createdDate%></span>
            </td>
        </tr>
        <tr>
            <th>수정 일시</th>
            <td>
                <span name="updatedDate" id="updatedDate"><%=updatedDate%></span>
            </td>
        </tr>
        <tr>
            <th>조회수</th>
            <td>
                <span name="count" id="count"><%=visitCount%></span>
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td>
                <input type="text" name="user" id="user" value="<%=user%>" required minlength="3" maxlength="5"/>
                <span id="userWarning"></span>
        </tr>
        <tr>
            <th>비밀번호</th>
            <td>
                <input type="password" name="password" id="password" placeholder="비밀번호" required
                       pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{4,15}$"/>
                <span id="passwordWarning"></span>
            </td>
        </tr>
        <tr>
            <th>제목</th>
            <td>
                <input type="text" name="title" id="title" value="<%=title%>" required minlength="4" maxlength="100"/>
                <span id="titleWarning"></span>
            </td>
        </tr>
        <tr>
            <th>내용</th>
            <td>
                <textarea name="content" id="content" required minlength="4" maxlength="2000"><%=content%></textarea>
                <span id="contentWarning"></span>
            </td>
        </tr>
        <tr>
            <th>파일첨부</th>
            <td>
                <input type="file" name="file1" id="file1"/>
                <input type="file" name="file2" id="file2"/>
                <input type="file" name="file3" id="file3"/>
            </td>
        </tr>
    </table>
    <button type="button" onclick="location.href='/_V_01_war_exploded/board/view.jsp?board_id=<%=boardId%>'">취소</button>
    <button type="button" onclick="validCheck()">저장</button>
</form>

<script>
    function validCheck() {
        var user = document.getElementById("user");
        var title = document.getElementById("title");
        var content = document.getElementById("content");

        // 작성자 검증
        var userWarning = document.getElementById("userWarning");
        if (user.value.length >= user.minLength && user.value.length < user.maxLength) {
            userWarning.innerText = "";
        }
        else{
            userWarning.innerText = "3글자 이상, 5글자 미만";
            userWarning.style.color = "red";
            user.focus();
            return false;
        }

        // 제목 검증
        var titleWarning = document.getElementById("titleWarning");
        if (title.value.length >= title.minLength && title.value.length < title.maxLength) {
            titleWarning.innerText = "";
        }
        else{
            titleWarning.innerText = "4글자 이상, 100글자 미만";
            titleWarning.style.color = "red";
            title.focus();
            return false;
        }

        // 내용 검증
        var contentWarning = document.getElementById("contentWarning");
        if (content.value.length >= content.minLength && content.value.length < content.maxLength) {
            contentWarning.innerText = "";
        }
        else{
            contentWarning.innerText = "4글자 이상, 2000글자 미만";
            contentWarning.style.color = "red";
            content.focus();
            return false;
        }

        document.modifyForm.submit();
    }
</script>
</body>
</html>
