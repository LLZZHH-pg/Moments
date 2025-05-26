package com.model;
import java.sql.*;

public class UserControl {
    public static void registerUser(String email, String tel, String name, String password) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/user?useSSL=false&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "Lzh20050318!";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            // 检查邮箱是否已存在
            boolean accountExists = isAccountExists(conn, email, tel, name);

            if (accountExists) {
                String userID = getUserID(conn);

                String sql = "INSERT INTO user_info (UID, EML, TEL, NAM, PAS) VALUES (?, ?, ?, ?, ?)";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, userID);
                stmt.setString(2, email);
                stmt.setString(3, tel);
                stmt.setString(4, name);
                stmt.setString(5, password);

                int result = stmt.executeUpdate();
                if (result <= 0) {
                    throw new SQLException("注册失败请稍后重试");
                }
                stmt.close();
            }
        } finally {
            if (conn != null) conn.close();
        }
    }

    private static Boolean isAccountExists(Connection conn, String email, String tel, String name) throws SQLException {
        if (email != null) {
            String checkEmailSql = "SELECT COUNT(*) FROM user_info WHERE EML = ?";
            PreparedStatement emailStmt = conn.prepareStatement(checkEmailSql);
            emailStmt.setString(1, email);
            ResultSet emailRs = emailStmt.executeQuery();
            if (emailRs.next() && emailRs.getInt(1) > 0) {
                throw new SQLException("该邮箱已被注册");
            }
        }

        if (tel != null) {
            String checkTelSql = "SELECT COUNT(*) FROM user_info WHERE TEL = ?";
            PreparedStatement telStmt = conn.prepareStatement(checkTelSql);
            telStmt.setString(1, tel);
            ResultSet telRs = telStmt.executeQuery();
            if (telRs.next() && telRs.getInt(1) > 0) {
                throw new SQLException("该手机号已被注册");
            }
        }

        if (name != null) {
            String checkNameSql = "SELECT COUNT(*) FROM user_info WHERE TEL = ?";
            PreparedStatement telStmt = conn.prepareStatement(checkNameSql);
            telStmt.setString(1, tel);
            ResultSet telRs = telStmt.executeQuery();
            if (telRs.next() && telRs.getInt(1) > 0) {
                throw new SQLException("该用户名已被注册");
            }
        }
        return true;
    }

    private static String getUserID(Connection conn) throws SQLException {
        String sql = "SELECT MAX(UID) as maxID FROM user_info";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery("SELECT MAX(UID) as maxID FROM user_info");
        if (rs.next()) {
            String maxId = rs.getString("maxID");
            if (maxId == null) return "000001";
            return String.format("%06d", Integer.parseInt(maxId) + 1);
        }
        return "000001";
    }

    public static void loginUser(String account, String password) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            String url = "jdbc:mysql://localhost:3306/user?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
            String dbUser = "root";
            String dbPassword = "Lzh20050318!";
            conn = DriverManager.getConnection(url, dbUser, dbPassword);

            if(account.contains("@")){
                String sql = "SELECT * FROM user_info WHERE EML = ? AND PAS = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, account);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) {
                    throw new SQLException("邮箱或密码错误");
                }
            }
            else if (account.matches(".*[a-zA-Z].*")) {
                String sql = "SELECT * FROM user_info WHERE NAM = ? AND PAS = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, account);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) {
                    throw new SQLException("用户名或密码错误");
                }
            }
            else if( account.matches("\\d{11}")) {

                String sql = "SELECT * FROM user_info WHERE TEL = ? AND PAS = ?";
                PreparedStatement stmt = conn.prepareStatement(sql);
                stmt.setString(1, account);
                stmt.setString(2, password);
                ResultSet rs = stmt.executeQuery();
                if (!rs.next()) {
                    throw new SQLException("电话或密码错误");
                }
            }
            else{
                throw new SQLException("账号格式不正确");
            }

        } finally {
            if (conn != null) conn.close();
        }
    }
}
