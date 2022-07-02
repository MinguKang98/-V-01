import java.sql.*;

public class MariaDBConnector {
    public static void main(String[] args) {
        Connection con = null;
        PreparedStatement pstmt=null;
        ResultSet rs=null;

        String server = "localhost:3306";
        String database = "board_v1";
        String user_name = "mingu";
        String password = "1234";

        try {
            Class.forName("org.mariadb.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.err.println(" 드라이버 로딩 오류 : " + e.getMessage());
            e.printStackTrace();
        }

        try {
            con = DriverManager.getConnection("jdbc:mariadb://" +
                    server + "/" +
                    database +
                    "?useSSL=false", user_name, password); // SSL 실행 확인
            System.out.println("연결 성공");

            String sql="select * from test";
            pstmt = con.prepareStatement(sql);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int id = rs.getInt("ID");
                System.out.println(id);
            }
        } catch(SQLException e) {
            System.err.println("에러 내용 :" + e.getMessage());
            e.printStackTrace();
        }

        try {
            if(con != null)
                con.close();
        } catch (SQLException e) {}
    }
}
