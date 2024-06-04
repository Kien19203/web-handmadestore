<%@ page import="java.util.List" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.service.RoleService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<User> users = (List<User>) request.getAttribute("users");%>
<%User user = (User) session.getAttribute("auth");%>
<% users = (users == null && user != null) ? UserService.getInstance().getAllUsers(user.getId() + "") : users;%>
<%
    String currentFilter = (String) request.getAttribute("currentFilter");
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý khách hàng</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <style>
        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 20%;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9;
        }

        .dt-empty, .dt-info {
            display: none;
        }

        #add_user {
            position: fixed;
            top: 40%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 9999;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2 ps-4">
    <%--        Find--%>
    <form action="<%=request.getContextPath()%>/admin/customer">
        <input type="text" name="func" value="customer_management" style="display: none"></p>
        <input type="text" name="filter" value="findCustomer" style="display: none"></p>

        <div class="row input-group mb-3 justify-content-center">
            <div class="d-flex justify-content-center">
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=allCustomer"
                   class="btn btn-outline-secondary" type="button">Tất cả</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=owner"
                   class="btn btn-outline-secondary" type="button">Chủ hệ thống</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=admin"
                   class="btn btn-outline-secondary" type="button">Quản lý</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=user"
                   class="btn btn-outline-secondary" type="button">Người dùng</a>
                <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=lockUsers"
                   class="btn btn-outline-secondary" type="button">Người dùng đã khóa</a>
            </div>
            <input type="text" class="form-control col-lg-6 col-12 col-sm-12"
                   placeholder="Tìm kiếm theo Tên hoặc Số điện thoại, Email khách hàng"
                   name="findCustomer"
                <%String kw =(String) request.getAttribute("kw");%>
                   value="<%=(kw==null)?"":kw%>">
            <button
                    class="btn btn-outline-secondary col-lg-2" type="submit">Tìm kiếm khách hàng
            </button>
            <%if (user.isOwn()) {%>
            <button
                    class="btn btn-outline-secondary col-lg-2" type="button" onclick="showAddUserBox()">Thêm tài khoản
            </button>
            <div id="add_user" class="w-50 bg-secondary p-3 rounded" style="display: none">
                <div class="form-group">
                    <label for="name">Tên</label>
                    <input type="text" class="form-control" id="name" name="name" required>
                </div>
                <div class="form-group">
                    <label for="phoneNumber">Số điện thoại</label>
                    <input type="text" class="form-control" id="phoneNumber" name="phoneNumber" required>
                </div>
                <div class="form-group">
                    <label for="email">Email</label>
                    <input type="email" class="form-control" id="email" name="email" required>
                </div>
                <div class="form-group">
                    <label for="password">Mật khẩu</label>
                    <input type="password" class="form-control" id="password" name="password" required>
                </div>
                <div class="form-group">
                    <label for="role">Role</label>
                    <select class="form-control" id="role" name="roleId">
                        <option value="1">Quản lý</option>
                        <option value="0">Chủ hệ thống</option>
                    </select>
                </div>
                <button type="button" class="btn btn-primary" onclick="addUser()">Thêm User</button>
                <button
                        class="btn btn-dark" type="button" onclick="hideAddUserBox()">Thoát
                </button>
            </div>
            <%}%>
        </div>
    </form>
    <%--        table--%>
    <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap">STT</th>
                <th class="text-nowrap">
                    Họ Và Tên
                </th>
                <th class="text-nowrap">Quyền hạn</th>
                <th class="text-nowrap">Số điện thoại</th>
                <th class="text-nowrap">Địa chỉ email</th>
                <th class="text-nowrap">
                    Ngày đăng ký
                </th>
                <th class="text-nowrap">
                    Trạng thái
                </th>
                <th scope="col"><i class="fa-solid fa-user-pen fs-4"></i></th>
            </tr>
            </thead>
            <tbody>
            <%int stt = 0;%>
            <% for (User u : users) {
                stt++;
            %>
            <tr class="text-center"
                    <%
                        if (user.getId() == u.getId()) {
                    %>
                style="font-weight: bold"
                    <%}%>
            >
                <td class="text-center"><%=stt%>
                </td>
                <td class="text-center"><%=u.getName()%>
                </td>
                <td class="text-center"><%=u.nameAsRole()%>
                </td>
                <td class="text-center"><%=u.getPhoneNumber()%>
                </td>
                <td class="text-center"><%=u.getEmail()%>
                </td>
                <td class="text-center"><%=u.getCreateDate()%>
                </td>
                <td class="text-center"><%=u.getStatus()%>
                </td>
                <td class="text-center">
                    <%if (user.isOwn() && !u.isOwn()) {%>
                    <%if (!u.isLock()) {%>
                    <i title="Khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-unlock fs-4"></i>
                    <%} else {%>
                    <i title="Bỏ khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-lock fs-4 text-danger"></i>
                    <%}%>
                    <%} else if (user.isAdmin() && u.isUser()) {%>
                    <%if (!u.isLock()) {%>
                    <i title="Khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-unlock fs-4"></i>
                    <%} else {%>
                    <i title="Bỏ khóa tải khoản" onclick="toggleLock(<%=u.getId()%>,this)"
                       class="fa-solid fa-lock fs-4 text-danger"></i>
                    <%}%>
                    <%}%>
                </td>
            </tr>
            <%
                }
            %>
            </tbody>
        </table>
    </div>
    <input type="hidden" id="currentPageNumber" name="currentPageNumber"
           value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
</div>
<script>
    $(document).ready(function () {
        var table = $('#data').DataTable({
            "searching": false, // Không có tính năng tìm kiếm
            "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
            "pageLength": 10,
            "displayStart": document.getElementById("currentPageNumber").value
        });

        function getCurrentPage() {
            let pageInfo = table.page.info();
            document.getElementById("currentPageNumber").value = pageInfo.page;
        }
    });

    function toggleLock(userId, element) {
        // Gọi hàm lockOrUnLock với userId
        lockOrUnLock(userId);

        // Kiểm tra trạng thái hiện tại của biểu tượng
        if (element.classList.contains('fa-unlock')) {
            // Nếu hiện tại là mở khóa, đổi sang khóa
            element.classList.remove('fa-unlock');
            element.classList.add('fa-lock');
            element.classList.add('text-danger');
            element.parentElement.setAttribute('title', 'Bỏ khóa tải khoản');

        } else {
            // Nếu hiện tại là khóa, đổi sang mở khóa
            element.classList.remove('fa-lock');
            element.classList.add('fa-unlock');
            element.classList.remove('text-danger');
            element.parentElement.setAttribute('title', 'Khóa tải khoản');
        }
    }

    function lockOrUnLock(userId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/user-ajax-handle",
            data: {
                action: "lockOrUnLock",
                userId: userId
            },
            success: function (response) {

            },
            error: function () {
                alert("error")
            }
        })
    }

    <%if(user.isOwn()){%>

    function showAddUserBox() {
        document.getElementById("add_user").style.display = "block";
    }

    function hideAddUserBox() {
        document.getElementById("add_user").style.display = "none";
    }
    function addUser() {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/user-ajax-handle",
            data: {
                action: "addUser",
                name: document.getElementById("name").value,
                phoneNumber: document.getElementById("phoneNumber").value,
                email: document.getElementById("email").value,
                password: document.getElementById("password").value,
                roleId: document.getElementById("roleId").value
            },
            success: function (response) {
                alert(response)
            },
            error: function () {
                alert("error")
            }
        })
    }

    <%}%>
</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>