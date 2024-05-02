<%@ page import="model.service.ImageService" %>
<%@ page import="model.bean.User" %>
<%@ page import="model.service.RoleService" %>
<%@ page import="model.service.OrderService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% String framePath = ((String) request.getAttribute("framePath") == null) ?
        request.getContextPath() + "/views/Admin/reference_statistics.jsp"
        : (request.getContextPath() + (String) request.getAttribute("framePath"));%>

<%User u = (User) session.getAttribute("auth");%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>ADMIN</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/main.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Inline+One&display=swap" rel="stylesheet">
    <style>
        li {
            list-style-type: none;
        }

        p, ul, li {
            margin: 0;
            padding: 0;
        }

        nav ul.menu {
            overflow: auto;
        }

        nav ul.menu li.item {
            float: left;
            padding: 20px 10px;
            cursor: pointer;
            font-size: 20px;
        }

        nav ul.menu li.item ul.sub_menu {
            position: absolute;
            overflow: auto;
            display: none;
            right: 0;
        }

        nav ul.menu li.item:hover ul.sub_menu {
            width: auto;
            display: block;
            border-radius: 3px;
            margin-top: 10px;
        }

        nav ul.menu li.item ul.sub_menu li {
            display: block;
            background-color: #afe2ea;
            padding: 5px 10px;
        }

        nav ul.menu li.item ul.sub_menu li a {
            color: white;
            text-decoration: none;
        }

        nav ul.menu li.item ul.sub_menu li a:hover {
            color: black;
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="navigation content-to-embed">
    <ul class="ps-0 ">
        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/admin?func=reference_statistics" target="content"
               class="nav-link myfunccolor"
               onclick="choiceMainFunc(1)" id="1">
                <span class="icon"><i class="bi bi-house-door"></i></span>
                <span class="title">Thống kê tham khảo</span>
            </a>
        </li>
        <li class="nav-item ">
            <a href="<%=request.getContextPath()%>/admin/product?func=product_management"
               target="content"
               class="myfunccolor"
               onclick="choiceMainFunc(2)" id="2">
                <span class="icon"><i class="bi bi-shop"></i></span>
                <span class="title">Quản lý sản phẩm</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/admin?func=order_management"
               target="content" class="myfunccolor"
               onclick="choiceMainFunc(3)" id="3"
               style="display: block">
                <div class="d-flex">
                    <span class="icon"><i class="bi bi-minecart"></i></span>
                    <span class="title">Quản lý đơn hàng</span>
                </div>
                <%--                new order--%>
                <%if (OrderService.getInstance().waitConfirmOrdersNumber() > 0) {%>
                <div style="color:red; font-size:small; text-align: center">
                    <i class="fa-solid fa-circle-exclamation"></i>
                    (<%=OrderService.getInstance().waitConfirmOrdersNumber()%>) đơn hàng mới cần xác nhận
                </div>
                <%}%>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/admin/customer?func=customer_management"
               target="content" class="nav-link myfunccolor"
               onclick="choiceMainFunc(4)" id="4">
                <span class="icon"><i class="fa-regular fa-address-book"></i></span>
                <span class="title">Quản lý khách hàng </span>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/admin?func=banners_tips"
               target="content" class="nav-link myfunccolor"
               onclick="choiceMainFunc(5)" id="5">
                <span class="icon"><i class="fa-brands fa-gratipay"></i></span>
                <span class="title">Thay đổi banners, tips</span>
            </a>
        </li>
        <li class="nav-item">
            <a href="<%=request.getContextPath()%>/admin?func=support"
               target="content" class="nav-link myfunccolor"
               onclick="choiceMainFunc(6)" id="6">
                <span class="icon"><i class="fa-solid fa-circle-info"></i></span>
                <span class="title">Hỗ trợ</span>
            </a>
        </li>
    </ul>
</div>
<div class="header sticky-top ">
    <div class="top-bar">
        <div class="branch-tit">
            <a href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp" target="_blank">
                <img src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" alt="" class="me-2">
                <span class="title">HEADQUARTERS</span>
            </a>
        </div>
        <section>
            <nav>
                <ul class="menu">
                    <li class="item">
                        <span style="color: white"><%= u.getName()%></span>
                        <i class="fa-solid fa-user" style="color: white; margin: 0 5px"></i>
                        <ul class="sub_menu border border-primary">
                            <li><a href="<%=request.getContextPath()%>/login">
                                <i class="fa-solid fa-right-from-bracket me-2"></i>Đăng xuất</a></li>
                            <li><a href="<%=request.getContextPath()%>/changeUserInfo">
                                <i class="fa-solid fa-user-pen me-2"></i>Thông tin tài khoản</a></li>
                        </ul>
                    </li>
                </ul>
            </nav>
        </section>
    </div>
</div>

<div class="main">
    <iframe src="<%=framePath%>" frameborder="0" name="content" class="content" id="frame" width="100%" height="1100px"
            scrolling="no"></iframe>
</div>
<script>
    function choiceMainFunc(funcNumber) {
        // Lấy tất cả các phần tử có class "nav-link"
        var elements = document.getElementsByClassName("myfunccolor");

        for (var i = 0; i < elements.length; i++) {
            elements[i].style.backgroundColor = "#afe2ea";
        }

        var e = document.getElementById(funcNumber);
        e.style.backgroundColor = "#FFB6C1";
    }

</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>