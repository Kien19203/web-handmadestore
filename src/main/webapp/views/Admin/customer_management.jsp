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
    <style>
        #showBox, #cancelBox {
            position: fixed;
            top: 40%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 1021;
            background-color: #afe2ea;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        .my-custom-scrollbar {
            position: relative;
            height: 60%;
            overflow: auto;
        }

        .table-wrapper-scroll-y {
            display: block;
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
        <table class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap">STT</th>
                <th class="text-nowrap">
                    <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=ascName"
                       class="btn-primary text-decoration-none">A-Z</a>
                    Họ Và Tên
                    <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=descName"
                       class="btn-primary text-decoration-none">Z-A</a>
                </th>
                <th class="text-nowrap">Số điện thoại</th>
                <th class="text-nowrap">Địa chỉ email</th>
                <th class="text-nowrap">
                    <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=ascCreatedDate"
                       class="btn-primary text-decoration-none">A-Z</a>
                    Ngày tạo tài khoản
                    <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management&filter=descCreatedDate"
                       class="btn-primary text-decoration-none">Z-A</a>
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
</div>

</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>