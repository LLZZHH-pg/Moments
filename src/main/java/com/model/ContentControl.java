package com.model;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

import java.sql.*;
import java.util.UUID;
import java.util.List;
import java.util.ArrayList;

public class ContentControl {

    public static void updateContent(String contentId, String newContent, String newState)
            throws SQLException, ClassNotFoundException {

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = getConnection();
            String sql = "UPDATE content SET content = ?, state = ?, time = ? WHERE id = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newContent);
            stmt.setString(2, newState);
            stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
            stmt.setString(4, contentId);
            stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public static void storage(String userId, String content, String state, String contentId)
            throws SQLException, ClassNotFoundException {

        Connection conn = null;
        PreparedStatement stmt = null;

        try {
            conn = getConnection();

            if (contentId == null || contentId.isEmpty()) {
                // 新增内容
                contentId = UUID.randomUUID().toString();
                String sql = "INSERT INTO content (id, uid, content, time, state, likes) VALUES (?, ?, ?, ?, ?, ?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, contentId);
                stmt.setString(2, userId);
                stmt.setString(3, content);
                stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                stmt.setString(5, state);
                stmt.setInt(6, 0);
            } else {
                // 更新内容
                String sql = "UPDATE content SET content = ?, state = ?, time = ? WHERE id = ?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, content);
                stmt.setString(2, state);
                stmt.setTimestamp(3, new Timestamp(System.currentTimeMillis()));
                stmt.setString(4, contentId);
            }

            stmt.executeUpdate();

        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }
    public static List<Content> getdata(String userId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;
        List<Content> contents = new ArrayList<>();

        try {
            conn= getConnection();

            String sql = "SELECT id, content, time, state, likes FROM content WHERE uid = ? ORDER BY time DESC";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, userId);

            rs = stmt.executeQuery();

            while (rs.next()) {
                Content content = new Content();
                content.setId(rs.getString("id"));
                content.setContent(rs.getString("content"));
                content.setTime(rs.getTimestamp("time"));
                content.setState(rs.getString("state"));
                content.setLikes(rs.getInt("likes"));
                contents.add(content);
            }

            return contents;

        } finally {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    // 内部类用于存储内容数据
    public static class Content {
        private String id;
        private String content;
        private Timestamp time;
        private String state;
        private int likes;

        // Getters and Setters
        public String getId() { return id; }
        public void setId(String id) { this.id = id; }

        public String getContent() { return content; }
        public void setContent(String content) { this.content = content; }

        public Timestamp getTime() { return time; }
        public void setTime(Timestamp time) { this.time = time; }

        public String getState() { return state; }
        public void setState(String state) { this.state = state; }

        public int getLikes() { return likes; }
        public void setLikes(int likes) { this.likes = likes; }
    }

    public static void updateContentState(HttpServletRequest request, String id, String newState) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement stmt = null;

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userid");

        try {
            conn = getConnection();
            // 添加用户ID验证
            String sql = "UPDATE content SET state = ?, time = ? WHERE id = ? AND uid = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, newState);
            stmt.setTimestamp(2, new Timestamp(System.currentTimeMillis()));
            stmt.setString(3, id);
            stmt.setString(4, userId); // 验证当前用户
            int updated = stmt.executeUpdate();

            if (updated == 0) {
                throw new SecurityException("无权修改此内容");
            }
        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    public static void deleteContent(HttpServletRequest request, String id) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement stmt = null;

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userid");

        try {
            conn = getConnection();
            String sql = "DELETE FROM content WHERE id = ? AND uid = ?";
            stmt = conn.prepareStatement(sql);
            stmt.setString(1, id);
            stmt.setString(2, userId);
            int updated = stmt.executeUpdate();

            if (updated == 0) {
                throw new SecurityException("无权修改此内容");
            }

        } finally {
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        }
    }

    private static Connection getConnection() throws ClassNotFoundException, SQLException {
        Class.forName("com.mysql.cj.jdbc.Driver");
        String url = "jdbc:mysql://localhost:3306/user?useSSL=false&serverTimezone=UTC";
        String dbUser = "root";
        String dbPassword = "Lzh20050318!";
        return DriverManager.getConnection(url, dbUser, dbPassword);
    }
}
