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
    <link href='https://unpkg.com/boxicons@2.1.4/css/boxicons.min.css' rel='stylesheet'>
    <link href="<%=request.getContextPath()%>/views/ProductList/productList.css" type="text/css" rel="stylesheet">
    <link href="<%=request.getContextPath()%>/views/bootstrap-css/bootstrap.min.css">
    <title>Cửa Hàng Handmade</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->

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
<div class="content d-flex flex-row p-3">
    <div class="content_left col-2">
        <div class="category">
           <div class="title fw-bold fs-6 py-2" id="categoryMenu" style="cursor: pointer">
               <p class="my-0"><i class="fa-solid fa-list"></i> Danh Mục Sản Phẩm</p>
           </div>
           <ul class="category_list m-0" id="categoryList" >
               <%--            Sản phẩm khuyến mãi sẽ hiện nếu có sản phẩm--%>
               <%List<Product> productDiscount = ProductService.getInstance().listProductDiscount();%>
               <%if(!productDiscount.isEmpty()){%>
               <li class="fw-bold py-2" id="khuyenmai" >
                   <a id="akhuyenmai"
                      href="<%=request.getContextPath()%>/product?category=khuyenmai">Sản Phẩm Khuyến Mãi
                   </a>
               </li>
               <%}%>
               <%for (Category c : nameCategory) { %>
               <li id="<%=c.getId()%>" class="item_category py-2">
                   <a class="fw-bold" id="a<%=c.getId()%>"
                      href="<%=request.getContextPath()%>/product?category=<%=c.getId()%>"><%=c.getName()%>
                   </a>
               </li>
               <%}%>
           </ul>
        </div>
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
        <div class="sort">
            <div id="sortdiv" class="sort_title fw-bold fs-6 py-2" style="cursor: pointer"><p class="my-0"><i class="fa-solid fa-list"></i> Sắp Xếp Theo Giá</p></div>
            <ul id="menuSort" class="menu_sort m-0 p-0">
                        <%
                            String category = request.getParameter("category");
                            if (category == null) {
                        %>
                        <li id="sort_md" class="sort_itemli py-2"><a class="sort_item text-decoration-none fw-bold" href="<%=request.getContextPath()%>/product">Mặc định</a>
                        </li>
                        <li id="sort_desc" class="sort_itemli py-2"><a class="sort_item text-decoration-none fw-bold" href="?filter=descPrice">Giá giảm dần</a></li>
                        <li id="sort_asc" class="sort_itemli py-2"><a class="sort_item text-decoration-none fw-bold" href="?filter=ascPrice">Giá tăng dần</a></li>
                        <%} else {%>
                        <li id="sort_md" class="sort_itemli py-2"><a id="asort_md" class="sort_item text-decoration-none fw-bold" href="?category=<%=category%>">Mặc định</a></li>
                        <li id="sort_desc" class="sort_itemli py-2"><a id="asort_desc" class="sort_item text-decoration-none fw-bold" href="?category=<%=category%>&filter=descPrice">Giá giảm
                            dần</a></li>
                        <li id="sort_asc" class="sort_itemli py-2"><a id="asort_asc" class="sort_item text-decoration-none fw-bold" href="?category=<%=category%>&filter=ascPrice">Giá tăng
                            dần</a></li>
                        <%}%>
            </ul>
        </div>
    </div>
    <%-- Phần chính trong danh sách sản phẩm (Sắp xếp, hiêển thị, số trang, chuyển tiếp ,...v..v)   --%>
    <div class="productList" style="width: 98%">
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
                    <a href="product-detail?id=<%=p.getId()%>"><p class="pt-2 px-4 fw-bold"><%=p.getName() %>
                    </p></a>
                    <%!double giaBanSauCung;%>
                    <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(p);%>
                    <%if(p.getCategoryId() >= 0 && giaBanSauCung!= p.getSellingPrice()){%>
                    <%! int discountProduct;%>
                    <% discountProduct = ProductService.getInstance().discountProduct(p.getId());%>
                    <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProduct%>%</div>
                    <del ><p class="mt-2" style=" margin-bottom: 0"><%=numberFormat.format(p.getSellingPrice())%></p></del>
                    <p class="fw-bold text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(p))%></p>
                    <%}else{%>
                    <p class="fw-bold mt-2 text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(p))%></p>
                    <%}%>
                    <div class="add-to-cart" ><button onclick="addcart(this,<%=p.getId()%>)"><span class="fw-bold">Thêm vào giỏ <i class="fa-solid fa-cart-shopping"></i></span> </button></div>
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
<%--    category--%>
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
<%--sort--%>
let urlParagrams = new URLSearchParams(window.location.search);
let sortParam = urlParagrams.get('filter');
let desc = document.getElementById("sort_desc");
let asc = document.getElementById("sort_asc");
let md = document.getElementById("sort_md");
let adesc = document.getElementById("asort_desc");
let aasc = document.getElementById("asort_asc");
let amd = document.getElementById("asort_md");
    if(sortParam == "descPrice"){
        desc.style.background = "red";
        adesc.style.color = "white";
        md.style.background = "white";
        amd.style.color = "blue"
        asc.style.background = "white";
        aasc.style.color = "blue"
    }else if(sortParam == "ascPrice"){
        asc.style.background = "red";
        aasc.style.color = "white";
        md.style.background = "white";
        amd.style.color = "blue"
        desc.style.background = "white";
        adesc.style.color = "blue"
    }else{
        md.style.background = "red";
        amd.style.color = "white";
        asc.style.background = "white";
        aasc.style.color = "blue"
        desc.style.background = "white";
        adesc.style.color = "blue"
    }

<%--    Hiện category List--%>
    let categoryMenu = document.getElementById("categoryMenu");
    let categoryList = document.getElementById("categoryList");
    let clickCategory = 0;
    categoryMenu.addEventListener("click", function (){
        clickCategory += 1;
        if(clickCategory % 2 != 0){
            categoryList.style.display = "block";
        }else {
            categoryList.style.display = "none";
        }
    })
// Hiện sort
    let sortdiv = document.getElementById("sortdiv");
    let menuSort = document.getElementById("menuSort");
    let clicksort = 0;
    sortdiv.addEventListener("click", function (){
        clicksort += 1;
        if(clicksort % 2 != 0){
            menuSort.style.display = "block";
        }else {
            menuSort.style.display = "none";
        }
    })


    <%--    Add sản phẩm vào giỏ hàng--%>
    let idProductList = [];
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
                if(response != null && response == 'false') {
                    Swal.fire({
                        position: "center",
                        icon: "error",
                        title: "Vui lòng đăng nhập",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }else {
                    if(!idProductList.includes(idProduct)){
                        idProductList.push(idProduct);
                        handleAddToCart(response);
                    }
                    Swal.fire({
                        position: "center",
                        icon: "success",
                        title: "Thêm Sản Phẩm Vào Giỏ Hàng Thành Công!",
                        showConfirmButton: false,
                        timer: 1500
                    });
                }
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
