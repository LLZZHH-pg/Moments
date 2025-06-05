package com.servlet;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.model.ContentControl;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/getContents")
public class PersonalControl_Getdata extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json;charset=UTF-8");

        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userid");

        // 如果用户未登录，返回错误信息
        if (userId == null) {
            response.getWriter().write("{\"error\": \"用户未登录\"}");
            return;
        }

        try {
            // 获取内容数据
            List<ContentControl.Content> contents = ContentControl.getdata(userId);

            // 转换为JSON
            ObjectMapper mapper = new ObjectMapper();
            String json = mapper.writeValueAsString(contents);

            response.getWriter().write(json);

        } catch (SQLException | ClassNotFoundException e) {
            response.getWriter().write("{\"error\": \"数据库错误: " + e.getMessage() + "\"}");
            e.printStackTrace();
        }
    }
}