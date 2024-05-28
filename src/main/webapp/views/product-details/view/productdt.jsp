<%@ page import="org.w3c.dom.stylesheets.LinkStyle" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.bean.*" %>
<%@ page import="model.dao.UserDAO" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.service.UserService" %><%--
  Created by IntelliJ IDEA.
  User: Kien Nguyen
  Date: 12/11/2023
  Time: 4:41 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");%>

<% Product product = (Product) request.getAttribute("productById");%>
<% List<Image> imageList = (List<Image>) request.getAttribute("listImage");%>
<% Category categoryByProduct = (Category) request.getAttribute("categoryByProduct");%>
<% String description = product.getDescription();%>
<% List<Product> relatedProduct = (List<Product>) request.getAttribute("productRelated");%>
<%List<Rate> rateList = (List<Rate>) request.getAttribute("listRate");%>
<%
    int allStarsCount = ProductService.getInstance().getStarNumberCount(product.getId());
    int fiveStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 5);
    int fourStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 4);
    int threeStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 3);
    int twoStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 2);
    int oneStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 1);
    int zeroStarsCount = ProductService.getInstance().getStarNumberCount(product.getId(), 0);
%>
<%
    User sessionUser = (User) request.getSession().getAttribute("auth");
%>

<html>
<head>
    <title>ProductDetails</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Roboto:ital,wght@1,500&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Inline+One&display=swap" rel="stylesheet">
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <!--https://releases.jquery.com/-->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.min.js"
            integrity="sha384-+sLIOodYLS7CIrQpBjl+C7nPvqq+FbNUBDunl/OZv93DB7Ln/533i8e/mZXLi/P+"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-Fy6S3B9q64WdZWQUiU+q4/2Lc9npb8tCaSX9FK7E8HnRr0Jz8D6OP9dO5Vg3Q9ct"
            crossorigin="anonymous"></script>
    <style>

        <%@include file="../css/product.css"%>
        .dt-empty {
            display: none;
        }
    </style>

</head>
<body>
<%--Thanh điều hướng - header--%>
<%@include file="/views/MenuBar/menu.jsp" %>


<!-- Nội dung Product-details-->
<!-- Thẻ navigation : thanh chuyển hướng -->
<section class="product-details container  pt-2">

    <nav aria-label="breadcrumb">
        <ol class="breadcrumb ">
            <li class="breadcrumb-item"><a
                    href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">Trang Chủ</a></li>
            <li class="breadcrumb-item"><a
                    href="product?category=<%=categoryByProduct.getId()%>"><%=categoryByProduct.getName()%>
            </a></li>
            <li class="breadcrumb-item active" aria-current="page" style="color: #e32124"><%=product.getName()%>
            </li>
        </ol>
    </nav>
    <div class="row mt-3 ">
        <%--    Phần hiển thị ảnh sản phẩm. (trái)--%>
        <!--  zoom container start-->
        <div class="xzoom-container col-lg-5 col-md-12 col-12">
            <%
                if (imageList != null && !imageList.isEmpty()) {
                    Image mainImage = imageList.get(0);
            %>
            <img class="img-fluid w-100 pb-1 xzoom large-img" id="MainImg" src="<%=mainImage.getPath()%>" alt="">
            <div class="small-img-group">
                <%
                    for (int i = 1; i < Math.min(imageList.size(), 4); i++) {
                        Image secondImage = imageList.get(i);
                %>
                <div class="small-img-col">
                    <img src="<%= secondImage.getPath()%>" width="100%" class="small-img" alt="">
                </div>
                <%
                        }
                    }
                %>

            </div>

        </div>
        <%--     Phần hiển thị thông tin chi tiết của sản phẩm (phải)--%>
        <div class="col-lg-7 col-md-12 col-12 right-pd">

            <h3 class=""><%=product.getName() %>
            </h3>
            <div class="d-flex rate-content">
                <div class="icon-rate me-3">
                    <i class="bi bi-star "></i>
                    <i class="bi bi-star"></i>
                    <i class="bi bi-star"></i>
                    <i class="bi bi-star"></i>
                    <i class="bi bi-star"></i></div>
                <a href="#rating-comment">Đánh giá của bạn</a>

            </div>
            <div class="state-pd my-2">
                <label class="me-2 gray-content">Trạng thái: </label>
                <%--                Xử lý trạng thái còn hàng , hết hàng --%>
                <%int countProduct = product.getQuantity() - product.getSoldout(); %>

                <%if (countProduct > 1) {%>
                <span>Còn hàng</span>

                <% } else { %>

                <span style="color:#e32124 ">Tạm hết hàng</span>

                <%}%>


            </div>
            <h2 class="price-pd mb-4">
                    <%=numberFormat.format(product.getSellingPrice())%>

                <div class="row mt-3">
                    <div class="quantity-pd mb-4 col-4">
                        <label class="me-2" style="font-size: 14px">Số lượng: </label>
                        <div class="qu-value">
                            <button class="pd-des m-0">-</button>
                            <input type="text" class="quantity-input p-0" value="1">
                            <button class="pd-inc m-0">+</button>
                        </div>
                    </div>


                    <button class="buy-btn col-4" style="font-size: 16px" <%=request.getAttribute("disable")%>>

                        Thêm vào
                        giỏ hàng


                    </button>


                </div>


                <hr class="mx-auto">
                <h4 class=" mt-4 mb-4 ">Chi tiết sản phẩm</h4>

                <%--          Xử lý hiển thị chi tiết sản phẩm theo từng dòng văn bản--%>
                    <%String[] lines = description.split("\\r?\\n");
                for(String line : lines) {

%>

                <p class="gray-content"><%=line%>
                </p>
                    <%}%>
        </div>
    </div>


</section>

<section id="relate" class="mt-5 ">
    <div class="container pb-4">
        <h4>Sản phẩm liên quan</h4>
        <hr class="mx-auto">

        <div class="row my-5 ">

            <%for (Product pr : relatedProduct) {%>
            <%String pathImage = ImageService.getInstance().pathImageOnly(pr.getId());%>

            <div class="col info-item mx-3">
                <div class="info-img ">
                    <img src="<%=request.getContextPath()%>/<%=pathImage%>" alt=""
                         class="img-fluid d-block mx-auto mt-2">


                    <div class="row btns w-100 mx-auto ">
                        <button type="button" class="col-6 py-2">
                            <a href="<%=request.getContextPath()%>/add-cart?actionCart=post&num=1&id=<%=pr.getId()%>">
                                <i class="bi bi-cart-plus"></i>
                            </a>
                        </button>
                        <button type="button" class="col-6 py-2">
                            <a href="product-detail?id=<%=pr.getId()%>"> <i class="bi bi-eye"></i> </a>
                        </button>
                    </div>
                </div>
                <div class="info-product p-3">
                    <a href="product-detail?id=<%=pr.getId()%>"
                       class="d-block text-dark text-decoration-none py-2 info-name">
                        <%=pr.getName()%>
                    </a>
                    <span class="info-price fw-bold"><%=numberFormat.format(pr.getSellingPrice()) %></span>
                    <div class="info-rating d-flex mt-1">

                        <span>(<%=rateList.size()%> đánh giá)</span>
                    </div>
                </div>

            </div>
            <%}%>


        </div>


    </div>


</section>
<%--</section>--%>
<%if (!rateList.isEmpty()) {%>
<section id="rating-comment" class="rating container mb-5">
    <h4 pb-1>Đánh giá sản phẩm</h4>
    <div class="d-flex">
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer; width: 70px"
             onclick="renderRateByStarNumber(0)">Tất cả (<%=allStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer; width: 70px"
             onclick="renderRateByStarNumber(5)">5 sao (<%=fiveStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             onclick="renderRateByStarNumber(4)">4 sao (<%=fourStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             onclick="renderRateByStarNumber(3)">3 sao (<%=threeStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             onclick="renderRateByStarNumber(2)">2 sao (<%=twoStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             onclick="renderRateByStarNumber(1)">1 sao (<%=oneStarsCount%>)
        </div>
    </div>
    <hr class="mx-auto">
    <!-- Các bình luận sẽ được hiển thị ở đây -->
    <table id="rate_table" style="width: 100%;">
        <thead style="display: none">
        <tr>
            <th></th>
        </tr>
        </thead>
        <tbody>
        <% for (Rate r : rateList) {%>
        <tr>
            <td>
                <div class="d-flex flex-column mx-2 comments">
                    <div class="p-1 d-flex flex-row">
                        <h6 class="pe-2 m-0 "><%=UserDAO.getUserNameById(r.getUserId())%>
                        </h6>
                        <p style="font-style: italic ; color: #898989 ; font-family: Arial" class="m-0"> Đã đăng vào
                            lúc   <%=" " + r.getCreateDate()%>
                        </p>
                    </div>

                    <div class=" p-1 ratings ">
                        <% int star = r.getStarRatings();
                            for (int i = 1; i <= 5; i++) { %>
                        <%if (i <= star) {%>
                        <i class="bi bi-star-fill " style="color: #ffcc00"></i>
                        <%} else {%>
                        <i class="bi bi-star-fill "></i>
                        <%
                                }
                            }
                        %>
                    </div>
                    <p class="p-1"><%=r.getComment()%>
                    </p>
                </div>
            </td>
        </tr>
        <%}%>
        </tbody>
    </table>
    <%if (sessionUser != null && UserService.getInstance().checkUserAllowedToRate(sessionUser.getId(), product.getId())) {%>
        <div class="ratings mb-3">
            <i class="bi bi-star-fill" id="rate_1"></i>
            <i class="bi bi-star-fill" id="rate_2"></i>
            <i class="bi bi-star-fill" id="rate_3"></i>
            <i class="bi bi-star-fill" id="rate_4"></i>
            <i class="bi bi-star-fill" id="rate_5"></i>
        </div>
        <div class="d-flex comment-pd">
        <textarea class="comment-input p-2" rows="3" placeholder="Viết bình luận" maxlength="350">
        </textarea>
            <button type="button" class="submit-comment btn  btn-outline-success btn-sm shadow-sm ">Gửi</button>
        </div>
    <%}%>
</section>
<%}%>
<!--    Footer-->
<%@include file="/views/Footer/footer.jsp" %>


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>

<script>
    var MainImg = document.getElementById('MainImg');
    var smallimg = document.getElementsByClassName('small-img');
    smallimg[0].onclick = function () {
        MainImg.src = smallimg[0].src;
    }
    smallimg[1].onclick = function () {
        MainImg.src = smallimg[1].src;
    }
    smallimg[2].onclick = function () {
        MainImg.src = smallimg[2].src;
    }
    smallimg[3].onclick = function () {
        MainImg.src = smallimg[3].src;
    }


</script>

<script>
    document.addEventListener("DOMContentLoaded", function () {
        const incrementButton = document.querySelector(".pd-inc");
        const decrementButton = document.querySelector(".pd-des");
        const quantityInput = document.querySelector(".quantity-input");
        const addToCartLink = document.querySelector(".buy-btn");

        incrementButton.addEventListener("click", function () {
            console.log("Button + clicked");
            quantityInput.value = parseInt(quantityInput.value) + 1;
        });

        decrementButton.addEventListener("click", function () {
            console.log("Button - clicked");
            const currentValue = parseInt(quantityInput.value);

            if (currentValue > 1) {
                quantityInput.value = currentValue - 1;
            }
        });
        addToCartLink.addEventListener("click", function (event) {
            event.preventDefault();
            const productId = <%=product.getId()%>;
            const quantity = parseInt(quantityInput.value);
            const URL = `<%=request.getContextPath()%>/add-cart?actionCart=post&num=${quantity}&id=${productId}`;
            window.location.href = URL;
            quantityInput.value = 1;
        });
    });
    $(document).ready(function () {
        $(document).ready(function () {
            $('#rate_table').DataTable({
                "paging": true, // Phân trang
                "searching": false, // Không có tính năng tìm kiếm
                "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
                "pageLength": 5,
                "info": false
            });
        });
    });

    function renderRateByStarNumber(starNumber) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/rate-ajax-handle",
            data: {
                productId: <%=product.getId()%>,
                action: "filterStar",
                starNumber: starNumber
            },
            success: function (response) {
                const table = $('#rate_table').DataTable();
                table.clear().draw();
                response.forEach(function (r) {
                    const starHtml = renderStars(r.starRatings);
                    const rowHtml = `
                    <tr>
                        <td>
                             <div class="d-flex flex-column mx-2 comments">
                                <div class="p-1 d-flex flex-row">
                                    <h6 class="pe-2 m-0 ">${r.userId}
                                    </h6>
                                    <p style="font-style: italic ; color: #898989 ; font-family: Arial" class="m-0"> Đã đăng vào
                                        lúc   ${r.createDate}
                                    </p>
                                </div>
                                <div class=" p-1 ratings ">
                                    ${starHtml}
                                </div>
                                <p class="p-1">${r.comment}
                                </p>
                            </div>
                        </td>
                    </tr>
                `;
                    table.row.add($(rowHtml)).draw();
                });
            },
            error: function () {
                alert("error")
            }
        })
    }

    function renderStars(star) {
        let starsHtml = '';
        for (let i = 1; i <= 5; i++) {
            if (i <= star) {
                starsHtml += '<i class="bi bi-star-fill" style="color: #ffcc00"></i>';
            } else {
                starsHtml += '<i class="bi bi-star-fill"></i>';
            }
        }
        return starsHtml;
    }
</script>
</body>
</html>
