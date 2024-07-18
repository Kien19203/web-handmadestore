<%@ page import="model.bean.User" %>
<%@ page import="model.bean.Cart" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.bean.Item" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="java.util.Map" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Long paymentStartTime = 0L;
    Integer timeCounter = 1;
    try {
        paymentStartTime = (Long) request.getSession().getAttribute("paymentStartTime");
        System.out.println("paymentStartTime " + paymentStartTime);
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/axios/1.7.2/axios.min.js"
            integrity="sha512-JSCFHhKDilTRRXe9ak/FJ28dcpOJxzQaCd3Xg8MyF6XFjODhy/YMCM8HW0TFDckNHWUewW+kfvhin43hKtJxAw=="
            crossorigin="anonymous" referrerpolicy="no-referrer"></script>

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
    Map<String, String> listNull = (Map<String, String>) request.getAttribute("errors");
    String namePay = request.getParameter("namePay") == null ? "" : request.getParameter("namePay");
    String phonePay = request.getParameter("phonePay") == null ? "" : request.getParameter("phonePay");
    String address = request.getParameter("address") == null ? "" : request.getParameter("address");
    String notePay = request.getParameter("notePay") == null ? "" : request.getParameter("notePay");
//    double totalMoney = Double.parseDouble(request.getParameter("pricePay") == null ? "" : request.getParameter("pricePay"));
%>

<form id="formPayment" action="<%=request.getContextPath()%>/payment" method="post">
    <div class="row">
        <div class="col-lg-8 col-sm-12 p-0">
            <div class="h1 border-bottom alert ps-0 m-0 " style="height: 12%">
                <a href=""
                   class="text-decoration-none mx-3" style="color: #f4c994"><img
                        src="<%=request.getContextPath()+"/"+ImageService.getLogoImagePath()%>" width="8%">HEADQUARTERS</a>
            </div>


            <div id="inform" class="p-3 d-flex justify-content-center align-items-center flex-column">
                <h3>Thời gian đặt hàng của quý khách còn : </h3>
                <p id="count-down" class="p-2">00:00</p>
            </div>

            <div class="d-flex mx-5 py-3">
                <div class="col-lg-7 col-sm-6 me-3">
                    <div class="h6 text-black fw-bold text-center">
                        Thông tin nhận hàng
                    </div>
                    <div class="mt-4">
                        <div class="input-group mb-3 justify-content-center">
                            <div class="input-group-prepend w-100">
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
                                    <span class="error-message warning"
                                          style="font-size: 11px ; color: red"><%= listNull.get("namePay") %></span>
                                    <% } %>
                                </div>

                                <div class="form-floating mb-3">
                                    <%if (user == null) {%>
                                    <input id="phone_number" name="phonePay" type="tel"
                                           pattern="[0-9]{3}-[0-9]{3}-[0-9]{4}" value="<%=phonePay%>"
                                           class="form-control" placeholder="Số điện thoại">
                                    <label for="phone_number" class="floatingInput">Số Điện Thoại</label>
                                    <%} else {%>
                                    <input id="phone_number" name="phonePay" type="tel"
                                           class="form-control" placeholder="Số điện thoại"
                                           value="<%=user.getPhoneNumber()%>">
                                    <label for="phone_number" class="floatingInput">Số Điện Thoại</label>
                                    <%}%>

                                    <% if (listNull != null && listNull.containsKey("phonePay")) { %>
                                    <span class="error-message warning"
                                          style="font-size: 11px  ; color: red"><%= listNull.get("phonePay") %></span>
                                    <% } %>


                                </div>


                                <div class="form-floating mb-3">
                                    <select id="provinceDropdown" class="form-select"
                                            aria-label="Chọn tỉnh thành">
                                        <option value="">Chọn tỉnh thành</option>
                                    </select>
                                    <label for="provinceDropdown">Tỉnh thành</label>
                                </div>

                                <div class="form-floating mb-3">
                                    <select id="districtDropdown" class="form-select"
                                            aria-label="Chọn huyện">
                                        <option value="">Chọn quận, huyện</option>
                                    </select>
                                    <label for="districtDropdown">Quận, Huyện</label>
                                </div>

                                <div class="form-floating mb-3">
                                    <select id="wardDropdown" class="form-select"
                                            aria-label="Chọn xã, thị trấn">
                                        <option value="">Chọn xã, thị trấn</option>
                                    </select>
                                    <label for="wardDropdown">Xã, Thị Trấn</label>
                                </div>
                                <div class="form-floating mb-3">
                                    <%if (user == null) {%>
                                    <input id="address" name="address" type="text" class="form-control"
                                           placeholder="Địa chỉ" value="<%=address%>">
                                    <label for="address" class="floatingInput">Số Nhà, Tên Đường,...</label>
                                    <%} else {%>
                                    <input id="address" name="address" type="text" class="form-control"
                                           placeholder="Địa chỉ" value="<%=address%>">
                                    <label for="address" class="floatingInput">Số Nhà, Tên Đường,...</label>
                                    <%}%>

                                    <% if (listNull != null && listNull.containsKey("address")) { %>
                                    <span class="error-message warning"
                                          style="font-size: 11px  ; color: red"><%= listNull.get("address") %></span>
                                    <% } %>

                                </div>

                                <input type="hidden" id="formattedAddress" name="formattedAddress">

                                <div class="form-floating mb-3">
                                    <select id="serviceDropdown" class="form-select"
                                            aria-label="Chọn dịch vụ vận chuyển">
                                        <option value="">Chọn dịch vụ</option>
                                    </select>
                                    <label for="serviceDropdown">Dịch vụ vận chuyên</label>
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
                        <input type="hidden" id="shippingFeeInput" name="shippingFee" value="">
                        <input type="hidden" id="totalAmountInput" name="totalAmount" value="">
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
                        <%for (Item i : cart.getItems().values()) {%>
                        <tr>
                            <td>
                                <div>
                                    <%String pathImage = ImageService.getInstance().pathImageOnly(i.getProduct().getId());%>
                                    <img class="product-img" src="<%=request.getContextPath()%>/<%=pathImage%>"
                                         alt="sanpham">
                                    <span class="product-quantity"><%=i.getQuantity()%></span>
                                </div>
                            </td>
                            <td>
                                <div>
                                    <h6><%=i.getProduct().getName()%>
                                    </h6>

                                </div>
                            </td>
                            <%totalMoney += (i.getPrice() * i.getQuantity());%>
                            <td><%=numberFormat.format(i.getPrice() * i.getQuantity())%>
                            </td>
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
                                <td class="text-end pe-3"><%=numberFormat.format(totalMoney)%>
                                </td>
                            </tr>
                            <tr>
                                <th class="text-start fw-medium">
                                    Phí vận chuyển
                                </th>
                                <td id="shippingFeeResult" class="text-end pe-3"></td>
                            </tr>
                            </tbody>
                            <tfoot>
                            <tr>
                                <th class="text-start fs-5 fw-medium">
                                <span>
                                    Tổng cộng
                                </span>
                                </th>
                                <td id="totalAmount" class="text-end pe-3 fs-4">

                                <span>
                                   <%=numberFormat.format(totalMoney)%>
                                </span>

                                </td>
                            </tr>
                            </tfoot>
                        </table>
                    </div>
                    <div class="row py-3 ">
                        <div class="col-5 d-flex align-items-center">
                            <span><a href="/HandMadeStore/payment?backToCart=true"
                                     class="text-decoration-none color-for-text"><strong><</strong> Quay lại giỏ hàng</a></span>
                        </div>


                        <div class="col-7 text-end">
                            <button type="button" id="placeOrderBtn" class="btn btn-primary  color-for-bg">Đặt Hàng
                            </button>
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
<input type="hidden" id="paymentStartTime" value="<%=paymentStartTime%>">
<input type="hidden" id="timeCounter" value="<%=timeCounter%>">
<div id="countdownTest" class="fs-4 fw-bold text-danger"></div>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    $(document).ready(function () {
        const startMillis = parseInt($('#paymentStartTime').val());
        const countDownEl = document.getElementById('count-down');
        const countdownTime = 1 * 60 * 1000; // 2 phút = 120000 ms
        const endTime = startMillis + countdownTime;
        function updateCountdown() {
            const now = Date.now();
            if(endTime > now){
                const timeLeft = endTime - now;

                if (timeLeft > 0) {
                    const minutes = Math.floor(timeLeft / 1000 / 60);
                    const seconds = Math.floor((timeLeft / 1000) % 60);
                    console.log("m " + minutes + " s " + seconds)
                    $('#count-down').html(`${minutes} phút ${seconds} giây`);
                } else {
                    console.log("Countdown topped");
                    countDownEl.style.backgroundColor = '#8b8b8b'
                    Swal.fire({
                        title: "Đã hết thời gian!",
                        timer: 5000,
                        timerProgressBar: true,
                        allowOutsideClick: false,
                        allowEscapeKey: false,
                        didOpen: () => {
                            Swal.showLoading();
                        }
                    }).then(() => {
                        window.location.href = "/HandMadeStore/payment?backToCart=true"
                    })
                    clearInterval(countdownInterval);
                }
            }else {
                console.log("Countdown topped");
                countDownEl.style.backgroundColor = '#8b8b8b'
                Swal.fire({
                    title: "Đã hết thời gian!",
                    timer: 5000,
                    timerProgressBar: true,
                    allowOutsideClick: false,
                    allowEscapeKey: false,
                    didOpen: () => {
                        Swal.showLoading();
                    }
                }).then(() => {
                    window.location.href = "/HandMadeStore/payment?backToCart=true"
                })
                clearInterval(countdownInterval);
            }
        }

        const countdownInterval = setInterval(updateCountdown, 1000);
        updateCountdown(); // Cập nhật lần đầu tiên ngay khi trang được tải
    });

    //// Format address cho order, tạo 3 biến
    var provinceAddress = "";
    var districtAddress = "";
    var wardAddress = "";


    // Gắn sự kiện input cho ô nhập địa chỉ


    $("#address").on("input", function () {
        updateFormattedAddress();
    });

    function updateFormattedAddress() {
        // var provinceAddress = $("#provinceDropdown option:selected").text();
        // var district = $("#districtDropdown option:selected").text();
        // var ward = $("#wardDropdown option:selected").text();
        var address = $("#address").val();
        var formatted = "";

        if (wardAddress === "" || districtAddress === "" || provinceAddress === "" || address === "") {
            formatted = "";
        } else {
            formatted = address + wardAddress + districtAddress + provinceAddress;
        }
        console.log(formatted)
        document.getElementById('formattedAddress').value = formatted;
    }


    //      LẤY TỈNH THÀNH.
    $(document).ready(function () {
        // tinh phi van chuyen

        function calculateFeeShip(wardCode, districtId) {
            $.ajax({
                type: "GET",
                url: "/HandMadeStore/shippingFee",
                data: {
                    tempPrice: <%=totalMoney%>,
                    wardCode: wardCode,
                    districtId: districtId,
                    totalWeight: 1000
                },
                dataType: "json",
                success: function (response) {
                    var shippingFee = response.data.total + 25000;
                    var totalMoney = <%=totalMoney%>;
                    var totalAmount = totalMoney + shippingFee;
                    // Lưu giá trị vào 2 trường input :
                    $('#shippingFeeInput').val(shippingFee);
                    $('#totalAmountInput').val(totalAmount);


                    // Định dạng thành tiền Việt Nam đồng
                    var formattedShippingFee = formatCurrency(shippingFee);
                    var formattedTotalAmount = formatCurrency(totalAmount);


                    //hien thi shipping fee
                    $('#shippingFeeResult').text(formattedShippingFee);
                    $('#totalAmount').text(formattedTotalAmount);
                }, error: function (xhr, status, error) {
                    console.log("Failed fetch ship: ", error);
                    alert("Không tính được phí ship.");
                }
            })
        }

        // dich vu van chuyen

        function fetchService(districtId) {
            $.ajax({
                type: "GET",
                url: "/HandMadeStore/service-api",
                data: {
                    districtId: districtId
                },
                dataType: "json",
                success: function (response) {
                    console.log(response);
                    $("#serviceDropdown").empty();

                    var serviceDropdown = $("#serviceDropdown");
                    response.forEach(function (service) {
                            var option = $("<option>").val(service.serviceId).text(service.serviceName);
                            serviceDropdown.append(option);
                        }
                    );

                }, error: function (xhr, status, error) {
                    alert("Không lấy đươợc dịch vụ vận chuyển.");
                }
            })

        }


        //lấy xã, thị trấn.
        function fetchWards(districtId) {
            $.ajax({
                type: "GET",
                url: "/HandMadeStore/ward-api",
                data: {
                    districtId: districtId
                },
                dataType: "json",
                success: function (response) {
                    console.log(response);
                    $("#wardDropdown").empty();

                    var wardDropdown = $("#wardDropdown");
                    response.forEach(function (ward) {
                            var option = $("<option>").val(ward.wardId).text(ward.wardName);
                            wardDropdown.append(option);
                        }
                    );

                    //change cho drowdown ward
                    wardDropdown.off('change').on('change', function () {
                        var wardCode = $(this).val();
                        wardAddress = ", " + $("#wardDropdown option:selected").text();
                        calculateFeeShip(wardCode, districtId);
                        updateFormattedAddress();
                    })

                }, error: function (xhr, status, error) {
                    alert("Không lấy đươợc danh sách xã, thị trấn.");
                }
            })

        }


        // Lấy quận huyện.
        function fetchDistricts(provinceId) {
            $.ajax({
                type: "GET",
                url: "/HandMadeStore/district-api",
                data: {
                    provinceId: provinceId
                },
                dataType: "json",
                success: function (response) {
                    console.log(response);
                    $("#districtDropdown").empty();
                    $("#wardDropdown").empty();

                    var districtDropdown = $("#districtDropdown");
                    response.forEach(function (district) {
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
            if (selectedProvinceId) {
                fetchDistricts(selectedProvinceId);
            } else {
                $("#districtDropdown").empty();
            }
            provinceAddress = ", " + $("#provinceDropdown option:selected").text();
            updateFormattedAddress();
        })

        // Sự kiện select district cho ward
        $("#districtDropdown").change(function () {
            var selectedDistrictId = $(this).val(); // lay id district duoc chon
            if (selectedDistrictId) {
                fetchWards(selectedDistrictId);
            } else {
                $("#wardDropdown").empty();
            }
            districtAddress = ", " + $("#districtDropdown option:selected").text();
            updateFormattedAddress();
        })

        // Sự kiện select district cho service
        $("#districtDropdown").change(function () {
            var selectedDistrictId = $(this).val(); // lay id district duoc chon
            if (selectedDistrictId) {
                fetchService(selectedDistrictId);
            } else {
                $("#serviceDropdown").empty();
            }
        })


        $.ajax({
            type: "GET",
            url: "/HandMadeStore/province-api",
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


        $("#placeOrderBtn").on("click", function () {
            var namePay = document.getElementById("name").value;
            var phonePay = document.getElementById("phone_number").value;
            var formattedAddress = document.getElementById("formattedAddress").value;
            var shippingFee = document.getElementById("shippingFeeInput").value;
            var totalAmount = document.getElementById("totalAmountInput").value;

            console.log(totalAmount)

            $.ajax({
                type: "POST",
                url: "/HandMadeStore/payment", // Đường dẫn đến servlet của bạn
                data: {
                    namePay: namePay,
                    phonePay: phonePay,
                    formattedAddress: formattedAddress,
                    shippingFee: shippingFee,
                    totalAmount: totalAmount
                },
                dataType: "json",
                success: function (response) {
                    if (response.success) {
                        Swal.fire({
                            title: "Cảm ơn bạn, đơn hàng đã được tạo!",
                            width: 600,
                            padding: "3em",
                            color: "rgba(5,131,39,0.98)",
                            background: "#fff url(/images/trees.png)",
                            backdrop: `
                                                       rgba(0,0,123,0.4)
                                                      url("/images/nyan-cat.gif")
                                                          left top
                                                       no-repeat
                        `,
                            showConfirmButton: false,
                            timer: 4000
                        }).then(function () {
                            window.location.href = "../../views/MainPage/view_mainpage/mainpage.jsp"; // Chuyển hướng về trang chủ
                        });
                    } else {
                        console.log("Error:", response.message)
                        Swal.fire({
                            icon: 'error',
                            title: 'Thời gian đã qua!',
                            text: response.message,
                            showConfirmButton: true
                        });
                    }
                },
                error: function (xhr, status, error) {
                    // Xử lý lỗi nếu có
                    Swal.fire({
                        icon: 'error',
                        title: 'Vui lòng điền đầy đủ thông tin.',
                        text: 'Bạn chỉ có thể bỏ trống trường ghi chú.',
                        showConfirmButton: true
                    });
                }
            });


        })


    })

    function formatCurrency(amount) {
        return new Intl.NumberFormat('vi-VN', {style: 'currency', currency: 'VND'}).format(amount);
    }


    //       function sendDataToServlet() {
    //           var namePay = document.getElementById("namePay").value;
    //           var phonePay = document.getElementById("phonePay").value;
    //           var formattedAddress = document.getElementById("formattedAddress").value;
    //           var shippingFee = document.getElementById("shippingFeeInput").value;
    //           var totalAmount = document.getElementById("totalAmountInput").value;
    //
    //           console.log("click button");
    //
    //           $.ajax({
    //               type: "POST",
    //               url: "HandMadeStore/payment", // Đường dẫn đến servlet của bạn
    //               data: {
    //                   namePay: namePay,
    //                   phonePay: phonePay,
    //                   formattedAddress: formattedAddress,
    //                   shippingFee: shippingFee,
    //                   totalAmount: totalAmount
    //               },
    //               dataType: "json",
    //               success: function(response) {
    //                   if(response.success){
    //                       alert("Thanh cong");
    // //                   Swal.fire({
    //                       //                       title: "Cảm ơn bạn, đơn hàng đã được tạo!",
    //                       //                       width: 600,
    //                       //                       padding: "3em",
    //                       //                       color: "rgba(123,255,2,0.45)",
    //                       //                       background: "#fff url(/images/trees.png)",
    //                       //                       backdrop: `
    //                       //                                rgba(0,0,123,0.4)
    //                       //                               url("/images/nyan-cat.gif")
    //                       //                                   left top
    //                       //                                no-repeat
    //                       // `                     ,
    //                       //                       showConfirmButton: false,
    //                       //                       timer: 2000
    //                       //                   }).then(function () {
    //                       //                       window.location.href = "/views/MainPage/view_mainpage/mainpage.jsp"; // Chuyển hướng về trang chủ
    //                       //                   });
    //                                         }
    //                   else {
    //                       console.log("Error:", response.message)
    //                       Swal.fire({
    //                           icon: 'error',
    //                           title: 'Vui lòng kiểm tra các trường dữ liệu!',
    //                           text: response.message,
    //                           showConfirmButton: true
    //                       });
    //                   }
    //               },
    //               error: function(xhr, status, error) {
    //                   // Xử lý lỗi nếu có
    //                   Swal.fire({
    //                       icon: 'error',
    //                       title: 'Đặt hàng không thành công!',
    //                       text: 'Vui lòng thử lại sau.',
    //                       showConfirmButton: true
    //                   });
    //               }
    //           });
    //       }


</script>

<script src="../PaymentPage/js/paymentpage.js"></script>
<!--Bộ select tỉnh thành-->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"
        integrity="sha512-894YE6QWD5I59HgZOGReFYm4dnWc1Qt5NtvYSaNcOP+u1T9qYdvdihz0PPSiiqn/+/3e7Jo4EaG7TubfWGUrMQ=="
        crossorigin="anonymous" referrerpolicy="no-referrer"></script>


</body>
</html>

