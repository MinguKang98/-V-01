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
    String confirm = request.getParameter("confirm");
%>
<html>
<head>
    <title>비밀번호 확인</title>
</head>
<body>
<form method="post" name="passwordConfirmForm" id="passwordConfirmForm"
      action="/_V_01_war_exploded/board/passwordConfirmProcess.jsp?board_id=<%=boardId%>&type=<%=type%>">
    <table>
        <tr>
            <th>비밀번호</th>
            <td>
                <input type="password" name="password" id="password" placeholder="비밀번호" required />
            </td>
        </tr>

    </table>

    <button type="button" onclick="location.href='/_V_01_war_exploded/board/view.jsp?board_id=<%=boardId%>'">취소</button>
    <button type="submit">확인</button>
</form>

<script>
    if("<%=confirm%>"=="fail"){
        alert("비밀번호가 일치하지 않습니다.");
    }

</script>
</body>
</html>
