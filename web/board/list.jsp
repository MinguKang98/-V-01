<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-03
  Time: 오전 1:27
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<html>
<head>
    <title>게시판 목록</title>
</head>
<body>
<%
    request.setCharacterEncoding("UTF-8");

    // 검색조건
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
<div>
    <a href="/_V_01_war_exploded/board/list.jsp">Home</a>
</div>
<div>
    <form method="get" name="searchForm" id="searchForm" action="/_V_01_war_exploded/board/list.jsp">
        <label>등록일</label>
        <input type="date" name="searchCreatedDateFrom" id="searchCreatedDateFrom"/>
        <label> ~ </label>
        <input type="date" name="searchCreatedDateTo" id="searchCreatedDateTo"/>
        <select name="searchCategory" id="searchCategory">
            <option value="0">전체 카테고리</option>
            <%
                sql = "select * from category";
                pstmt = con.prepareStatement(sql);
                rs = pstmt.executeQuery();

                HashMap<Integer, String> categoryMap = new HashMap<>();
                while (rs.next()) {
                    int id = rs.getInt("category_id");
                    String name = rs.getString("name");
                    categoryMap.put(id, name);
            %>
            <option value="<%=id%>"><%=name%>
            </option>
            <%
                }
            %>
        </select>
        <input type="text" name="searchText" id="searchText" placeholder="검색어를 입력해 주세요. (제목+작성자+내용)"/>
        <button type="submit">검색</button>
    </form>
</div>

<div>
    <%
        sql = "select count(*) as count from board";
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();
        rs.next();
        int totalBoardNum = rs.getInt("count");
    %>
    <label>총 <%=totalBoardNum%>건</label>
</div>
<table>
    <thead>
    <tr>
        <th>카테고리</th>
        <th></th>
        <th>제목</th>
        <th>작성자</th>
        <th>조회수</th>
        <th>등록 일시</th>
        <th>수정 일시</th>
    </tr>
    </thead>
    <tbody>
    <%!
        public boolean isNullOrEmpty(String str) {
            return (str == null || str.equals("") || str.equals("null"));
        }
    %>
    <%
        boolean searchCreatedDateFromIsNullOrEmpty = isNullOrEmpty(searchCreatedDateFrom);
        boolean searchCreatedDateToIsNullOrEmpty = isNullOrEmpty(searchCreatedDateTo);
        boolean searchCategoryIdIsNullOrEmpty = isNullOrEmpty(searchCategoryId);
        boolean searchTextIsNullOrEmpty = isNullOrEmpty(searchText);

        // 등록일 조건
        String searchDateQuery = (searchCreatedDateFromIsNullOrEmpty || searchCreatedDateToIsNullOrEmpty)
                ? "" : String.format("where (date(created_date) between \"%s\" and \"%s\")", searchCreatedDateFrom, searchCreatedDateTo);

        // 카테고리 조건
        String searchCategoryQuery = (searchCategoryIdIsNullOrEmpty || searchCategoryId.equals("0")) ?
                "" : String.format(" and category_id = %s", searchCategoryId);

        // 검색어 조건
        String likeQuery = " and (user like \'%" + searchText + "%\' or title like \'%" + searchText + "%\' or content like \'%" + searchText + "%\')";
        String searchTextQuery = (searchTextIsNullOrEmpty) ?
                "" : likeQuery;

        sql = "select * from board " + searchDateQuery + searchCategoryQuery + searchTextQuery;
        System.out.println(sql);
        pstmt = con.prepareStatement(sql);
        rs = pstmt.executeQuery();

        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy.MM.dd HH:mm");
        while (rs.next()) {
            int boardId = rs.getInt("board_id");
            int category_id = rs.getInt("category_id");
            boolean fileExist = rs.getBoolean("file_exist");
            String title = rs.getString("title");
            String user = rs.getString("user");
            int visitCount = rs.getInt("visit_count");
            String createdDate = dateFormat.format(rs.getTimestamp("created_date"));
            String updatedDate = "-";
            if (rs.getTimestamp("updated_date") != null) {
                updatedDate = dateFormat.format(rs.getTimestamp("updated_date"));
            }
            int commentCount = rs.getInt("comment_count");

            // 제목 80자 이상일시 '...' 로 축약
            if (title.length() > 80) {
                title = title.substring(0, 80) + "...";
            }
    %>
    <tr>
        <td><%=categoryMap.get(category_id)%>
        </td>
        <td><%=fileExist%>
        </td>
        <td>
            <a href="/_V_01_war_exploded/board/view.jsp?board_id=<%=boardId%>&searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>">
                <%=title%> (<%=commentCount%>)
            </a></td>
        <td><%=user%>
        </td>
        <td><%=visitCount%>
        </td>
        <td><%=createdDate%>
        </td>
        <td><%=updatedDate%>
        </td>
    </tr>
    <%
        }
    %>
    </tbody>
</table>

<!--페이징징징-->

<div>
    <button type="button"
            onclick="location.href='/_V_01_war_exploded/board/write.jsp?searchCreatedDateFrom=<%=searchCreatedDateFrom%>&searchCreatedDateTo=<%=searchCreatedDateTo%>&searchCategory=<%=searchCategoryId%>&searchText=<%=searchText%>'">
        등록
    </button>
</div>
<%
    rs.close();
    pstmt.close();
    con.close();
%>
<script>
    function getDate() {
        var today = new Date();
        var year = today.getFullYear();
        var month = ('0' + (today.getMonth() + 1)).slice(-2);
        var day = ('0' + today.getDate()).slice(-2);
        return year + '-' + month + '-' + day;
    }

    var searchCreatedDateFrom = document.getElementById("searchCreatedDateFrom");
    var searchCreatedDateTo = document.getElementById("searchCreatedDateTo");
    var searchCategory = document.getElementById("searchCategory");
    var searchText = document.getElementById("searchText");

    // 등록일 값이 없을때 오늘 반환
    if (<%=searchCreatedDateFromIsNullOrEmpty%>) {
        searchCreatedDateFrom.value = getDate();
    } else {
        searchCreatedDateFrom.value = "<%=searchCreatedDateFrom%>";
    }

    if (<%=searchCreatedDateFromIsNullOrEmpty%>) {
        searchCreatedDateTo.value = getDate();
    } else {
        searchCreatedDateTo.value = "<%=searchCreatedDateTo%>";
    }

    // 값이 있으면 카테고리 value 반환
    if (<%=searchCategoryIdIsNullOrEmpty || searchCategoryId.equals("0")%>) {
        searchCategory.options[0].selected = "selected";
    } else {
        searchCategory.options[<%=searchCategoryId%>].selected = "selected";
    }

    // 값이 있으면 text value 반환
    if (!<%=searchTextIsNullOrEmpty%>) {
        searchText.value = "<%=searchText%>";
    }
</script>
</body>
</html>
