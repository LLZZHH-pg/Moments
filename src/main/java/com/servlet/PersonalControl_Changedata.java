package com.servlet;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.model.ContentControl;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
import java.io.IOException;
import java.sql.*;


@WebServlet(name = "PersonalControl_Changedata", value = {"/updateState", "/deleteContent"})
public class PersonalControl_Changedata extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        String path = request.getServletPath();
        String jsonResponse;

        try {
            if ("/updateState".equals(path)) {
                // 使用 Jackson 解析 JSON
                ObjectMapper mapper = new ObjectMapper();
                JsonNode node = mapper.readTree(request.getReader());
                String id = node.get("id").asText();
                String newState = node.get("state").asText();
                ContentControl.updateContentState(request,id, newState);
                jsonResponse = "{\"success\": true}";

            } else if ("/deleteContent".equals(path)) {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode node = mapper.readTree(request.getReader());
                String id = node.get("id").asText();
                ContentControl.deleteContent(request,id);
                jsonResponse = "{\"success\": true}";

            } else {
                jsonResponse = "{\"success\": false, \"message\": \"无效的请求路径\"}";
            }
        } catch (Exception e) {
            jsonResponse = "{\"success\": false, \"message\": \"" + e.getMessage() + "\"}";
        }

        response.getWriter().write(jsonResponse);
    }




//    private Connection getConnection() throws SQLException, ClassNotFoundException {
//        Class.forName("com.mysql.cj.jdbc.Driver");
//        String url = "jdbc:mysql://localhost:3306/user?useSSL=false&serverTimezone=UTC";
//        return DriverManager.getConnection(url, "root", "Lzh20050318!");
//    }
}
