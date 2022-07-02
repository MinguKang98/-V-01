<%@ page import="java.sql.*" %>
<%--
  Created by IntelliJ IDEA.
  User: alsrn
  Date: 2022-07-02
  Time: 오후 3:14
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>$Title$</title>
  </head>
  <body>
  $END$
  <%
    Connection con = null;
    PreparedStatement pstmt=null;
    ResultSet rs=null;

    String server = "localhost:3306";
    String database = "board_v1";
    String user_name = "mingu";
    String password = "1234";

    Class.forName("org.mariadb.jdbc.Driver");
    con = DriverManager.getConnection("jdbc:mariadb://" +
            server + "/" +
            database, user_name, password);

    String sql="select * from test";
    pstmt = con.prepareStatement(sql);
    rs = pstmt.executeQuery();

    while (rs.next()) {
      int id = rs.getInt("ID");
  %>
  <tr>
    <td><%=id%></td>
  </tr>
  <%
      }
  %>
  <%
    rs.close();
    pstmt.close();
    con.close();
  %>
  </body>
</html>
