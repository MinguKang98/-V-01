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

    // 이전 검색 조건
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

    // 게시글
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

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
        if (rs.next()) {
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
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

    // 카테고리
    String categoryName = null;
    try {
        sql = "select name FROM category where category_id = " + categoryId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        if (rs.next()) {
            categoryName = rs.getString("name");
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
%>
<html>
<head>
    <script src="https://kit.fontawesome.com/052e9eaead.js" crossorigin="anonymous"></script>
    <title>게시판 수정</title>
</head>
<body>
<form method="post" name="modifyForm" id="modifyForm"
      action="/_V_01_war_exploded/board/modifyProcess.jsp?board_id=<%=boardId%>&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>">
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
<%
    // 첨부파일
    try {
        sql = "select * FROM file where board_id = " + boardId;
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();

        for (int i = 1; i <= 3; i++) {
            if(rs.next()){
                String originalFileName = rs.getString("original_file_name");
                String systemFileName = rs.getString("system_file_name");
                int fileId = rs.getInt("file_id");
%>
                <div>
                    <i class="fas fa-paperclip"></i><span> <%=originalFileName%> </span>
                    <button type="button" onclick="location.href='/_V_01_war_exploded/board/fileDownloadProcess.jsp?file_id=<%=fileId%>&type=modify&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">
                        Download</button>
                    <button type="button" id="deleteButton<%=i%>" onclick="deleteFile(this.id)">X</button>
                </div>
<%
         }else{
%>
                <div>
                    <input type="file" />
                </div>
<%
            }
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
%>
            </td>
        </tr>
    </table>
    <button type="button" onclick="location.href='/_V_01_war_exploded/board/view.jsp?board_id=<%=boardId%>&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">취소</button>
    <button type="button" onclick="validCheck()">저장</button>
</form>
<%
    try {
        if (con != null) {
            con.close();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
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

        //비밀번호 검증
        var passwordWarning = document.getElementById("passwordWarning");
        var regExp = /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{4,15}$/;

        if (regExp.test(password.value) != true) {
            passwordWarning.innerText = "4글자 이상, 16글자 미만인 영문/숫자/특수문자의 조합";
            passwordWarning.style.color = "red";
            password.focus();
            return false;
        }
        else{
            passwordWarning.innerText = "";
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

    function deleteFile(id){
        document.getElementById(id).parentNode.innerHTML = "<input type=\"file\" />";
    }
</script>
</body>
</html>
