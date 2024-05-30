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

        .rate {
            float: left;
            height: 46px;
            padding: 0 10px;
        }

        .rate:not(:checked) > input {
            position: absolute;
            top: -9999px;
            display: none;
        }

        .rate:not(:checked) > label {
            float: right;
            width: 1em;
            overflow: hidden;
            white-space: nowrap;
            cursor: pointer;
            font-size: 30px;
            color: #ccc;
        }

        .rate:not(:checked) > label:before {
            content: '★ ';
        }

        .rate > input:checked ~ label {
            color: #ffc700;
        }

        .rate:not(:checked) > label:hover,
        .rate:not(:checked) > label:hover ~ label {
            color: #deb217;
        }

        .rate > input:checked + label:hover,
        .rate > input:checked + label:hover ~ label,
        .rate > input:checked ~ label:hover,
        .rate > input:checked ~ label:hover ~ label,
        .rate > label:hover ~ input:checked ~ label {
            color: #c59b08;
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
             id="filter_all_star"
             onclick="renderRateByStarNumber(0)">Tất cả (<%=allStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer; width: 70px"
             id="filter_5_star"
             onclick="renderRateByStarNumber(5)">5 sao (<%=fiveStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_4_star"
             onclick="renderRateByStarNumber(4)">4 sao (<%=fourStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_3_star"
             onclick="renderRateByStarNumber(3)">3 sao (<%=threeStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_2_star"
             onclick="renderRateByStarNumber(2)">2 sao (<%=twoStarsCount%>)
        </div>
        <div class="p-1 m-3 rounded-2 bg-light border text-center" style="cursor: pointer;  width: 70px"
             id="filter_1_star"
             onclick="renderRateByStarNumber(1)">1 sao (<%=oneStarsCount%>)
        </div>
    </div>
    <hr class="m-0">
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
                    <%if (sessionUser.getId() == r.getUserId()) {%>
                    <div class="text-success mt-3">
                        Cảm ơn đánh giá của bạn!
                        <i class="fa-regular fa-face-smile-beam"></i>
                    </div>
                    <%}%>
                    <div class="p-1 d-flex flex-row">
                        <h6 class="pe-2 m-0 ">
                            <%=UserDAO.getUserNameById(r.getUserId())%>
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
    <%
        if (sessionUser != null && UserService.getInstance().checkUserAllowedToRate(product.getId(), sessionUser.getId())) {
            //kiểm tra user đã mua chưa & chưa chỉnh sửa
            int changeNumber = ProductService.getInstance().getChangeNumber(product.getId(), sessionUser.getId());
            if (changeNumber == 0 || changeNumber == -1) {
    %>
    <div class="my-3" id="rate-box">
        <div class="rate">
            <input type="radio" id="star5" name="rate" value="5"/>
            <label for="star5" title="text">5 stars</label>
            <input type="radio" id="star4" name="rate" value="4"/>
            <label for="star4" title="text">4 stars</label>
            <input type="radio" id="star3" name="rate" value="3"/>
            <label for="star3" title="text">3 stars</label>
            <input type="radio" id="star2" name="rate" value="2"/>
            <label for="star2" title="text">2 stars</label>
            <input type="radio" id="star1" name="rate" value="1"/>
            <label for="star1" title="text">1 star</label>
        </div>
        <div class="border rounded-3">
            <div class="text-danger mt-3" id="rate_validate" style="display: none">
                <i class="fa-regular fa-hand-point-left"></i> Bạn chưa chọn sao đánh giá!
            </div>
            <textarea class="form-control mx-auto w-70" id="comment" name="comment"
                      rows="3" placeholder="Viết bình luận"></textarea>
        </div>
        <% if (changeNumber == 0) {%>
        <button type="button" class="btn  btn-outline-warning w-100" id="btn_editRating" onclick="addRating()">
            Hoàn tất chỉnh sửa đánh giá
        </button>
        <%} else if (changeNumber == -1) {%>
        <button type="button" class="btn  btn-outline-success w-100" id="btn_addRating" onclick="addRating()">
            Hoàn tất đánh giá
        </button>
        <%}%>
    </div>
    <%}%>
    <%}%>
</section>
<%}%>
<input type="hidden"
       value="<%=ProductService.getInstance().getNumberRateStarsByUser(product.getId(), sessionUser.getId())%>"
       id="oldRatingValue">
<input type="hidden"
       value="<%=sessionUser.getId()%>"
       id="userId">
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

                    const cssForUser = (userId == r.userId) ?
                        `<div class="text-success mt-3">
                                Cảm ơn đánh giá của bạn!
                                <i class="fa-regular fa-face-smile-beam"></i>
                            </div>` : ``;
                    const rowHtml = `
                    <tr>
                        <td>
                             <div class="d-flex flex-column mx-2 comments">
                             ${cssForUser}
                                <div class="p-1 d-flex flex-row">
                                    <h6 class="pe-2 m-0 ">
                                    ${r.userFullName}
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

    function addRating() {
        let rating = document.querySelector('input[name="rate"]:checked');
        let ratingValue = rating ? rating.value : null;
        let comment = document.getElementById('comment').value;
        if (ratingValue == null) {
            document.getElementById("rate_validate").style.display = "block"
        } else {
            document.getElementById("rate_validate").style.display = "none";
            $.ajax({
                method: "POST",
                url: "/HandMadeStore/rate-ajax-handle",
                data: {
                    productId: <%=product.getId()%>,
                    action: "addRating",
                    ratingValue: ratingValue,
                    comment: comment
                },
                success: function (response) {
                    const table = $('#rate_table').DataTable();
                    table.clear().draw();
                    response.forEach(function (r) {
                        const starHtml = renderStars(r.starRatings);
                        const userId = document.getElementById("userId").value;
                        const cssForUser = (userId == r.userId) ?
                            `<div class="text-success mt-3">
                                Cảm ơn đánh giá của bạn!
                                <i class="fa-regular fa-face-smile-beam"></i>
                            </div>` : ``;
                        const rowHtml = `
                    <tr>
                        <td>
                             <div class="d-flex flex-column mx-2 comments">
                             ${cssForUser}
                                <div class="p-1 d-flex flex-row">
                                    <h6 class="pe-2 m-0 ">${r.userFullName}
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
                    const changeNumber = response[0].changeNumber; // Assuming changeNumber is part of the response
                    console.log(response.length, changeNumber)
                    if (changeNumber === 1) {
                        const rateBox = document.querySelector("#rate-box");
                        rateBox.remove();
                        // ratingValue cũ
                        let oldRatingValue = document.querySelector("#oldRatingValue").value;
                        console.log("check", oldRatingValue);
                        let oldFilterStar = document.querySelector("#" + "filter_" + oldRatingValue + "_star")
                        let starText = oldFilterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        let matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            oldFilterStar.innerHTML = ratingValue + " sao (" + (starsCount - 1) + ")"
                        }
                        // ratingValue mới
                        let filterStar = document.querySelector("#" + "filter_" + ratingValue + "_star")
                        starText = filterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            filterStar.innerHTML = ratingValue + " sao (" + (starsCount + 1) + ")"
                        }
                    } else if (changeNumber === 0) {
                        let all = document.querySelector("#filter_all_star");
                        all.innerHTML = "Tất cả (" + response.length + ")"
                        let filterStar = document.querySelector("#" + "filter_" + ratingValue + "_star")
                        const starText = filterStar.innerText; //ex: 5 sao (4)
                        // Sử dụng biểu thức chính quy để tách giá trị số trong dấu ngoặc đơn
                        var matches = starText.match(/\((\d+)\)/);//lấy 4
                        if (matches) {
                            const starsCount = parseInt(matches[1], 10);
                            filterStar.innerHTML = ratingValue + " sao (" + (starsCount + 1) + ")"
                            document.getElementById("oldRatingValue").value = (starsCount + 1);
                        } else {
                            console.log("Không tìm thấy giá trị trong dấu ngoặc đơn");
                        }
                        let btnAddRating = document.querySelector("#btn_addRating");
                        let btnEditRating = document.querySelector("#btn_editRating");
                        if (!btnEditRating) {
                            btnEditRating = document.createElement("button");
                            btnEditRating.type = "button";
                            btnEditRating.className = "btn btn-outline-warning w-100";
                            btnEditRating.id = "btn_editRating";
                            btnEditRating.innerText = "Hoàn tất chỉnh sửa đánh giá";
                            btnEditRating.onclick = addRating;

                            if (btnAddRating) {
                                btnAddRating.replaceWith(btnEditRating);
                            }
                        }
                    }
                },
                error: function () {
                    alert("error")
                }
            })
        }
    }
</script>
</body>
</html>
