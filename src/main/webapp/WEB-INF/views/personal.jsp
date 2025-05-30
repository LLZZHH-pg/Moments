<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>个人界面</title>
    <link href="${pageContext.request.contextPath}/resources/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://unpkg.com/@wangeditor-next/editor@latest/dist/css/style.css" rel="stylesheet">
    <style>
        #editor-wrapper {
            border: 1px solid #ccc;
            z-index: 100;
        }
        #toolbar-container { border-bottom: 1px solid #ccc; }
        #post-or-save{height: 5vh}
        #editor-container { height: 85.5vh ;min-height: 300px;width: auto}
    </style>

    <script src="${pageContext.request.contextPath}/resources/static/js/bootstrap.bundle.min.js"></script>
    <script>
        window.onload = function() {
            let error = '<%= request.getAttribute("error") %>';
            if (error !== "null") {
                alert(error);
                <% session.removeAttribute("error");%>
            }

            let successMsg = "<%= session.getAttribute("message") %>";
            if (successMsg && successMsg !== "null") {
                alert(successMsg);
                <% session.removeAttribute("message"); %>
                window.location.href = '${pageContext.request.contextPath}/personal';
            }
        };
    </script>
</head>

<body>
    <div class="container-fluid d-flex align-items-start" style="height: 100vh; width:100%">
<%--        <div class="col-1 btn-group-vertical" id="tab" role="group" aria-label="nav buttons">--%>
<%--            <input type="radio" class="btn-check" name="btn-radio" id="home-tab" autocomplete="off" checked>--%>
<%--            <label class="btn btn-outline-primary" for="home-tab">个人主页</label>--%>
<%--            <input type="radio" class="btn-check" name="btn-radio" id="write-tab" autocomplete="off">--%>
<%--            <label class="btn btn-outline-primary" for="write-tab">写心记</label>--%>
<%--        </div>--%>

        <div class="col-1 nav flex-column align-items-start nav-pills mt-5"  role="tablist" aria-orientation="vertical">
            <button class="nav-link active" id="home-tab" data-bs-toggle="pill" data-bs-target="#home"
                style="width: 6em;"
                type="button" role="tab" aria-controls="home" aria-selected="true">个人主页
            </button>
            <button class="nav-link" id="write-tab" data-bs-toggle="pill" data-bs-target="#write"
                style="width: 6em;"
                type="button" role="tab" aria-controls="write" aria-selected="false">写心记
            </button>
<%--            <button class="nav-link" id="turn_to_square-tab" data-bs-toggle="pill" data-bs-target="#turn_to_square"--%>
<%--                    type="button" role="tab" aria-controls="turn_to_square" aria-selected="false">去广场--%>
<%--            </button>--%>
        </div>
        <div class="col-11 tab-content" id="tabContent">
            <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
            </div>

            <div class="tab-pane fade" id="write" role="tabpanel" aria-labelledby="write-tab" tabindex="0">
                <div class="d-flex flex-column align-items-end justify-content-center" id="post-or-save">
                    <div class="btn-group" role="group" aria-label="post or save buttons" >
                        <div class="btn-group" role="group">
                            <button type="button" class="btn btn-primary dropdown-toggle" data-bs-toggle="dropdown"
                                    aria-expanded="false">
                                发布
                            </button>
                            <ul class="dropdown-menu">
                                <li><a class="dropdown-item" href="#" onclick="submitForm('private')">私密查看</a></li>
                                <li><a class="dropdown-item" href="#" onclick="submitForm('public')">公开到广场</a></li>
                            </ul>
                        </div>
                        <%--                    <button type="button" class="btn btn-primary">发布</button>--%>
                        <button type="button" onclick="submitForm('save')" class="btn btn-success">保存</button>
                    </div>
                </div>
                <div id="editor-wrapper">
                    <div id="editor-toolbar"><!-- 工具栏 --></div>
                    <div id="editor-container"><!-- 编辑器 --></div>
                </div>
            </div>
<%--                <div class="tab-pane fade" id="turn_to_square" role="tabpanel" aria-labelledby="turn_to_square-tab" tabindex="0">--%>
<%--                    --%>
<%--                </div>--%>
        </div>
    </div>
    <script src="https://unpkg.com/@wangeditor-next/editor@latest/dist/index.js"></script>
    <script>
        // const E = window.wangEditor
        // window.editor = E.createEditor({
        //     selector: '#editor-container',
        //     config: {
        //         placeholder: '在这里书写...',
        //         MENU_CONF: {
        //             uploadImage: {
        //                 fieldName: 'your-fileName',
        //                 base64LimitSize: 10 * 1024 * 1024 // 10M 以下插入 base64
        //             }
        //         },
        //         onChange(editor) {
        //             const html = editor.getHtml()
        //             // document.getElementById('editor-container').value = html
        //             console.log('editor content', html)
        //         }
        //     }
        // })
        //
        // window.toolbar = E.createToolbar({
        //     editor,
        //     selector: '#editor-toolbar',
        //     config: {},
        //     mode: 'default',
        // })
        document.addEventListener('DOMContentLoaded', function() {
            try {
                const E = window.wangEditor;
                window.editor = E.createEditor({
                    selector: '#editor-container',
                    config: {
                        placeholder: '在这里书写...',
                        MENU_CONF: {
                            uploadImage: {
                                server: '${pageContext.request.contextPath}/upload',
                                fieldName: 'file',
                                maxFileSize: 5 * 1024 * 1024,
                                base64LimitSize: 0, // 禁用base64
                                customInsert: function(res, insertFn) {
                                    if (res.errno === 0 && res.data && res.data.url) {
                                        insertFn(res.data.url, '', ''); // 插入图片
                                    } else {
                                        alert('图片上传失败: ' + (res.message || '未知错误'));
                                    }
                                }
                            },
                            uploadVideo: {
                                server: '${pageContext.request.contextPath}/upload',
                                fieldName: 'file',
                                maxFileSize: 20 * 1024 * 1024,
                                base64LimitSize: 0

                            }
                        },
                        // onChange(editor) {
                        //     const html = editor.getHtml();
                        //     console.log('editor content', html);
                        // }
                    }
                });

                window.toolbar = E.createToolbar({
                    editor: window.editor,
                    selector: '#editor-toolbar',
                    config: {},
                    mode: 'default',
                });
            } catch (error) {
                console.error('编辑器初始化失败:', error);
                // alert('编辑器初始化失败: ' + error.message);
            }
        });


        function submitForm(state) {

            if (!window.editor) {
                console.error('编辑器尚未初始化完成');
                // alert('编辑器尚未初始化完成，请稍后再试');
                return;
            }

            const content = window.editor.getHtml();

            // 创建表单
            const form = document.createElement('form');
            form.method = 'post';
            form.action = '${pageContext.request.contextPath}/personal';

            // 添加状态参数
            const stateInput = document.createElement('input');
            stateInput.type = 'hidden';
            stateInput.name = 'state';
            stateInput.value = state;
            form.appendChild(stateInput);

            // 添加内容参数
            const contentInput = document.createElement('input');
            contentInput.type = 'hidden';
            contentInput.name = 'content';
            contentInput.value = content;
            form.appendChild(contentInput);

            // 提交表单
            document.body.appendChild(form);
            form.submit();
            document.body.removeChild(form);
        }
    </script>
</body>
</html>
