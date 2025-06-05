package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;

@WebServlet("/deleteFile")
public class DeletePV extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 使用getServletContext().getInitParameter获取物理路径
        String uploadPath = getServletContext().getInitParameter("uploadPath");

        String fileUrl = request.getParameter("fileUrl");

        // 从URL中提取文件名
        String fileName = fileUrl.substring(fileUrl.lastIndexOf("/") + 1);

        // 使用物理路径
        String filePath = uploadPath + File.separator + fileName;

        File file = new File(filePath);
        boolean success = false;
        String message = "文件删除成功";

        if (file.exists()) {
            success = file.delete();
            if (!success) {
                message = "文件删除失败";
            }
        } else {
            message = "文件不存在";
        }

        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        response.getWriter().write("{\"success\": " + success + ", \"message\": \"" + message + "\"}");
    }
}
