<%@ page import="model.bean.User" %>
<%@ page import="model.bean.Cart" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.bean.Item" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Đặt hàng - Thanh Toán</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link rel="stylesheet" href="../PaymentPage/css/paymentpage.css">
    <link rel="stylesheet" href="../bootstrap-css/bootstrap.min.css">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Inline+One&display=swap" rel="stylesheet">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.2/axios.min.js" integrity="sha512-JSCFHhKDilTRRXe9ak/FJ28dcpOJxzQaCd3Xg8MyF6XFjODhy/YMCM8HW0TFDckNHWUewW+kfvhin43hKtJxAw==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

    <style>

        <%@include file="../PaymentPage/css/paymentpage.css"%>

    </style>
</head>

<body>


<%User user = (User) session.getAttribute("auth");%>

<%
    Cart cart = (Cart) session.getAttribute("cart");
    if (cart == null) cart = new Cart();
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>

<%--Tạo cac parameter.--%>

<%
    Map<String, String> listNull = (Map<String, String>) request.getAttribute("errors") ;
    String namePay = request.getParameter("namePay") == null ? "" : request.getParameter("namePay");
    String phonePay = request.getParameter("phonePay") == null ? "" : request.getParameter("phonePay");
    String address = request.getParameter("address") == null ? "" : request.getParameter("address");
    String notePay = request.getParameter("notePay") == null ? "" : request.getParameter("notePay");
//    double totalMoney = Double.parseDouble(request.getParameter("pricePay") == null ? "" : request.getParameter("pricePay"));
%>

    <form action="<%=request.getContextPath()%>/payment" method="get">
        <div class="row">
            <div class="col-lg-8 col-sm-12 p-0">
                <div class="h1 border-bottom alert ps-0 m-0 " style="height: 12%">
                    <a href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp"
                       class="text-decoration-none mx-3" style="color: #f4c994"><img
                            src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" width="8%">HEADQUARTERS</a>
                </div>


                <div id="inform" class="p-3 d-flex justify-content-center align-items-center flex-column">
                    <h3>Thời gian đặt hàng của quý khách còn : </h3>
                    <p id="count-down"></p>
                </div>

                <div class="d-flex mx-5 py-3">
                    <div class="col-lg-7 col-sm-6 me-5">
                        <div class="h6 text-black fw-bold text-center">
                            Thông tin nhận hàng
                        </div>
                        <div class="mt-4">
                            <div class="input-group mb-3 justify-content-center">
                                <div class="input-group-prepend w-100">
                                    <%--                            email--%>
                                    <%--                            <div class="form-floating mb-3">--%>
                                    <%--                                <input id="email" type="email" pattern="[a-z0-9._%+\-]+@[a-z0-9.\-]+\.[a-z]{2,}$"--%>
                                    <%--                                       class="form-control" placeholder="Email(tùy chọn)">--%>
                                    <%--                                <label for="email" class="floatingInput">Email(Tùy Chọn)</label>--%>
                                    <%--                            </div>--%>

                                    <div class="form-floating mb-3">
                                        <%if (user == null) {%>
                                        <input id="name" name="namePay" type="text" class="form-control"
                                               placeholder="Họ và tên" value="<%=namePay%>">
                                        <label for="name" class="floatingInput">Họ Và Tên</label>
                                        <%} else {%>
                                        <input id="name" name="namePay" type="text" class="form-control"
                                               placeholder="Họ và tên"
                                               value="<%=user.getName()%>">
                                        <label for="name" class="floatingInput">Họ Và Tên</label>
                                        <%}%>
                                        <% if (listNull != null && listNull.containsKey("namePay")) { %>
                                        <span class="error-message warning" style="font-size: 11px ; color: red"><%= listNull.get("namePay") %></span>
                                        <% } %>
                                    </div>

                                    <div class="form-floating mb-3">
                                        <%if (user == null) {%>
                                       <input id="phone_number" name="phonePay" type="tel"
                                               pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}"  value="<%=phonePay%>"
                                               class="form-control" placeholder="Số điện thoại">
                                        <label for="phone_number" class="floatingInput">Số Điện Thoại</label>
                                        <%} else {%>
                                        <input id="phone_number" name="phonePay" type="tel"
                                               class="form-control" placeholder="Số điện thoại"
                                               value="<%=user.getPhoneNumber()%>"  >
                                        <label for="phone_number" class="floatingInput">Số Điện Thoại</label>
                                        <%}%>

                                        <% if (listNull != null && listNull.containsKey("phonePay")) { %>
                                        <span class="error-message warning" style="font-size: 11px  ; color: red"><%= listNull.get("phonePay") %></span>
                                        <% } %>


                                    </div>
                                    <div class="form-floating mb-3">
                                        <%if (user == null) {%>
                                        <input id="address" name="address" type="text" class="form-control"
                                               placeholder="Địa chỉ" value="<%=address%>">
                                        <label for="address" class="floatingInput">Địa Chỉ: Số Nhà, Tên Đường,...</label>
                                        <%} else {%>
                                        <input id="address" name="address" type="text" class="form-control"
                                               placeholder="Địa chỉ" value="<%=address%>" >
                                        <label for="address" class="floatingInput">Địa Chỉ: Số Nhà, Tên Đường,...</label>
                                        <%}%>

                                        <% if (listNull != null && listNull.containsKey("address")) { %>
                                        <span class="error-message warning" style="font-size: 11px  ; color: red"><%= listNull.get("address") %></span>
                                        <% } %>

                                    </div>

                                        <div class="form-floating ">
                                            <select  id="provinceDropdown" class="form-select"
                                                    aria-label="Chọn tỉnh thành">
                                                <option value="">Chọn tỉnh thành</option>
                                            </select>
                                            <label for="provinceDropdown">Tỉnh thành</label>
                                        </div>

                                        <div class="form-floating ">
                                            <select  id="districtDropdown" class="form-select"
                                                     aria-label="Chọn huyện">
                                                <option value="">Chọn quận, huyện</option>
                                            </select>
                                            <label for="districtDropdown">Quận, Huyện</label>
                                        </div>

                                    <div class="form-floating mb-3">
                                    <textarea id="note" name="notePay" class="form-control"
                                              style="height: 150%"></textarea>
                                        <label for="address" class="floatingInput">Ghi Chú(Tùy Chọn)</label>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-lg-5 col-sm-6">
                        <div class="h6 text-black fw-bold">
                            Thanh toán
                        </div>
                        <div class="mt-4">

                            <div class="border alert alert-dismissible d-flex align-items-center">
                                <input class="form-check-input fs-5 me-3" style="cursor: pointer" type="radio"
                                       name="flexRadioDefault"
                                       id="thanhtoankhigiaohang"
                                       onclick="hideBankaccount_infor()" checked>
                                <label class="form-check-label" style="cursor: pointer" for="thanhtoankhigiaohang">
                                    Thanh toán khi giao hàng (COD)
                                </label>
                                <i class="fa-regular fa-money-bill-1 fa-xl ms-auto" style="color: #357ebd;"></i>
                            </div>
                            <img src="" alt="">
                        </div>
                    </div>
                </div>

                <hr>
                <div class="row ms-auto float-end me-4">
                    <ul class="list-group list-group-horizontal list-unstyled">
                        <li class="list-group-item border-0">
                            <a onclick="showPoliciesAndTerms(1)" class="link-underline-light color-for-text" href="#">Chính
                                sách
                                hoàn trả</a>
                        </li>
                        <li class="list-group-item border-0">
                            <a onclick="showPoliciesAndTerms(2)" class="link-underline-light color-for-text" href="#">Chính
                                sách
                                bảo mật</a>
                        </li>
                        <li class="list-group-item border-0">
                            <a onclick="showPoliciesAndTerms(3)" class="link-underline-light color-for-text" href="#">Điều
                                khoản
                                sử dụng</a>
                        </li>
                    </ul>
                </div>
                <div class="row ms-auto float-end me-4">
                    <p class="text-end">
                        Cảm ơn bạn đã đặt hàng tại HandMadeStore. Chúng tôi sẽ liên lạc bạn sớm
                        nhất để vận chuyển hàng hóa đến bạn. Có bất kỳ thắc mắc, vui lòng gọi ngay số tại HCM 0336677141,
                        Hà Nội 0973 628 417, Đà Nẵng 0973 628 418 hoặc bất kỳ kênh online chính thức khác của
                        HandMadeStore.
                    </p>
                </div>
            </div>
            <%--Phần 2--%>
            <div class="col-lg-4 col-sm-12  border-start  p-0" style="background-color: #FAFAFA">
                <div class="h6 text-black fw-bold p-3 border">
                    Đơn hàng
                    <span>(<%=cart.getTotal()%> sản phẩm)</span>
                </div>
                <div style="

            display: flex;
            flex-direction: column;
            align-items: center;
            text-align: center;">

                    <div style="width: 90%;">
                        <table class="table table-striped table-borderless table-hover text-start">
                <%double totalMoney = 0;%>
                         <%for(Item i : cart.getItems().values()) {%>
                           <tr>
                                <td>
                                    <div>
                                        <%String pathImage = ImageService.getInstance().pathImageOnly(i.getProduct().getId());%>
                                        <img class="product-img" src="<%=request.getContextPath()%>/<%=pathImage%>" alt="sanpham">
                                        <span class="product-quantity"><%=i.getQuantity()%></span>
                                    </div>
                                </td>
                                <td>
                                    <div>
                                        <h6><%=i.getProduct().getName()%></h6>

                                    </div>
                                </td>
                               <%totalMoney += (i.getPrice() * i.getQuantity());%>
                                <td><%=numberFormat.format(i.getPrice() * i.getQuantity())%></td>
                            </tr>
                            <%}%>

                        </table>
                        <div class="row border-top py-3">
                            <div class="input-group-prepend col-9  d-flex align-items-center">
                                <div class="form-floating w-100">
                                    <input id="discount_code" type="text" class="form-control"
                                           placeholder="Nhập mã giảm giá">
                                    <label for="discount_code" class="floatingInput">Nhập mã giảm giá</label>
                                </div>
                            </div>
                            <div class="col-3 d-flex align-items-center">
                                <button type="button" class="btn btn-primary h-100 w-100 color-for-bg">Áp dụng</button>
                            </div>
                        </div>
                        <div class="row border-top py-3">
                            <table class="table-borderless">
                                <thead>
                                <tr>
                                    <td><span class="visually-hidden">Mô tả</span></td>
                                    <td><span class="visually-hidden">Giá tiền</span></td>
                                </tr>
                                </thead>
                                <tbody>
                                <tr>
                                    <th class="text-start fw-medium">
                                        Tạm tính
                                    </th>
                                    <td class="text-end pe-3"><%=numberFormat.format(totalMoney)%></td>
                                </tr>
                                <tr>
                                    <th class="text-start fw-medium">
                                        Phí vận chuyển
                                    </th>
                                    <td class="text-end pe-3">35.000₫</td>
                                </tr>
                                </tbody>
                                <tfoot>
                                <tr>
                                    <th class="text-start fs-5 fw-medium">
                                <span>
                                    Tổng cộng
                                </span>
                                    </th>
                                    <td class="text-end pe-3 fs-4 text-primary">

                                <span>
                                   <%=numberFormat.format(totalMoney + 35000)%>
                                </span>

                                    </td>
                                </tr>
                                </tfoot>
                            </table>
                        </div>
                        <div class="row py-3 ">
                            <div class="col-4 d-flex align-items-center">
                        <span><a href="../CartPage/view/cart.jsp"
                                 class="text-decoration-none color-for-text"><strong><</strong> Quay lại giỏ hàng</a></span>
                            </div>
                            <div class="col-8 text-end">
                                <button type="submit" class="btn btn-primary fs-1 color-for-bg">Đặt Hàng</button>
                            </div>

                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div id="infor_center">
            <div class="modal-wrapper">
                <div class="alert alert-primary alert-dismissible">
                    <button type="button" class="btn-close" onclick="hidePoliciesAndTerms()"></button>
                    <h5 id="infor_center_title"></h5>
                </div>
                <pre id="infor_center_content"></pre>
            </div>
        </div>
    </form>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>


    const startingMinutes = 5;
    let time = startingMinutes * 60;
    console.log('hello');
    const countDownEl = document.getElementById('count-down');

    setInterval(updateCountDown, 1000);
    function updateCountDown() {
        const minutes = Math.floor(time/60);
        let seconds = time%60;
        seconds = seconds <  10 ? '0' + seconds : seconds;
        console.log(seconds);

        countDownEl.innerHTML = ` ${minutes} : ${seconds}`


        time--;


    }

//      LẤY TỈNH THÀNH.
    $(document).ready(function (){
        function fetchDistricts(provinceId) {
            $.ajax({
                type: "GET",
                url: "/HandMadeStore/district-api",
                data: {
                    provinceId : provinceId
                },
                dataType : "json",
                success: function (response) {
                    console.log(response);
                    $("#districtDropdown").empty();

                    var districtDropdown = $("#districtDropdown");
                    response.forEach(function (district){
                        var option = $("<option>").val(district.districtId).text(district.districtName);
                        districtDropdown.append(option);
                        }
                    );

                }, error: function (xhr, status, error) {
                    alert("Không lấy đươợc danh sách quận, huyện.");
                }
            })

        }

        // Sự kiện select province cho district
        $("#provinceDropdown").change(function () {
            var selectedProvinceId = $(this).val(); // lay id province duoc chon
            if(selectedProvinceId) {
                fetchDistricts(selectedProvinceId);
            }else {
                $("#districtDropdown").empty();
            }
        })



        $.ajax({
            type: "GET",
            url : "/HandMadeStore/province-api",
            success: function (response) {
                var provinceDropDown = $("#provinceDropdown");
                response.forEach(function (province) {
                    var option = $("<option>").val(province.provinceId).text(province.provinceName);
                    provinceDropDown.append(option);
                });
            },
            error: function (xhr, status, error) {
                alert("Lỗi tải dữ liệu tỉnh, thành " + error)
            }



        })




    })





</script>

    <script src="../PaymentPage/js/paymentpage.js"></script>
    <!--Bộ select tỉnh thành-->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"
            integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>


    </body>
    </html>

