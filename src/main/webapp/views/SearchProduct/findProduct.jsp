<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.util.List" %><%--
  Created by IntelliJ IDEA.
  User: ASUS
  Date: 1/3/2024
  Time: 9:44 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href="<%=request.getContextPath()%>/views/bootstrap-css/bootstrap.min.css">
    <link href="<%=request.getContextPath()%>/views/SearchProduct/findProduct.css" rel="stylesheet" type="text/css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <title>Tìm Kiếm</title>
</head>
<body>
<%List<Product> allProductfp = (List<Product>) request.getAttribute("productInPage1");%>
<%String resultFind = (String) request.getAttribute("resultFind");%>
<div class="header">
    <%@include file="/views/MenuBar/menu.jsp" %>
</div>
<%----%>
<div id="findProducts" style="display: none"><%=resultFind%></div>
<div>
    <h2 class="text-center mt-3 ">Tìm Kiếm</h2>
    <%if(allProductfp.isEmpty() || allProductfp.equals("")){%>
    <div class="solid m-auto mb-4" style="background: black;height: 4px;width: 80px"></div>
    <p class="text-center fw-bold fs-5">Không tìm thấy nội dung bạn yêu cầu</p>
    <div class="text-center">
        <span class="text-center ">Không tìm thấy </span>
        <span class="fw-bold">"<%=resultFind%>"</span>
        <span>.Vui lòng sử dụng các từ tổng quát hơn và thử lại</span>
    </div>
    <div class="box_find d-flex justify-content-center align-items-center mt-5" style="margin-bottom: 370px">
        <form action="<%=request.getContextPath()%>/findProduct" method="post" id="find">
            <%if(resultFind.isEmpty()){%>
            <input name="findProducts" type="text" placeholder="Bạn tìm gì...">
            <%}else{%>
            <input name="findProducts" type="text" placeholder="Bạn tìm gì..." value="<%=resultFind%>" style="width: 70vh;background: #dadada;border: none;padding-left: 25px">
            <%}%>
            <button ><i class="fa-solid fa-magnifying-glass" style="color: white;"></i></button>
        </form>
    </div>
    <%}else{%>
    <div class="text-center mb-3">
        <span>Có </span>
        <span class="fw-bold"><%=request.getAttribute("numberProduct")%> sản phẩm </span>
        <span>cho tìm kiếm</span>
    </div>
    <div class="solid m-auto mb-4" style="background: black;height: 4px;width: 80px"></div>
    <div class="ms-5">
        <span>Kết quả tìm kiếm cho </span>
        <span class="fw-bold">"<%=resultFind%>".</span>
    </div>
    <%}%>
</div>
<div class="product_find">
    <ul id="allProduct" class="products m-2 me-5 ms-3 d-flex flex-wrap">
        <%for (Product pfp : allProductfp) {%>
        <%String pathImagefp = ImageService.getInstance().pathImageOnly(pfp.getId());%>
        <li class="product_li">
            <div class="item_product  me-4">
                <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=pfp.getId()%>"> <img src="<%=request.getContextPath()%>/<%=pathImagefp%>"> </a>
                <a href="<%=request.getContextPath()%>/product-detail?id=<%=pfp.getId()%>"><p class="pt-5 px-4"><%=pfp.getName() %>
                </p></a>
                <%!double giaBanSauCung;%>
                <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(pfp);%>
                <%if(pfp.getCategoryId() >= 0 && giaBanSauCung!= pfp.getSellingPrice()){%>
                <del ><p style="margin-top: 20px; margin-bottom: 0"><%=numberFormat.format(pfp.getSellingPrice())%></p></del>
                <p class="fw-bold text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pfp))%></p>
                <%}else{%>
                <p class="fw-bold" style="margin-top: 30px"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pfp))%></p>
                <%}%>
                <div class="add-to-cart">
                    <button onclick="addcart(this,<%=pfp.getId()%>)"><span class="fw-bold">Thêm vào giỏ <i class="fa-solid fa-cart-shopping"></i></span></button>
                </div>
            </div>
        </li>

        <%}%>
        
    </ul>
</div>
<%--    Số Trang--%>
<div class="pagination mx-5" style="padding: 0 40%;">

    <%int currentPage = (int) request.getAttribute("currentPage1");%>
    <%int totalPage = (int) request.getAttribute("totalPage1");%>
    <%
        if (currentPage > 1) {%>
    <a class="fs-5" href="<%=request.getContextPath()%>/findProduct?findProducts=<%=resultFind%>&&page=<%=(currentPage - 1)%>">Trước</a>
    <%}%>
    <%
        for (int i = 1; i <= totalPage; i++) {
            if (i == currentPage) {
    %>
    <strong><%=i%>
    </strong>
    <%} else {%>
    <a class="fs-5" href="<%=request.getContextPath()%>/findProduct?findProducts=<%=resultFind%>&&page=<%=i%>"><%=i%>
    </a>
    <%
            }
        }
    %>
    <%if (currentPage < totalPage) {%>
    <a class="fs-5" href="<%=request.getContextPath()%>/findProduct?findProducts=<%=resultFind%>&&page=<%=(currentPage+1)%>">Tiếp</a>
    <%}%>
</div>
<div class="footer">
    <%@include file="../Footer/footer.jsp" %>
</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
<%--    Chưa khắc phục đc lỗi--%>
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

</script>
</html>
