<%@ page import="java.util.List" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.dao.ProductDAO" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.dao.TipDAO" %>
<%@ page import="model.bean.*" %>
<%@ page import="java.util.ArrayList" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/MainPage/css/mainpage.css"/>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Cửa Hàng HandMade</title>
</head>
<body>
<!--menu-->

<%--Thanh điều hướng - header--%>
<%@include file="/views/MenuBar/menu.jsp" %>


<!--carousel-->
<div id="carouselExampleCaptions" class="carousel slide">
    <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="0" class="active"
                aria-current="true" aria-label="Slide 1"></button>
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="1"
                aria-label="Slide 2"></button>
        <button type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide-to="2"
                aria-label="Slide 3"></button>
    </div>
    <div class="carousel-inner">
        <div class="carousel-item active">
            <img src="https://images.pexels.com/photos/1303081/pexels-photo-1303081.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                 class="d-block w-100" alt="...">
            <div class="carousel-caption d-none d-md-block">
                <h5 class=""> KÍNH CHÀO QUÝ KHÁCH!</h5>
                <p>Mỗi sản phẩm handmade là một phần trái tim của ai đó.</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://images.pexels.com/photos/157888/fashion-glasses-go-pro-female-157888.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                 class="d-block w-100" alt="...">
            <div class="carousel-caption d-none d-md-block">
                <h5>ĐỘC - ĐẸP - BỀN - GIÁ PHÙ HỢP</h5>
                <p>Chế tạo những sản phẩm độc đáo, với tình yêu và sự tận tụy</p>
            </div>
        </div>
        <div class="carousel-item">
            <img src="https://images.pexels.com/photos/1424464/pexels-photo-1424464.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"
                 class="d-block w-100" alt="...">
            <div class="carousel-caption d-none d-md-block">
                <h5>CÙNG NHAU KHÁM PHÁ NÀO!</h5>
                <p>Những sản phẩm đang nóng lòng đợi bạn rinh về nè !</p>
            </div>
        </div>
    </div>
    <button class="carousel-control-prev" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="prev">
        <span class="carousel-control-prev-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Previous</span>
    </button>
    <button class="carousel-control-next" type="button" data-bs-target="#carouselExampleCaptions" data-bs-slide="next">
        <span class="carousel-control-next-icon" aria-hidden="true"></span>
        <span class="visually-hidden">Next</span>
    </button>
</div>
<!--hoạt động carousel-->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
        integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
        crossorigin="anonymous"></script>

<!--SanPham-->

<div class="product">
<%--    --%>
   <%List<Product> listProductDiscount = ProductService.getInstance().productDiscountMainPage();%>
    <%if(!listProductDiscount.isEmpty()){%>
    <div class="title_t" id="khuyenmai">
        <p class="text-center fs-5 fw-bold">Sản Phẩm Khuyến Mãi
        </p>
    </div>
    <div class="solid_t mb-3 m-auto"></div>
    <div class="sp" id="sp_khuyenmai">
        <ul class="products  m-2 d-flex flex-wrap">
            <%
                for (Product prd : listProductDiscount) {
            %>
            <%String pathImage = ImageService.getInstance().pathImageOnly(prd.getId());%>
            <li class="product_list">
                <div class="item_product  me-4">
                    <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=prd.getId()%>"> <img  src="<%=request.getContextPath()%>/<%=pathImage%>"> </a>
                    <a href="#"><p class="pt-4 px-3"><%=prd.getName() %>
                    </p></a>
                    <%!double giaKhuyenMai;%>
                    <% giaKhuyenMai = ProductService.getInstance().productPriceIncludeDiscount(prd);%>
                    <%if (prd.getCategoryId() >= 0 && giaKhuyenMai != prd.getSellingPrice()) {%>
                    <del><%=numberFormat.format(prd.getSellingPrice())%></del>
                    <%}%>
                    <p><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(prd))%></p>
                    <div class="add-to-cart"><a href="<%=request.getContextPath()%>/add-cart?actionCart=post&id=<%=prd.getId()%>"><span>Thêm vào giỏ hàng</span> </a></div>
                </div>
            </li>
            <%}%>

            <div class="load_produce text-center mt-5">
                <a href="<%=request.getContextPath()%>/product?category=khuyenmai"><span>Xem tất cả sản phẩm</span></a>
            </div>
        </ul>
    </div>
    <%}%>
<%--    --%>
    <%
        List<Category> categoryP = CategoryService.getInstance().getALl();
    %>
    <% for (Category ca : categoryP) {%>
    <div class="title_t" id="<%=ca.getId()%>">
        <p class="text-center fs-5 fw-bold"><%=ca.getName()%>
        </p>
    </div>
    <div class="solid_t mb-3 m-auto"></div>
    <div class="sp" id="sp_<%=ca.getId()%>">
        <ul class="products  m-2 d-flex flex-wrap">
            <%
                List<Product> product15 = ProductDAO.list15product(ca.getId());
                for (Product pr : product15) {
            %>
            <%String pathImage = ImageService.getInstance().pathImageOnly(pr.getId());%>
            <li class="product_list">
                <div class="item_product  me-4">
                    <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=pr.getId()%>"> <img  src="<%=request.getContextPath()%>/<%=pathImage%>"> </a>
                    <a href="#"><p class="pt-4 px-3"><%=pr.getName() %>
                    </p></a>
                    <%!double giaBanSauCung;%>
                    <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(pr);%>
                    <%if (pr.getCategoryId() >= 0 && giaBanSauCung != pr.getSellingPrice()) {%>
                    <del><%=numberFormat.format(pr.getSellingPrice())%></del>
                    <%}%>
                    <p><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pr))%></p>
                    <div class="add-to-cart"><a href="<%=request.getContextPath()%>/add-cart?actionCart=post&id=<%=pr.getId()%>"><span>Thêm vào giỏ hàng</span> </a></div>
                </div>
            </li>
            <%}%>

            <div class="load_produce text-center mt-5">
                <a href="<%=request.getContextPath()%>/product?category=<%=ca.getId()%>"><span>Xem tất cả sản phẩm</span></a>
            </div>
        </ul>
    </div>
    <%}%>
</div>


<!--Bí Kíp-->

<div class="bikip mt-5" id="bikip">
    <div class="title_bk">
        <p class="text-center fw-bold fs-4">BÍ KÍP LÀM ĐỒ HANDMADE</p>
    </div>
    <div class="solid_bk mb-5 m-auto"></div>
    <div class="content_bk">
        <ul class="d-flex ">


            <%
                List<Tip> tipsList = TipDAO.getAllTips();
                for (Tip t : tipsList) {
            %>

            <li class="item text-center">
                <a href="<%=t.getVideoLink()%>"><img src="<%=t.getImgPath()%>" width="90%"></a>
                <a href="<%=t.getVideoLink()%>"><h6 class="fw-bold text-center mt-3 px-3"><%=t.getTitle()%>
                </h6></a>
                <p class="px-5"><%=t.getDescription()%>
                </p>
            </li>
            <%}%>
        </ul>
    </div>
</div>
<!--    Footer-->
<div id="footer">
    <ul class="d-flex ">
        <li class="content col-6">
            <img src="<%=request.getContextPath()%>/images/logo.png" width="22%">
            <p class="me-5">
                HEADQUARTERS là cửa hàng về đồ HANDMADE về đồ trang trí, phụ kiện, thiệp, album ảnh, sổ tay được làm thủ
                công
                đẹp, ý nghĩa, thân thiện với mọi người.
            </p>
        </li>
        <li class="contact col-6 mt-5">
            <p class="content fs-2 fw-bold">Liên hệ với chúng tôi</p>
            <div class="address d-flex">
                <i class="fa-solid fa-location-dot py-2" style="color: #4d8a54"></i>
                <p class="p-2">Địa chỉ: Lớp DH21DTC,Khoa Công Nghệ Thông Tin,</br> Trường Đại Học Nông Lâm TP.HCM</p>
            </div>
            <div class="hotline d-flex">
                <i class="fa-solid fa-mobile-screen py-2" style="color: #4d8a54"></i>
                <p class="p-2">Hotline : 1900 3456</p>
            </div>
            <div class="icon">
                <a class="me-3 fs-3" href=""><i class="fa-brands fa-twitter" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-facebook" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-square-instagram" style="color: #4d8a54"></i></a>
                <a class="mx-3 fs-3" href=""><i class="fa-brands fa-youtube" style="color: #4d8a54"></i></a>
            </div>
        </li>
    </ul>
    <div class="solid  m-auto "></div>
    <div class="content_end fs-6 fw-bold text-center">
        <p>Bản quyền thuộc về HEADQUARTERS| Cung cấp bởi HEADQUARTERS</p>
    </div>
</div>
</body>

</html>