package com.model;
import java.sql.*;
import java.util.UUID;

public class ContentControl {
    public static void storage(String userId, String content, String state)throws SQLException, ClassNotFoundException{
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/user?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "Lzh20050318!";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            String contentId = UUID.randomUUID().toString();
            Timestamp timestamp = new Timestamp(System.currentTimeMillis());

            String sql = "INSERT INTO content (id, userId, content, time, state, likes) VALUES (?, ?, ?, ?, ?, ?)";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, contentId);
            stmt.setString(2, userId);
            stmt.setString(3, content);
            stmt.setTimestamp(4, timestamp);
            stmt.setString(5, state);
            stmt.setInt(6, 0);

            stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
}
