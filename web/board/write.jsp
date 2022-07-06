<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-03
  Time: 오후 10:58
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>

<%
    request.setCharacterEncoding("UTF-8");
    String searchCreatedDateFrom = request.getParameter("searchCreatedDateFrom");
    String searchCreatedDateTo = request.getParameter("searchCreatedDateTo");
    String searchCategoryId = request.getParameter("searchCategory");
    String searchText = request.getParameter("searchText");

    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String sql = null;

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://localhost:3306/board_v1", "mingu", "1234");
%>
<html>
<head>
    <title>게시판 등록</title>
</head>
<body>
<form method="post" name="writeForm" id="writeForm" action="writeProcess.jsp">
    <table>
        <tr>
            <th>카테고리</th>
            <td>
                <select name="category" id="category">
                    <option value="0" selected>카테고리 선택</option>
                    <%
                        sql = "select * from category";
                        pstmt = con.prepareStatement(sql);
                        rs = pstmt.executeQuery();

                        while (rs.next()) {
                            int id = rs.getInt("category_id");
                            String name = rs.getString("name");
                    %>
                    <option value="<%=id%>"><%=name%>
                    </option>
                    <%
                        }
                    %>
                </select>
                <span id="categoryWarning"></span>
            </td>
        </tr>
        <tr>
            <th>작성자</th>
            <td>
                <input type="text" name="user" id="user" required minlength="3" maxlength="5"/>
                <span id="userWarning"></span>
            </td>
        </tr>
        <tr>
            <th>비밀번호</th>
            <td>
                <input type="password" name="password" id="password" placeholder="비밀번호" required
                       pattern="^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{4,15}$"/>
                <input type="password" name="passwordCheck" id="passwordCheck" placeholder="비밀번호 확인" required/>
                <span id="passwordWarning"></span>
            </td>
        </tr>
        <tr>
            <th>제목</th>
            <td>
                <input type="text" name="title" id="title" required minlength="4" maxlength="100"/>
                <span id="titleWarning"></span>
            </td>
        </tr>
        <tr>
            <th>내용</th>
            <td>
                <textarea name="content" id="content" required minlength="4" maxlength="2000"></textarea>
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
    <button type="button" onclick="location.href='list.jsp?searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">취소</button>
    <button type="button" onclick="validCheck()">저장</button>
</form>

<script>
    <!-- 유효성 검사 -->
    function validCheck() {
        var category = document.getElementById("category");
        var user = document.getElementById("user");
        var password = document.getElementById("password");
        var passwordCheck = document.getElementById("passwordCheck");
        var title = document.getElementById("title");
        var content = document.getElementById("content");

        // 카테고리 검증
        var categoryWarning = document.getElementById("categoryWarning");
        if (category.options[category.selectedIndex].value == "0") {
            categoryWarning.innerText = "카테고리를 선택해주세요";
            categoryWarning.style.color = "red";
            category.focus();
            return false;
        }
        else{
            categoryWarning.innerText = "";
        }

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

        // 비밀번호, 비밀번호 확인 일치 검증
        if (password.value != passwordCheck.value) {
            passwordWarning.innerText = "비밀번호와 비밀번호 확인이 일치하지 않습니다";
            passwordWarning.style.color = "red";
            passwordCheck.focus();
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
        document.writeForm.submit();
    }
</script>
</body>
</html>
