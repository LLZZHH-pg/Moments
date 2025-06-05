package com.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.StandardCopyOption;
import java.util.UUID;

@WebServlet("/upload")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,   // 1MB
        maxFileSize = 1024 * 1024 * 50,    // 50MB
        maxRequestSize = 1024 * 1024 * 100 // 100MB
)

public class UploadPV extends HttpServlet{
// 修改上传目录路径
    private static final String UPLOAD_DIR = "D:/jweb-endwork/uploads";
    private static final String URL_PATH = "/moments_war/upfile";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // 获取应用部署路径
//        String appPath = request.getServletContext().getRealPath("");
//        String uploadPath = appPath + File.separator + UPLOAD_DIR;
//        String uploadPath = UPLOAD_DIR;
//        String uploadPath = request.getServletContext().getRealPath("/moments_war/upfile");
        String uploadPath = getServletContext().getInitParameter("uploadPath");

        // 创建上传目录
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            if (!uploadDir.mkdirs()) {
                throw new ServletException("无法创建上传目录: " + uploadPath);
            }
        }

        try {
            // 获取上传的文件
            Part filePart = request.getPart("file");
            String fileName = filePart.getSubmittedFileName();

            // 生成唯一文件名
            String extension = fileName.substring(fileName.lastIndexOf("."));
            String uniqueFileName = UUID.randomUUID().toString() + extension;

            // 保存文件
            String filePath = uploadPath + File.separator + uniqueFileName;
            try (InputStream fileContent = filePart.getInputStream()) {
                Files.copy(fileContent, new File(filePath).toPath(), StandardCopyOption.REPLACE_EXISTING);
            }

            // 构建访问URL - 使用映射后的URL路径
            String fileUrl = URL_PATH + "/" + uniqueFileName;

            // 返回JSON响应
            response.setContentType("application/json");
            response.setCharacterEncoding("UTF-8");
            response.getWriter().write("{\"errno\": 0, \"data\": {\"url\": \"" + fileUrl + "\"}}");

        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"errno\": 1, \"message\": \"" + e.getMessage() + "\"}");
        }
    }
}
