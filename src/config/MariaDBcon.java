package config;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
 
public class MariaDBcon {
    String driver = "org.mariadb.jdbc.Driver";
    Connection con;
    PreparedStatement pstmt;
    ResultSet rs;
 
    public MariaDBcon() {
        try {
           Class.forName(driver);
           con = DriverManager.getConnection(
                   "jdbc:mariadb://192.168.131.137:3306/JCHDB","jch","1234");
           
           if( con != null ) {
               System.out.println("DB 접속 성공");
           }
           
       } catch (ClassNotFoundException e) { 
           System.out.println("드라이버 로드 실패");
       } catch (SQLException e) {
           System.out.println("DB 접속 실패");
           e.printStackTrace();
       }
   }
    
    /**
    public MariaDBcon() {
         try {
            Class.forName(driver);
            con = DriverManager.getConnection(
                    "jdbc:mariadb://mydb.ce5kfjcsm0mx.ap-northeast-2.rds.amazonaws.com:3306/myAwsDB","poly","Poly01!");
            
            if( con != null ) {
                System.out.println("DB 접속 성공");
            }
            
        } catch (ClassNotFoundException e) { 
            System.out.println("드라이버 로드 실패");
        } catch (SQLException e) {
            System.out.println("DB 접속 실패");
            e.printStackTrace();
        }
    }
    **/
    public static void main(String[] args){
        MariaDBcon dbcon    = new MariaDBcon();
    }
}
