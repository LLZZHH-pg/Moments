<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>登录</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/static/css/bootstrap.min.css">
    <script>
        window.onload = function() {
            let error = '<%= request.getAttribute("error") %>';
            if (error !== "null") {
                alert(error);
                window.location.href = '${pageContext.request.contextPath}/login';
            }
        };
    </script>
</head>
<body>
<div class="container-fluid d-flex align-items-center " style="height: 100vh">
    <div class="container d-flex flex-column">
        <div class="row">
            <div class="col-5"></div>
            <div class="col-2 "><h1 class="text-center">登录</h1></div>
            <div class="col-5"></div>
        </div>
        <div class="row">
            <div class="col-4"></div>
            <div class="col-4 ">
                <form action="${pageContext.request.contextPath}/login" method="post" class="d-flex flex-column align-items-center">
                    <div class="input-group mb-3">
                        <span class="input-group-text justify-content-center" id="account"
                              style="width: 4em;"> 账号</span>
                        <input type="text" class="form-control" placeholder="电话号码/邮箱/用户名" aria-label="电话号码/邮箱/用户名"
                               aria-describedby="account" name="account">
                    </div>
                    <div class="input-group mb-3">
                        <span class="input-group-text justify-content-center" id="password"
                              style="width: 4em;">密码</span>
                        <input type="password" class="form-control" placeholder="输入密码" aria-label="输入密码"
                               aria-describedby="password" name="password">
                    </div>
                    <button type="submit" class="btn btn-primary">登录</button>
                </form>
                <div class="d-flex flex-column align-items-center" style="margin-top: 1rem;">
                    <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/register'">注册
                    </button>
                </div>
            </div>
            <div class="col-4"></div>
        </div>
    </div>
</div>
</body>
</html>
