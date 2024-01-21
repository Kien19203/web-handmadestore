<%@ page import="model.bean.User" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.bean.Cart" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<%User u = (User) session.getAttribute("auth");%>

<%Cart cart = (Cart) session.getAttribute("cart");
        if(cart == null) cart = new Cart();
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>

<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
<%--    <%@include file="menu.css" %>--%>
    <title>Menu</title>
</head>
<style>
    /*MenuBar*/
    .menu {
        background: rgba(250, 244, 244, 0.92);
        border-bottom: 1px solid rgba(155, 158, 162, 0.7);
    }

    .menu ul a {
        text-decoration: none;
        color: #797974;
    }

    .menu ul .item_a{
        padding: 25px 0;
    }

    .menu ul li {
        list-style-type: none;
    }

    .menu ul .sanpham .sub_menu {
        left: 0%;
        padding: 0;
        top: 100%;
        border: 1px;
        display: none;
    }

    .menu ul li.times {
        border-left: #8b8b8b solid 1px;
    }

    .menu ul li.item:hover {
        background: red;
    }

    .menu ul li.item:hover a {
        color: white;
    }

    .menu ul li.sanpham:hover .sub_menu {
        display: block;
    }

    .menu ul li.sanpham .sub_menu li a {
        color: #797974;
    }

    .menu ul li.sanpham .sub_menu li a:hover {
        color: white;
        background: red;
        font-size: 17px;
    }

    .menu ul li.search i {
        background: red;
        padding: 4%;
    }

    .menu ul li.search {
        border-left: 1px solid #8b8b8b;
    }

    .menu ul li.search input {
        padding-left: 10px;
        width: 85%;
        border: none;
        height: 100%;
    }

    .menu ul li.login a:hover {
        color: red;
    }

    .menu ul li.cart a:hover {
        color: red;
    }

    #dangxuat {
        padding: 0;
        display: none;
    }

    #dangxuat a:hover {
        background: red;
        color: white;
    }

    #dangxuat a {
        color: black;
        padding-right: 25%;
        padding-left: 25%;
    }

    .menu ul li.login:hover #dangxuat {
        display: block;
    }

    .menu ul li.item {
        text-align: center;
    }

    .search button {
        padding: 12px;
        border: none;
        background: red;
    }

    .fa-solid {
        font-size: 20px;

    }

    .fa-cart-shopping .badge {
        font-size: 10px;
    }

    #badge {
        transform: translate(50%,-50%);
    }

/*    phần giỏ hàng*/
    /*
Đây la noi css nè các ban
 */

    .cart .top-cart-content {
        display: none;
        position: absolute;
        position: fixed;
        top: 100;
        right: 20;
        /*transform: translate(10%,30%);*/
        box-shadow: 0 0 15px -5px rgba(0,0,0, 0.4);
        background-color:  rgba(255,255,255, 0.8);
        transition: all 0.3s ease;
    }


    .cart:hover .top-cart-content {
        display: block;
    }


    .cart .top-cart-content::before{
        background-color: #ffcc00;
        display: block;
        opacity: 0;
        min-width: 200px;
        transition: all 0.3s ease 0s;
        position: absolute;
        transform: translateY(0px);
        right: 0;
        left: auto;
        padding: 0;
        text-align: left;
        box-shadow: 0 0 15px -5px rgba(0,0,0, 0.4);
        visibility: hidden;
        z-index: 10000;
    }


    .cart .top-cart-content #cart-side-bar {
        max-height: 625px;
        min-width: 310px;
        width: 310px;
        position: relative;
        padding: 15px;

    }

    .cart .top-cart-content #cart-side-bar .list-item-cart {
        max-height: 260px;
        overflow: auto;
        padding: 0;

    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li.item-sub:first-child {

        padding-top: 10px;
        border-top: none;
    }
    .cart .top-cart-content #cart-side-bar .list-item-cart li.item-sub {
        padding: 12px 0px;
        overflow: hidden;
    }
    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list {
        overflow: hidden;
    }


    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list a.product-image {
        float: left;
        display: flex;
        width: 80px;
        align-items: start;
        justify-content: center;
        margin-right: 10px;
        margin-bottom: 5px;
    }
    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list a img {
        border: 0 none;
        max-width: 100%;
        height: auto;
        vertical-align: middle;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list .detail-item {
        width: calc(100% - 90px);
        float: left;
        display: block;
        word-break: break-word;
        position: relative;
    }

    .cart .top-cart-content #cart-side-bar .list-item-cart li .border_list .detail-item .product-detail {
        padding-right: 10px;
        overflow: hidden;

    }
    .top-cart-content .product-detail .product-name {
        margin: 0;
        line-height: 1;
        padding-right: 20px;
    }

    .top-cart-content .product-detail .product-name  a {
        font-size: 1em;
        line-height: 20px !important;
        font-weight: 400;
        color: #333;
        word-break: break-word;
    }

    .top-cart-content .product-detail-bottom {
        margin-bottom: 15px;
        line-height: 33px;
    }

    .top-cart-content .product-detail-bottom .price {
        color: #333;
        font-weight: 700;
        font-size: 16px;
        margin-right: 5px;
    }


    .top-cart-content .product-detail-bottom a .bi {
        position: absolute;
        right: 0;
        left: auto;
        top: 9px;
        transform: translateY(-50%);
        width: 18px;
        height: 18px;
        text-align: center;
        line-height: 18px;
        padding-left: 0;
        border-radius: 50%;
    }

    .top-cart-content .product-detail-bottom .quantity-select {
        display: flex;
        /*width: 18px;*/

    }

    .top-cart-content .product-detail-bottom .quantity-select button {
        display: inline-block;
        cursor: pointer;
        height: 24px;
        width: 24px;
        line-height: 1;
        text-align: center;
        overflow: hidden;
        border: 1px solid #ebebeb;
        border-style: hidden;
        /*background: none !important;*/
        font-size: 14px;
    }

    .top-cart-content .product-detail-bottom .quantity-select input {
        display: inline-block;
        width: 22px;
        height: 24px;
        min-height: 24px;
        padding: 0;
        text-align: center;
        margin: 0;
    }

    #cart-side-bar .pd .top-subtotal {
        font-size: 1em;
        font-weight: 400;
        padding: 15px 0 15px;
        border-bottom: 1px solid #ebebeb;
        margin-bottom: 15px;
        text-align: left;
        text-transform: none;

    }

    .top-subtotal .price {
        margin-right: 5px;
        font-size: 16px;
        font-weight: 500;
        float: right;

    }

    #cart-side-bar  .pda {
        text-align: center;
        margin-top: 10px;
        display: flex;
        justify-content: space-around;

    }

    #cart-side-bar  .pda a {
        padding: 0 20px;
        background-color: #ff0000;
        color : #fff;
        height: 40px;
        line-height: 40px;
        white-space: nowrap;
        text-align: center;
        border: none;
        border-radius: 0;
        letter-spacing: 0;

    }







</style>
<body>
<div id="menubar" class="menu sticky-top">
    <ul class="d-flex m-0 justify-content-around">

        <li class="logo me-4 my-auto">
            <img src="<%=request.getContextPath()%>/images/logo.png" style="width: 12vh">

        </li>
        <li class="item times p-4 my-auto">
            <a class="item_a" href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">Trang chủ</a>
        </li>
        <li class="item sanpham p-4 dropdown my-auto">

            <a class="item_a" href="<%=request.getContextPath()%>/product" class="title_sp">Sản phẩm
                <i class="fa-solid fa-caret-down"></i></a>

            <ul class="sub_menu dropdown-menu">
                <%List<Category> categories = CategoryService.getInstance().getALl();%>
                <%for (Category c : categories) {%>
                <li><a href="#<%=c.getId()%>" class="item dropdown-item"><%=c.getName()%>
                </a></li>
                <%}%>
            </ul>
        </li>
        <li class="item bikip p-4 my-auto">
            <a class="item_a" href="#bikip">Bí kíp làm đồ HandMade</a>
        </li>
        <li class="item footers p-4 my-auto">
            <a class="item_a" href="#footer ">Về chúng tôi</a>
        </li>

        <li class="search d-flex p-4 my-auto">
            <form action="<%=request.getContextPath()%>/findProduct" method="post" id="find" class="d-flex">
                <input name="findProducts" type="text" placeholder="Bạn tìm gì...">
                <button><i class="fa-solid fa-magnifying-glass" style="color: white;"></i></button>
            </form>
        </li>
        <li class="login p-4 my-auto dropdown">
            <%if (u == null) {%>
            <i class="fa-solid fa-user" style="color: #496088;"></i>

            <a class="item_a" href="<%=request.getContextPath()%>/login">Đăng Nhập</a>
            <%} else{%>


            <button type="button" class="btn btn-sm btn-primary "><i class="fa-solid fa-user" style="color: white;"></i>
                <span><%= u.getName()%></span></button>
            <ul id="dangxuat" class="dx dropdown-menu">

                <li><a class="dropdown-item" href=""><i class="fa-solid fa-user-pen"></i> Thay Đổi Thông Tin</a></li>
                <li><a class="dropdown-item" href="<%=request.getContextPath()%>/views/Login/view_login/login.jsp"><i class="fa-solid fa-right-from-bracket"></i> Đăng

                    Xuất</a></li>
            </ul>
            <%}%>
        </li>

        <li class="cart p-4 dropdown my-auto  position-relative">
            <%--            <i class="fa-solid fa-cart-shopping" style="color: #2a3241;"></i>--%>
            <%--            <a href="<%=request.getContextPath()%>/views/CartPage/cart.html">Giỏ Hàng</a>--%>
            <a href="<%=request.getContextPath()%>/add-cart?actionCart=get">

                <i class="fa-solid fa-cart-shopping position-relative" style="color: #2a3241;">
            <span id="badge" class="position-absolute top-0 start-0  badge rounded-pill
            bg-danger "><%=cart.getTotal()%> </span>

                </i>
                <span class="label ps-2"> Giỏ hàng </span>

            </a>


            <!--Danh sách giỏ hàng -->

                 <div class="top-cart-content ">
                 <ul id="cart-side-bar" class="mini-product-list">

                    <ul class="list-item-cart">
                        <% double total = 0;%>
                        <% for (Item item : cart.getItems().values()) { %>
                        <li class="item-sub">
                            <div class="border_list">
                                <%  String pathImage = ImageService.getInstance().pathImageOnly(item.getProduct().getId()); %>
                                <a class="product-image" href="">
                                    <img src="<%=request.getContextPath()%>/<%=pathImage%>" width="100" alt="">
                                </a>
                                <div class="detail-item">
                                    <div class="product-detail">
                                        <p class="product-name">
                                            <a href=""><%=item.getProduct().getName()%></a>
                                        </p>
                                    </div>
                                    <div class="product-detail-bottom">
                                        <span class="price"> <%=numberFormat.format(item.getPrice())%></span>
<%--                                        DELETE SẢN PHẨM--%>
<%--                                        <form action="<%=request.getContextPath()%>/add-cart" method="get" >--%>
<%--                                            <input type="hidden" name="id" value="<%=item.getProduct().getId()%>">--%>
<%--                                            <button type="submit" class="btn" name="actionCart" value="delete">--%>
<%--                                                <i class="bi bi-x-circle-fill"></i>--%>
<%--                                            </button>--%>

<%--                                        </form>--%>
                                        <a href="<%=request.getContextPath()%>/add-cart?actionCart=delete&id=<%=item.getProduct().getId()%>">
                                            <i class="bi bi-x-circle-fill"></i>
                                        </a>
                                        <div class="quantity-select">

                                            <button class="pd-des m-0">-</button>
                                            <input type="text" class="quantity-input p-0" value="<%=item.getQuantity()%>">
                                            <button class="pd-inc m-0">+</button>

                                        </div>
                                    </div>

                                </div>

                            </div>
                        </li>
                        <%total +=  (item.getQuantity() * item.getPrice()); %>
<%}%>

                    </ul>
                    <div class="pd">
                        <div class="top-subtotal">
                            Tổng tiền:
                            <span class="price"> <%=numberFormat.format(total)%></span>
                        </div>
                    </div>
                    <div class="pda rigth-ct">
                        <a href="" class="btn"><span>Giỏ hàng</span></a>
                        <a href="" class="btn"><span>Thanh Toán</span></a>
                    </div>
                </ul>

            </div>
            </a>



        </li>


    </ul>
</div>
</body>
</html>