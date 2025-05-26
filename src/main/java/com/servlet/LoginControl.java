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

@WebServlet("/login")
public class LoginControl extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.getRequestDispatcher("/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String account = req.getParameter("account");
        String password = req.getParameter("password");

        try {
            UserControl.loginUser(account, password);
            HttpSession session = req.getSession();
            session.setAttribute("user", account);
            resp.sendRedirect(req.getContextPath() + "/square.jsp");

        } catch (SQLException e) {
            System.err.println("login fail: " + e.getMessage());
            req.setAttribute("error", e.getMessage());
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        } catch (Exception e) {
            System.err.println(e.getMessage());
            req.setAttribute("error", "µ«¬º ß∞‹«Î…‘∫Û÷ÿ ‘");
            req.getRequestDispatcher("/login.jsp").forward(req, resp);
        }


    }
}