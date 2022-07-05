<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-05
  Time: 오후 4:20
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    request.setCharacterEncoding("UTF-8");
    String boardId = request.getParameter("board_id");
    String type = request.getParameter("type");
%>
<html>
<head>
    <title>비밀번호 확인</title>
</head>
<body>
<form method="post" name="passwordConfirmForm" id="passwordConfirmForm">
    <table>
        <tr>
            <th>비밀번호</th>
            <td>
                <input type="password" name="password" id="password" placeholder="비밀번호" required />
            </td>
        </tr>

    </table>

    <button type="button" onclick="location.href='/_V_01_war_exploded/board/view.jsp?board_id=<%=boardId%>'">취소</button>
    <button type="button" onclick="validCheck()">저장</button>
</form>

<script>
    //action="/_V_01_war_exploded/board/modifyProcess.jsp?board_id=<%=boardId%>
    function validCheck() {

    }
</script>
</body>
</html>
