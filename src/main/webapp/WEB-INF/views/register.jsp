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
            }

            let successMsg = "<%= session.getAttribute("registerSuccess") %>";
            if (successMsg && successMsg !== "null") {
                alert(successMsg);
                <% session.removeAttribute("registerSuccess"); %>
                window.location.href = '${pageContext.request.contextPath}/login';
            }
        };
    </script>
</head>
<body>
<div class="container-fluid d-flex align-items-center " style="height: 100vh">
    <div class="container d-flex flex-column ">
        <div class="row">
            <div class="col-5"></div>
            <div class="col-2 "><h1 class="text-center">注册</h1></div>
            <div class="col-5"></div>
        </div>
            <div class="row">
                <div class="col-4"></div>
                <div class="col-4 ">
                    <form action="${pageContext.request.contextPath}/register" method="post" class="d-flex flex-column align-items-center">
                        <div class="input-group mb-3">
                            <span class="input-group-text justify-content-center" id="email" style="width: 6em;">邮箱账号</span>
                            <input type="text" class="form-control" placeholder="邮箱账号" aria-label="邮箱账号" aria-describedby="email" name="email">
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text justify-content-center" id="tel" style="width: 6em;">电话号码</span>
                            <input type="text" class="form-control" placeholder="电话号码" aria-label="电话号码" aria-describedby="tel" name="tel">
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text justify-content-center" id="name" style="width: 6em;">用户名</span>
                            <input type="text" class="form-control" placeholder="用户名" aria-label="用户名" aria-describedby="tel" name="name">
                        </div>
                        <div class="input-group mb-3">
                            <span class="input-group-text justify-content-center" id="password" style="width: 6em;">设置密码</span>
                            <input type="password" class="form-control" placeholder="密码" aria-label="密码" aria-describedby="password" name="password">
                        </div>
<%--                        <div class="input-group mb-3">--%>
<%--                            <span class="input-group-text justify-content-center" id="passwordT" style="width: 6em;">确认密码</span>--%>
<%--                        <input type="password" class="form-control" placeholder="确认密码" aria-label="确认密码" aria-describedby="passwordT">--%>
<%--                        </div>--%>
                        <button type="submit" class="btn btn-primary">立即注册</button>
                    </form>
                    <div class="d-flex flex-column align-items-center" style="margin-top: 1rem;">
                        <button type="button" class="btn btn-primary" onclick="window.location.href='${pageContext.request.contextPath}/login'">返回登录</button>
                    </div>
                </div>
                <div class="col-4"></div>
            </div>

    </div>
</div>

</body>
</html>
