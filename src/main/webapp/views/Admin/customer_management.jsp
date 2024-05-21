<%@ page import="java.util.List" %>
<%@ page import="model.bean.User" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.service.RoleService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%List<User> users = (List<User>) request.getAttribute("users");%>
<% users = (users == null) ? UserService.getInstance().getAllUsers() : users;%>
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
            z-index: 1000;
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

        <div class="row input-group mb-3">
            <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=allCustomer"
               class="btn btn-outline-secondary col-12 mb-3" type="button">Tất cả</a>
            <input type="text" class="form-control col-lg-3 col-12 col-sm-12" placeholder="Tìm kiếm theo Tên hoặc Số điện thoại, Email khách hàng"
                   name="findCustomer"
                   <%String kw =(String) request.getAttribute("kw");%>
                   value="<%=(kw==null)?"":kw%>">
            <button
                    class="btn btn-outline-secondary col-lg-2" type="submit">Tìm kiếm khách hàng
            </button>
        </div>
    </form>
    <%--        table--%>
    <div class="table-wrapper-scroll-y my-custom-scrollbar">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap">STT</th>
                <th class="text-nowrap">
                    Họ Và Tên
                </th>
                <th class="text-nowrap">Số điện thoại</th>
                <th class="text-nowrap">Địa chỉ email</th>
                <th class="text-nowrap">
                    Ngày đăng ký
                </th>
                <th class="text-nowrap">
                    Trạng thái
                    <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=lockUsers"
                       class="btn-primary text-decoration-none"><i class="fa-solid fa-filter-circle-xmark"></i></a>
                </th>
                <th scope="col"><i class="fa-solid fa-user-pen fs-4"></i></th>
            </tr>
            </thead>
            <tbody>
            <%int stt = 0;%>
            <% for (User u : users) {%>
            <%stt++;%>
            <tr class="text-center">
                <td class="text-center"><%=stt%>
                </td>
                <td class="text-center"><%=u.getName()%>
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
                    <%if (!RoleService.getInstance().checkRole(u).equals("admin")) {%>
                    <%if (u.getStatus().trim().equalsIgnoreCase("Bình Thường")) {%>
                    <a title="Khóa tải khoản"
                       href="<%=request.getContextPath()%>/admin/customer?func=customer_management&user_id=<%=u.getId()%>&currentFilter=<%=currentFilter%>"><i
                            class="fa-solid fa-unlock fs-4"></i></a>
                    <%} else if (u.getStatus().trim().equalsIgnoreCase("Bị khóa")) {%>
                    <a title="Bỏ khóa tải khoản"
                       href="<%=request.getContextPath()%>/admin/customer?func=customer_management&user_id=<%=u.getId()%>&currentFilter=<%=currentFilter%>"><i
                            class="fa-solid fa-lock fs-4"></i></a>
                    <%}%>
                    <%}%>
                </td>
            </tr>
            <%}%>
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
            document.getElementById("currentPageNumber").value = pageInfo.page + 1;
        }
    });
</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>