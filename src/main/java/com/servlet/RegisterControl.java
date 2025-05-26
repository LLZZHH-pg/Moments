package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

import com.model.UserControl;


@WebServlet("/register")
public class RegisterControl extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String tel = req.getParameter("tel");
        String name= req.getParameter("name");
        String password = req.getParameter("password");

        String error = validateInput(email, tel, name, password);
        if (error != null) {
            req.setAttribute("error", error);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }
        try {
            UserControl.registerUser(email, tel, name, password);

            // 注册成功处理
            HttpSession session = req.getSession();
            session.setAttribute("registerSuccess", "注册成功！");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } catch (SQLException e) {
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println("用户注册失败: " + e.getMessage());
//        resp.sendRedirect(req.getContextPath() + "/login");
            req.setAttribute("error", "注册失败请稍后重试");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
        }

    }

    private String validateInput(String email, String tel,String name, String password) {
        if (email == null || !email.matches("^[A-Za-z0-9]+@[A-Za-z0-9]+$")) {
            return "邮箱格式不正确";
        }
        if (tel == null || !tel.matches("\\d{11}")) {
            return "电话号码必须是11位数字";
        }
        if (name == null || name.length() < 2 || name.length() > 10 || !name.matches(".*[a-zA-Z].*")) {
            return "用户名需要在2~10个字符之间，且包含至少一个字母";
        }
        if (password == null || password.length() < 8 || password.length() > 16) {
            return "密码需要在8~16位之间";
        }
        return null;
    }

}
