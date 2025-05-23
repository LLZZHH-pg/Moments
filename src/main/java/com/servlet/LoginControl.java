package com.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import jakarta.servlet.RequestDispatcher;


@WebServlet("/login")
public class LoginControl extends HttpServlet {
    @Override
protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
    // 显示登录页面
    System.out.println("Login page displayed through mian.jsp");
    req.getRequestDispatcher("/mian.jsp").forward(req, resp);

}

//    @Override
//    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
//        // 获取用户输入
//        String account = req.getParameter("account");
//        String password = req.getParameter("password");
//
//        // TODO: 实现实际的用户验证逻辑
//        // 这里只是简单示例，实际项目中应该查询数据库验证用户
//        if ("admin".equals(account) && "admin".equals(password)) {
//            // 登录成功，创建会话
//            HttpSession session = req.getSession();
//            session.setAttribute("user", account);
//
//            // 重定向到主页
//            resp.sendRedirect("/mian.jsp");
//        } else {
//            // 登录失败，返回登录页面并显示错误信息
//            req.setAttribute("error", "用户名或密码错误");
//            req.getRequestDispatcher("/WEB-INF/templates/login_template.html").forward(req, resp);
//        }
//    }
}
