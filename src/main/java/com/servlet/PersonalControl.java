package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

import com.model.ContentControl;

@WebServlet("/personal")
public class PersonalControl extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/personal.jsp").forward(req, resp);
    }
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        resp.setContentType("text/html;charset=UTF-8");

        String state = req.getParameter("state");
        String content = req.getParameter("content");

        HttpSession session = req.getSession();
        String userId = (String) session.getAttribute("userid");
//        Object user = session.getAttribute("user");

// 如果用户未登录，重定向到登录页面
//        if (user == null) {
//
//            resp.sendRedirect(req.getContextPath() + "/login");
//            return;
//        }

        try {
            if ("private".equals(state)) {
                // 处理私密发布逻辑
                // savePrivateContent(user, content);
                ContentControl.storage(userId, content, state);
                session.setAttribute("message", "内容已上传");
            } else if ("public".equals(state)) {
                // 处理公开发布逻辑
                // savePublicContent(user, content);
                ContentControl.storage(userId, content, state);
                session.setAttribute("message", "内容已发布到广场");
            }else if("save".equals(state)) {
                // 处理保存草稿逻辑
                // saveDraftContent(user, content);
                ContentControl.storage(userId, content, state);
                session.setAttribute("message", "草稿已保存");
            }

//            resp.sendRedirect(req.getContextPath() + "/personal");
            req.getRequestDispatcher("/WEB-INF/views/personal.jsp").forward(req, resp);
        } catch (Exception e) {
            // 发生错误时
            req.setAttribute("error", "发布失败：" + e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/personal.jsp").forward(req, resp);
        }
    }
}
