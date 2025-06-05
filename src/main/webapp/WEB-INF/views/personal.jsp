<%@ page contentType="text/html;charset=UTF-8" language="java" isELIgnored="false"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>个人界面</title>
    <link href="${pageContext.request.contextPath}/resources/static/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/resources/static/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://unpkg.com/@wangeditor-next/editor@latest/dist/css/style.css" rel="stylesheet">
    <style>
        #editor-wrapper {
            border: 1px solid #ccc;
            z-index: 100;
        }
        #toolbar-container { border-bottom: 1px solid #ccc; }
        #post-or-save{height: 5vh}
        #editor-container { height: 85.5vh ;min-height: 300px;width: auto}

        /* 个人主页卡片样式 */
        .card-container {
            margin-top: 20px;
        }
        .card {
            margin-bottom: 15px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
        .card-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            background-color: #f8f9fa;
        }
        .badge {
            font-size: 0.85em;
            padding: 5px 10px;
        }
        .empty-message {
            text-align: center;
            padding: 40px;
            color: #6c757d;
            font-size: 1.2em;
        }
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

            // 页面加载时初始化个人主页内容
            // loadPersonalHome();
        };
    </script>
</head>

<body>
<div class="container-fluid d-flex align-items-start" style="height: 100vh; width:100%">
    <div class="col-1 nav flex-column align-items-start nav-pills mt-5"  role="tablist" aria-orientation="vertical">
        <button class="nav-link active" id="home-tab" data-bs-toggle="pill" data-bs-target="#home"
                style="width: 6em;"
                type="button" role="tab" aria-controls="home" aria-selected="true">个人主页
        </button>
        <button class="nav-link" id="write-tab" data-bs-toggle="pill" data-bs-target="#write"
                style="width: 6em;"
                type="button" role="tab" aria-controls="write" aria-selected="false">写心记
        </button>
    </div>
    <div class="col-11 tab-content" id="tabContent">
        <!-- 个人主页内容区域 -->
        <div class="tab-pane fade show active" id="home" role="tabpanel" aria-labelledby="home-tab" tabindex="0">
            <div class="card-container" id="home-content">
                <!-- 内容将通过JS动态加载 -->
            </div>
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
                    <button type="button" onclick="submitForm('save')" class="btn btn-success">保存</button>
                </div>
            </div>
            <div id="editor-wrapper">
                <div id="editor-toolbar"><!-- 工具栏 --></div>
                <div id="editor-container"><!-- 编辑器 --></div>
            </div>
        </div>
    </div>
</div>
<script src="https://unpkg.com/@wangeditor-next/editor@latest/dist/index.js"></script>
<script>
    let insertedImages = new Set();
    let currentContentId = null;
    document.addEventListener('DOMContentLoaded', function() {
        loadPersonalHome()
        try {
            const E = window.wangEditor;
            window.editor = E.createEditor({
                selector: '#editor-container',
                config: {
                    placeholder: '在这里书写...',
                    // html: {
                    //     style: true, // 允许内联样式
                    //     class: true, // 允许HTML类
                    //     parseFilterRules: () => true, // 让所有规则都通过
                    //     renderElmRules: () => true,
                    //     skipWhitelist: true, // 跳过白名单过滤
                    //     ignoreWhitelist: true // 忽略白名单规则
                    // },
                    MENU_CONF: {
                        uploadImage: {
                            server: '${pageContext.request.contextPath}/upload',
                            fieldName: 'file',
                            maxFileSize: 5 * 1024 * 1024,
                            base64LimitSize: 0,
                            customInsert: function(res, insertFn) {
                                if (res.errno === 0 && res.data && res.data.url) {
                                    insertFn(res.data.url, '', '');
                                    insertedImages.add(res.data.url);
                                } else {
                                    alert('图片上传失败: ' + (res.message || '未知错误'));
                                }
                            }
                        },
                        <%--uploadVideo: {--%>
                        <%--    server: '${pageContext.request.contextPath}/upload',--%>
                        <%--    fieldName: 'file',--%>
                        <%--    maxFileSize: 20 * 1024 * 1024,--%>
                        <%--    base64LimitSize: 0--%>
                        <%--}--%>
                    },
                },
            });


           window.toolbar = E.createToolbar({
               editor: window.editor,
               selector: '#editor-toolbar',
               config: {
                   excludeKeys: ['group-video']
               },
               mode: 'default',
           });
        } catch (error) {
            console.error('编辑器初始化失败:', error);
        }
    });

    // 加载个人主页内容
    function loadPersonalHome() {
        fetch('${pageContext.request.contextPath}/getContents')
            .then(response => {
                if (!response.ok) throw new Error('网络响应不正常');
                return response.json();
            })
            .then(contents => {
                const container = document.getElementById('home-content');
                container.innerHTML = '';

                if (contents.error) { // 处理错误情况
                    container.innerHTML =
                        `<div class="alert alert-danger">` +contents.error+ `</div>`;
                    return;
                }

                if (contents.length === 0) {
                    container.innerHTML = `
                    <div class="empty-message">
                        <h4>您还没有任何心记</h4>
                        <p>点击"写心记"开始记录</p>
                    </div>`;
                    return;
                }

                contents.forEach(content => {
                    const card = createContentCard(content);
                    container.appendChild(card);
                });
            })
            .catch(error => {
                console.error('加载内容失败:', error);
                document.getElementById('home-content').innerHTML =
                    `<div class="alert alert-danger">
                    加载内容失败: `+error.message+
                `</div>`;
            });
    }

    // 创建内容卡片
    function createContentCard(content) {
        const card = document.createElement('div');
        card.className = 'card mb-3';
        card.dataset.id = content.id; // 存储内容ID

        // 卡片头部
        const cardHeader = document.createElement('div');
        cardHeader.className = 'card-header d-flex justify-content-between align-items-center';

        const time = document.createElement('span');
        time.textContent = formatDateTime(content.time);

        const badgeContainer = document.createElement('div');
        badgeContainer.className = 'd-flex align-items-center';
        const contentState=getStateText(content.state)
        const contentStyle = getStateStyle(content.state);
        // 状态下拉菜单
        const stateDropdown = document.createElement('div');
        stateDropdown.className = 'dropdown me-2';
        stateDropdown.innerHTML = `<button class="btn btn-sm ` +contentStyle+ ` dropdown-toggle" type="button" data-bs-toggle="dropdown">`
            +contentState+ `</button>`+
        `<ul class="dropdown-menu">
            <li><a class="dropdown-item" href="#" data-state="public">公开</a></li>
            <li><a class="dropdown-item" href="#" data-state="private">私密</a></li>
            <li><a class="dropdown-item" href="#" data-state="save">保存</a></li>
        </ul>`;
        stateDropdown.querySelectorAll('.dropdown-item').forEach(item => {
            item.addEventListener('click', () => {
                updateContentState(content.id, item.dataset.state);
            });
        });

        // 操作按钮
        const btnGroup = document.createElement('div');
        btnGroup.className = 'btn-group';

        // 草稿状态显示编辑按钮
        if (content.state === 'save') {
            const editBtn = document.createElement('button');
            editBtn.className = 'btn btn-sm btn-warning me-1';
            editBtn.innerHTML = '<i class="bi bi-feather"></i>';
            editBtn.addEventListener('click', () => {
                editContent(content.id, content.content);
            });
            btnGroup.appendChild(editBtn);
        }

        // 删除按钮
        const deleteBtn = document.createElement('button');
        deleteBtn.className = 'btn btn-sm btn-danger';
        deleteBtn.innerHTML = '<i class="bi bi-trash"></i>';
        deleteBtn.addEventListener('click', () => {
            deleteContent(content.id);
        });
        btnGroup.appendChild(deleteBtn);

        badgeContainer.appendChild(stateDropdown);
        badgeContainer.appendChild(btnGroup);

        cardHeader.appendChild(time);
        cardHeader.appendChild(badgeContainer);

        // 卡片主体
        // const cardBody = document.createElement('div');
        // cardBody.className = 'card-body';
        // cardBody.innerHTML = content.content;
        const cardBody = document.createElement('div');
        cardBody.className = 'card-body editor-container';
        cardBody.id = 'content-editor-' + content.id;

// 先用普通div展示内容，等DOM渲染后再初始化编辑器
//         const tempDiv = document.createElement('div');
//         tempDiv.innerHTML = content.content;
//         cardBody.appendChild(tempDiv);


// 延迟初始化编辑器，确保DOM已经渲染
            setTimeout(() => {
                try {
                    const E = window.wangEditor;
                    const contentEditor = E.createEditor({
                        selector: '#content-editor-' + content.id,
                        config: {
                            readOnly: true,
                            placeholder: '',
                            // html: {
                            //     style: true,
                            //     class: true,
                            //     parseFilterRules: () => true,
                            //     renderElmRules: () => true,
                            //     skipWhitelist: true,
                            //     ignoreWhitelist: true
                            // }
                        }
                    });
                    contentEditor.setHtml(content.content, { ignoreWhitelist: true });
                } catch (error) {
                    console.error('内容编辑器初始化失败:', error);
                    cardBody.innerHTML = content.content;
                }
            }, 10); // 使用短延迟，确保DOM已渲染

        card.appendChild(cardHeader);
        card.appendChild(cardBody);

        return card;
    }
    function formatDateTime(timestamp) {
        const date = new Date(timestamp);
        return date.toLocaleString('zh-CN', {
            year: 'numeric',
            month: '2-digit',
            day: '2-digit',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        });
    }

    function getStateText(state) {
        const states = {
            'public': '公开',
            'private': '私密',
            'save': '草稿',
            'block': '封禁'
        };
        return states[state] || '未知状态';
    }
    function getStateStyle(state) {
        const styles = {
            'public': 'btn-outline-success',
            'private': 'btn-outline-info',
            'save': 'btn-outline-secondary',
            'block': 'btn-outline-danger'
        };
        return styles[state] || 'btn-outline-secondary';
    }
    // 更新内容状态
    function updateContentState(contentId, newState) {
        fetch('${pageContext.request.contextPath}/updateState', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: contentId, state: newState })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    loadPersonalHome(); // 刷新内容
                } else {
                    alert('状态更新失败: ' + data.message);
                }
            })
            .catch(error => console.error('更新状态失败:', error));
    }

    // 编辑内容
    function editContent(contentId, contentHtml) {
        // 切换到编辑标签页
        document.getElementById('write-tab').click();

        // 重置跟踪的图片集合
        insertedImages.clear();
        currentContentId = contentId;

        // 设置编辑器内容
        if (window.editor) {
            window.editor.setHtml(contentHtml, { ignoreWhitelist: true });
            // window.editor.setHtml(contentHtml);
            // 设置当前编辑ID
            document.getElementById('editor-container').dataset.editingId = contentId;

            const initialImages = window.editor.getElemsByType('image');
            initialImages.forEach(img => {
                if (img.src) {
                    insertedImages.add(img.src);
                }
            });
        }
    }
    // 删除服务器文件
    function deleteFileOnServer(fileUrl) {
        fetch('${pageContext.request.contextPath}/deleteFile', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: 'fileUrl=' + encodeURIComponent(fileUrl)
        })
            .then(response => response.json())
            .then(data => {
                if (!data.success) {
                    console.error('文件删除失败:', data.message);
                }
            })
            .catch(error => console.error('删除请求失败:', error));
    }
    // 删除内容
    function deleteContent(contentId) {
        if (!confirm('确定要删除这条内容吗？')) return;

        // 获取内容卡片元素
        const card = document.querySelector(`.card[data-id="`+contentId+`"]`);
        if (!card) {
            console.error('找不到内容卡片');
            return;
        }
        // 获取内容HTML
        const contentHtml = card.querySelector('.card-body').innerHTML;

        fetch('${pageContext.request.contextPath}/deleteContent', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ id: contentId })
        })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    const imageUrls = Array.from(contentHtml.matchAll(/<img[^>]+src="([^"]+)"/g)).map(match => match[1]);
                    // 删除每张图片
                    imageUrls.forEach(url => {
                        deleteFileOnServer(url);
                    });

                    loadPersonalHome();
                    <%--document.querySelector(`.card[data-id="${contentId}"]`).remove();--%>
                } else {
                    alert('删除失败: ' + data.message);
                }
            })
            .catch(error => console.error('删除失败:', error));
    }

    // 修改提交表单函数
    function submitForm(state) {
        if (!window.editor) {
            console.error('编辑器尚未初始化完成');
            return;
        }

        const content = window.editor.getHtml();
        const contentId = currentContentId || document.getElementById('editor-container').dataset.editingId;

        // 获取当前内容中的所有图片
        const currentImages = new Set();
        const imageElems = window.editor.getElemsByType('image');
        imageElems.forEach(img => {
            if (img.src) {
                currentImages.add(img.src);
            }
        });

        // 找出未使用的图片（已删除的图片）
        const unusedImages = new Set([...insertedImages].filter(src => !currentImages.has(src)));

        // 删除未使用的图片
        unusedImages.forEach(src => {
            deleteFileOnServer(src);
        });

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

        // 添加编辑ID参数（如果存在）
        if (contentId) {
            const idInput = document.createElement('input');
            idInput.type = 'hidden';
            idInput.name = 'contentId';
            idInput.value = contentId;
            form.appendChild(idInput);
        }

        // 提交表单
        document.body.appendChild(form);
        form.submit();
        document.body.removeChild(form);

        // 重置状态
        insertedImages.clear();
        currentContentId = null;
    }
</script>
</body>
</html>