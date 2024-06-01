<%@ page import="java.util.List" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.dao.CategoryDAO" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.bean.*" %>

<%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 12/7/2023
  Time: 3:26 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="<%=request.getContextPath()%>/views/ProductList/productList.css" type="text/css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/views/bootstrap-css/bootstrap.min.css">
    <title>Cửa Hàng Handmade</title>
</head>
<% String filter = request.getAttribute("filter") == null ? "" : (String) request.getAttribute("filter");
    if (filter.equals("ascPrice")) filter = "Giá tăng dần";
    else if (filter.equals("descPrice")) filter = "Giá giảm dần";
    else filter = "Mặc định";
%>
<%List<Category> nameCategory = CategoryDAO.getAll();%>
<body>
<div class="sticky-top">
    <%@include file="../MenuBar/menu.jsp" %>
</div>
<%--Thẻ chua caegory--%>
<%----%>
<div class="content d-flex flex-row p-3">
    <div class="category col-3">
        <div class="title fw-bold fs-5">
            <p>Danh Mục</p>
        </div>
        <ul class="category_list text-center">
<%--            Sản phẩm khuyến mãi sẽ hiện nếu có sản phẩm--%>
            <%List<Product> productDiscount = ProductService.getInstance().listProductDiscount();%>
            <%if(!productDiscount.isEmpty()){%>
            <li id="khuyenmai" class="item_category py-2">
                <a id="akhuyenmai"
                   href="<%=request.getContextPath()%>/product?category=khuyenmai">Sản Phẩm Khuyến Mãi
                    <i class="fa-solid fa-caret-down"></i></a>
            </li>
            <%}%>
            <%for (Category c : nameCategory) { %>
            <li id="<%=c.getId()%>" class="item_category py-2">
                <a id="a<%=c.getId()%>"
                   href="<%=request.getContextPath()%>/product?category=<%=c.getId()%>"><%=c.getName()%>
                    <i class="fa-solid fa-caret-down"></i></a>
            </li>
            <%}%>
        </ul>
    </div>
    <%-- Phần chính trong danh sách sản phẩm (Sắp xếp, hiêển thị, số trang, chuyển tiếp ,...v..v)   --%>
    <div class="productList">

        <%--Hiển thị theo việc sắp xếp. --%>
<%--        <div class="sort ms-5 d-flex">--%>
<%--            <div id="categorySort" style="display: none"><%=request.getParameter("category")%></div>--%>
<%--            <span>Sắp xếp: </span>--%>
<%--            <select id="sort_price" style="text-align: center">--%>
<%--                <option value="">Mặc Định</option>--%>
<%--                <option value="descPrice">Giá Giảm Dần</option>--%>
<%--                <option value="ascPrice">Giá Tăng Dần</option>--%>
<%--            </select>--%>
<%--        </div>--%>
            <%--Hiển thị theo việc sắp xếp. --%>
            <div class="sort ms-5 d-flex">
                <span>Sắp xếp: </span>
                <ul class="menu_sort">
                    <li class="list_sort dropdown">
                        <span id="sortTitle"><%=filter%></span>
                        <ul class="sort_submenu list-group dropdown-menu">
                            <%
                                String category = request.getParameter("category");
                                if (category == null) {
                            %>
                            <li><a class="sort_item dropdown-item" href="<%=request.getContextPath()%>/product">Mặc định</a>
                            </li>
                            <li><a class="sort_item dropdown-item" href="?filter=descPrice">Giá giảm dần</a></li>
                            <li><a class="sort_item dropdown-item" href="?filter=ascPrice">Giá tăng dần</a></li>
                            <%} else {%>
                            <li><a class="sort_item dropdown-item" href="?category=<%=category%>">Mặc định</a></li>
                            <li><a class="sort_item dropdown-item" href="?category=<%=category%>&filter=descPrice">Giá giảm
                                dần</a></li>
                            <li><a class="sort_item dropdown-item" href="?category=<%=category%>&filter=ascPrice">Giá tăng
                                dần</a></li>
                            <%}%>

                        </ul>
                    </li>
                </ul>
            </div>
        <%-- Hiển thị sản phẩm theo category.   --%>
        <ul id="allProduct" class="products m-2 me-5 ms-3 d-flex flex-wrap">
            <%  List<Product> allProduct = (List<Product>) request.getAttribute("productInPage");%>
            <%
                if (allProduct == null) allProduct = new ArrayList<>();
            %>
            <%if (allProduct == null) {%>
            <p>Không có dữ liệu</p>
            <%} else {%>
            <%for (Product p : allProduct) {%>
            <%String pathImage = ImageService.getInstance().pathImageOnly(p.getId());%>
            <li id="product_list" class="product_li">
                <div class="item_product  me-4">
                    <a class="image" href="product-detail?id=<%=p.getId()%>">
                        <img src="<%=request.getContextPath()%>/<%=pathImage%>">
                    </a>
                    <a href="product-detail?id=<%=p.getId()%>"><p class="pt-4 px-3"><%=p.getName() %>
                    </p></a>
                    <%!double giaBanSauCung;%>
                    <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(p);%>

                    <%if(p.getCategoryId() >= 0 && giaBanSauCung!= p.getSellingPrice()){%>
                    <del><%=numberFormat.format(p.getSellingPrice())%></del>
                    <%}%>
                    <p><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(p))%></p>
<%--                    <div class="add-to-cart"><a href="<%=request.getContextPath()%>/add-cart?actionCart=post&num=1&id=<%=p.getId()%>"><span>Thêm vào giỏ hàng</span> </a></div>--%>
                    <div class="add-to-cart"><button onclick="addcart(this,<%=p.getId()%>)"><span>Thêm vào giỏ hàng</span> </button></div>

                </div>
            </li>

            <%}%>
            <%}%>
        </ul>
        <%--    Số Trang--%>
        <div class="pagination mx-5" style="padding: 0 40%;">
            <%int currentPage = (int) request.getAttribute("currentPage");%>
            <%int totalPage = (int) request.getAttribute("totalPage");%>
            <%
                if (currentPage > 1) {
                    String filters = request.getParameter("filter");
                    String categorys = request.getParameter("category");
                    if (filters == null) {
                        if (categorys == null) {
            %>
            <a class="fs-5" href="./product?page=<%=(currentPage - 1)%>">Trước</a>
            <%} else {%>
            <a class="fs-5" href="./product?category=<%=categorys%>&page=<%=(currentPage - 1)%>">Trước</a>
            <%
                }
            } else {
                if (categorys == null) {
            %>
            <a class="fs-5" href="./product?filter=<%=filters%>&page=<%=(currentPage - 1)%>">Trước</a>
            <%} else {%>
            <a class="fs-5" href="./product?category=<%=categorys%>&filter=<%=filters%>&page=<%=(currentPage - 1)%>">Trước</a>
            <%}%>
            <%}%>
            <%}%>
            <% for (int i = 1; i <= totalPage; i++) {
                if (i == currentPage) { %>
            <strong class="fs-5"><%=i%>
            </strong>
            <%
            } else {
                String filters = request.getParameter("filter");
                String categorys = request.getParameter("category");
                if (filters == null) {
                    if (categorys == null) {
            %>
            <a class="fs-5" href="./product?page=<%=i%>"><%=i%>
                    <%}else{%>
                <a class="fs-5" href="./product?category=<%=categorys%>&page=<%=i%>"><%=i%>
                </a>
                    <%}%>
                    <%} else {
                    if(categorys == null){
            %>
                <a class="fs-5" href="./product?filter=<%=filters%>&page=<%=i%>"><%=i%>
                </a>
                    <%}else{%>
                <a class="fs-5" href="./product?category=<%=categorys%>&filter=<%=filters%>&page=<%=i%>"><%=i%>
                </a>
                    <%}%>
                    <%}%>
                    <%}%>
                    <%}%>
                    <%
                if (currentPage < totalPage) {
                    String filters = request.getParameter("filter");
                    String categorys = request.getParameter("category");
                    if (filters == null) {
                        if(categorys == null){
            %>
                <a class="fs-5" href="./product?page=<%=(currentPage + 1)%>"> Tiếp</a>
                    <%}else{%>
                <a class="fs-5" href="./product?category=<%=categorys%>&page=<%=(currentPage + 1)%>"> Tiếp</a>
                    <%}%>
                    <%} else {
                        if(categorys == null){
            %>
                <a class="fs-5" href="./product?filter=<%=filters%>&page=<%=(currentPage + 1)%>"> Tiếp</a>
                    <%}else{%>
                <a class="fs-5"
                   href="./product?category=<%=categorys%>&filter=<%=filters%>&page=<%=(currentPage + 1)%>"> Tiếp</a>
                    <%}%>
                    <%}%>
                    <%}%>

        </div>
    </div>
    </div>
<%--footer--%>
<div class="footer">
    <%@include file="./../Footer/footer.jsp" %>
</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    let urlParagram = new URLSearchParams(window.location.search);
    let categoryParam = urlParagram.get('category');
    let categorykm = document.getElementById("khuyenmai");
    let acategorykm = document.getElementById("akhuyenmai");
    if (categoryParam == "khuyenmai") {
        categorykm.style.background = 'red';
        acategorykm.style.color = 'white';
    }
    <%for (Category category1 : nameCategory){%>
    let category<%=category1.getId()%> = document.getElementById("<%=category1.getId()%>");
    let acategory<%=category1.getId()%> = document.getElementById("a<%=category1.getId()%>");
    if (categoryParam == <%=category1.getId()%>) {
        category<%=category1.getId()%>.style.background = 'red';
        acategory<%=category1.getId()%>.style.color = 'white';
    }
    <%}%>

<%--    Add sản phẩm vào giỏ hàng--%>
    function addcart(btn,idProduct){
        let actionCart = "post";
        let num = 1;
        $.ajax({
            url: "/HandMadeStore/add-cart",
            method: "GET",
            data:{
                id: idProduct,
                actionCart: actionCart,
                num: num
            },
            success:function(response){
                console.log("thanh cong");
                handleAddToCart(response);
                Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "Thêm Sản Phẩm Vào Giỏ Hàng Thành Công!",
                    showConfirmButton: false,
                    timer: 1500
                });
            }
        })
    }

    // $(document).ready(function () {
    //     console.log(categoryParam);
    //     $("$categorySort").change(function () {
    //         let option = $(this).val();
    //         let loadfile = "true";
    //         $.ajax({
    //             url: "/HandMadeStore/productList",
    //             type: "POST",
    //             data: {
    //                 filter: option,
    //                 category: categoryParam,
    //                 loadfile : loadfile,
    //             },
    //             success: function (response) {
    //                 console.log(response);
    //                 for(var Product of response ){
    //                     renderProduct(Product);
    //                 }
    //             }
    //         })
    //     })
    // });
    // function renderProduct(products) {
    //     let template = $("#allProduct").html();
    // }



</script>
</html>
