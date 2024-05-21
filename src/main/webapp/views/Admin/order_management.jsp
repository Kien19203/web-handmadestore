<%@ page import="model.bean.Order" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.bean.User" %>
<%@ page import="model.bean.OrderDetail" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.io.StringReader" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>

<%String currentFilter = (String) request.getAttribute("currentFilter");%>
<%
    System.out.println("ok: " + currentFilter);%>
<%String currentFindText = (String) request.getAttribute("currentFindText");%>
<%
    List<Order> orders = null;
    if (currentFilter != null) {
        if (currentFilter.equals("all")) {
            orders = OrderService.getInstance().getAllOrder();
        } else if (currentFilter.equals("waitConfirmOrders")) {
            orders = OrderService.getInstance().getWaitConfirmOrders();
        } else if (currentFilter.equals("preparingOrders")) {
            orders = OrderService.getInstance().getPreparingOrders();
        } else if (currentFilter.equals("deliveringOrders")) {
            orders = OrderService.getInstance().getDeliveringOrders();
        } else if (currentFilter.equals("canceledOrders")) {
            orders = OrderService.getInstance().getCanceledOrders();
        } else if (currentFilter.equals("succcessfulOrders")) {
            orders = OrderService.getInstance().getSucccessfulOrders();
        } else if (currentFilter.startsWith("orderId_rdo")) {
            StringTokenizer st = new StringTokenizer(currentFilter, ":");
            st.nextToken();
            orders = new ArrayList<>();
            orders.add(OrderService.getInstance().getOrderById(st.nextToken()));
        } else if (currentFilter.startsWith("customerId_rdo")) {
            StringTokenizer st = new StringTokenizer(currentFilter, ":");
            st.nextToken();
            orders = OrderService.getInstance().getOrderByCustomerId(st.nextToken());
        } else if (currentFilter.startsWith("customerName_rdo")) {
            StringTokenizer st = new StringTokenizer(currentFilter, ":");
            st.nextToken();
            orders = OrderService.getInstance().getOrderByCustomerNamePart(st.nextToken());
        } else {
            currentFilter = "all";
            orders = OrderService.getInstance().getAllOrder();
        }
    } else {
        currentFilter = "all";
        orders = OrderService.getInstance().getAllOrder();
    }
%>
<%
    String currentOrderId = (String) request.getAttribute("currentOrderId");
    Order currentOrder = OrderService.getInstance().getOrderById(currentOrderId);
    User currentOrderCustomer = (currentOrder != null) ? UserService.getInstance().getUserById(currentOrder.getUserId() + "") : null;
%>
<%System.out.println(currentFilter + "  -  " + currentFindText);%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý đơn hàng</title>
    <!--https://datatables.net/download/-->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <!--https://www.bootstrapcdn.com/-->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css"
          integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <script src="https://cdn.datatables.net/v/bs4-4.6.0/jq-3.7.0/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/4.6.0/js/bootstrap.min.js"></script>
    <style>
        #showBox, #cancelBox {
            position: fixed;
            top: 40%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            z-index: 1021;
            background-color: #afe2ea;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5);
        }

        .my-custom-scrollbar {
            position: relative;
            height: 60%;
            overflow: auto;
        }

        .table-wrapper-scroll-y {
            display: block;
        }

        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 20%;
            left: 50%;
            transform: translateX(-50%);
            z-index: 9999;
        }

        #data th:nth-child(4),
        #data td:nth-child(4) {
            width: 20%; /* Điều chỉnh chiều rộng ở đây */
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2">
    <form action="<%=request.getContextPath()%>/admin/order" method="post" id="orderForm">
        <div class="customer_list  mt-5 ">
            <%--            form--%>
            <div class="row d-flex">
                <div class="col-lg-5 col-sm-12">
                    <div class="d-flex">
                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="orderId_rdo"
                                   value="orderId_rdo"
                                   checked
                            >
                            <label class="form-check-label" for="orderId_rdo">
                                Tìm theo mã đơn hàng
                            </label>
                        </div>
                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="customerId_rdo"
                                   value="customerId_rdo"
                                <%if(currentFilter!=null && currentFilter.startsWith("customerId_rdo")){%>
                                   checked
                                <%}%>
                            >
                            <label class="form-check-label" for="customerId_rdo">
                                Tìm theo mã khách hàng
                            </label>
                        </div>

                        <div class="form-check mx-1">
                            <input class="form-check-input" type="radio" name="choiceFindType" id="customerName_rdo"
                                   value="customerName_rdo"
                                <%if(currentFilter!=null && currentFilter.startsWith("customerName_rdo")){%>
                                   checked
                                <%}%>
                            >
                            <label class="form-check-label" for="customerName_rdo">
                                Tìm tên khách hàng
                            </label>
                        </div>
                    </div>
                    <div class="d-flex">
                        <div class="input-group">
                            <input type="text" class="form-control 1" name="findText"
                                   value="<%=currentFindText!=null?currentFindText:""%>">
                            <div class="input-group-append">
                                <button
                                        class="btn btn-outline-secondary" type="submit" name="submit_filter"
                                        value="submit_find">Tìm
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
                <button type="submit" name="submit_filter" value="all" class="btn btn-secondary mx-2 col-lg-1 col-sm-1">
                    Tất cả đơn
                    hàng
                </button>
                <button type="submit" name="submit_filter" value="waitConfirmOrders"
                        class="btn btn-warning mx-2 col-sm-1">
                    Đơn
                    hàng cần xác nhận
                </button>
                <button type="submit" name="submit_filter" value="preparingOrders"
                        class="btn mx-2 col-sm-1" style="background-color: cadetblue">
                    Đơn hàng đang đóng gói
                </button>
                <button type="submit" name="submit_filter" value="deliveringOrders"
                        class="btn btn-primary mx-2 col-sm-1">Đơn
                    hàng đang giao
                </button>
                <button type="submit" name="submit_filter" value="canceledOrders" class="btn btn-danger mx-2 col-sm-1">
                    Đơn
                    hàng
                    đã hủy
                </button>
                <button type="submit" name="submit_filter" value="succcessfulOrders"
                        class="btn btn-success mx-2 col-sm-1">
                    Đơn
                    hàng thành công
                </button>
            </div>
            <div class="table-wrapper-scroll-y my-custom-scrollbar d-flex justify-content-center">
                <table id="data" class="table table-striped table-hover">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap">Mã ĐH</th>
                        <th class="text-nowrap">Mã KH</th>
                        <th class="text-nowrap">Tên Khách Hàng</th>
                        <th class="text-nowrap">Địa Chỉ Giao</th>
                        <th class="text-nowrap">Ngày Đặt Hàng</th>
                        <th class="text-nowrap">Tổng Tiền Hóa Đơn</th>
                        <th class="text-nowrap">Phí Vận Chuyển</th>
                        <th class="text-nowrap">Tổng Hóa Đơn</th>
                        <th class="text-nowrap">Trạng Thái</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Order o : orders) {
                            if (o != null) {
                                User customer = UserService.getInstance().getUserById(o.getUserId() + "");
                    %>
                    <tr class="text-center" style=" cursor: pointer;"
                        onclick="submit_showOrderDetails(event,this)"
                        id="<%=o.getId()%>"
                    >
                        <td class="text-center"><%=o.getId()%>
                        </td>
                        <td class="text-center"><%=customer.getId()%>
                        </td>
                        <td class="text-start"><%=customer.getName()%>
                        </td>
                        <td class="text-start"><%=o.getAddress()%>
                        </td>
                        <td><%=o.getOrderDate()%>
                        </td>
                        <td><%=numberFormat.format(o.getTotalPrice())%>
                        </td>
                        <td><%=numberFormat.format(o.getShippingFee())%>
                        </td>
                        <td><%=numberFormat.format(o.getTotalPrice() + o.getShippingFee())%>
                        </td>
                        <td
                                style="background-color: <%=o.getStatusAsColor()%>; color: #ffffff"
                        ><%=o.getStatusAsName()%>
                        </td>
                    </tr>
                    <%
                            }
                        }
                    %>
                    </tbody>
                </table>
            </div>
        </div>
        <input type="hidden" id="currentOrderId" name="currentOrderId">
        <input type="hidden" id="currentFilter" name="currentFilter" value="<%=currentFilter%>">
    </form>
    <%if (currentOrder != null) {%>
    <%--        showbox--%>
    <div id="showBox" class="w-75 p-3 rounded">
        <div class="fw-bold text-start" style="font-size: 30px; color: #0dcaf0">
            <button id="back_btn" onclick="hideOrderBox()"><i
                    class="fa-solid fa-arrow-left" style="color: #183153"></i>
            </button>
            Thông tin đơn hàng
        </div>
        <div class="m-3">
            <div class="row">
                <div class="col-4">
                    <div class="row">
                        Mã đơn hàng:
                        <strong class="w-auto"><%=currentOrder.getId()%>
                        </strong>
                    </div>

                    <div class="row">
                        Địa chỉ giao:
                        <strong class="w-auto"><%=currentOrder.getAddress()%>
                        </strong>
                    </div>

                    <div class="row">
                        Tên người nhận:
                        <strong class="w-auto"><%=currentOrder.getConsigneeName()%>
                        </strong>
                    </div>
                    <div class="row">
                        Số điện thoại người nhận:
                        <strong class="w-auto"><%=currentOrder.getConsigneePhoneNumber()%>
                        </strong>
                    </div>
                    <div class="row">
                        Ngày đặt hàng:
                        <strong class="w-auto"><%=currentOrder.getOrderDate()%>
                        </strong>
                    </div>
                    <div class="row">
                        Mã khách hàng:
                        <strong class="w-auto"><%=currentOrder.getUserId()%>
                        </strong>
                    </div>
                    <div class="row">
                        Tên khách hàng:
                        <strong class="w-auto"><%=currentOrderCustomer.getName()%>
                        </strong>
                    </div>
                    <div class="row">
                        SĐT:
                        <strong class="w-auto"><%=currentOrderCustomer.getPhoneNumber()%>
                        </strong>
                    </div>
                    <div class="row">
                        Email khách hàng:
                        <strong class="w-auto"><%=currentOrderCustomer.getEmail()%>
                        </strong>
                    </div>
                    <div class="row">
                        Ghi chú:
                        <strong class="w-auto"><%=(currentOrder.getNote() != null) ? currentOrder.getNote() : ""%>
                        </strong>
                    </div>
                </div>
                <div class="col-8">
                    <div class="row">
                        <table class="table">
                            <thead>
                            <tr>
                                <th scope="col">Mã sản phẩm</th>
                                <th scope="col">Tên sản phẩm</th>
                                <th scope="col">Đơn giá</th>
                                <th scope="col">Số lượng mua</th>
                                <th scope="col">Thành tiền</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <%!Product p;%>
                            <%
                                for (OrderDetail orderDetail : OrderService.getInstance().getOrderDetailsByOrderId(currentOrder.getId() + "")) {
                                    p = ProductService.getInstance().getProductById(orderDetail.getProductId() + "");
                            %>

                            <tr>
                                <td><%=p.getId()%>
                                </td>
                                <td><%=p.getName()%>
                                </td>
                                <td>
                                    <%if (orderDetail.getSellingPrice() != orderDetail.getFinalSellingPrice()) {%>
                                    <del><%=orderDetail.getSellingPrice()%>
                                    </del>
                                    <%}%>
                                    <%=numberFormat.format(orderDetail.getFinalSellingPrice())%>
                                </td>
                                <td><%=orderDetail.getQuantity()%>
                                </td>
                                <td><%=numberFormat.format(orderDetail.getQuantity() * orderDetail.getFinalSellingPrice())%>
                                </td>
                                <td>
                                    <%!int star = 0;%>
                                    <%
                                        star = ProductService.getInstance().getNumberRateStarsByUser(p.getId(), currentOrderCustomer.getId());
                                        if (star > 0 && currentOrder.isSucccessfulOrder()) {
                                    %>
                                    <a href="<%=request.getContextPath()%>/product-detail?id=<%=p.getId()%>"
                                       target="_blank"
                                       style="color: #ffcc00;text-decoration: none;">
                                        <%=star%>
                                        <i class="fa-regular fa-star" style="color: #ffcc00"></i>
                                    </a>
                                    <%}%>
                                </td>
                            </tr>
                            <%}%>
                            </tbody>
                        </table>
                    </div>
                    <div class="row text-end">
                        <div>
                            <div class="row">
                                <div class="col-10">Tiền hóa đơn:</div>
                                <div class="col-2">
                                    <strong><%=numberFormat.format(OrderService.getInstance().getExactlyTotalPriceNoShippingFee(currentOrder.getId() + ""))%>
                                    </strong>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-10"> Tiền vận chuyển:</div>
                                <div class="col-2">
                                    <strong><%=numberFormat.format(currentOrder.getShippingFee())%>
                                    </strong>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-10">Tổng tiền:</div>
                                <div class="col-2">
                                    <strong><%=numberFormat.format(currentOrder.getTotalPrice())%>
                                    </strong>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-10">Trạng thái:</div>
                                <div class="col-2" style="background-color: wheat">
                                    <strong>
                                        <p id="orderStatus">
                                            <%=currentOrder.getStatusAsName()%>
                                        </p>
                                    </strong>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%if (currentOrder.isWaitConfirmOrder()) {%>
        <div class="text-end">
            <button id="btn_cancel" type="button" class="btn btn-danger mx-2" onclick="showCancelBox()">
                Hủy bỏ đơn hàng
            </button>
            <div id="loadingConfirmBox" style="display:none;">
                <span class="spinner-border spinner-border-sm" role="status"
                      aria-hidden="true"></span>
                Đang xác nhận đơn hàng
            </div>
            <button type="button" class="btn btn-success mx-2" id="confirmButton"
                    onclick="confirmOrder(<%=currentOrder.getId()%>)">
                Xác nhận đơn hàng
            </button>
        </div>
        <%} else if (currentOrder.isDeliveringOrder()) {%>
        <div class="text-end">
            <button class="btn btn-danger mx-2" onclick="showCancelBox()">
                Hủy bỏ đơn hàng
            </button>
            <button class="btn btn-success mx-2"
                    onclick="deliveredOrder(<%=currentOrder.getId()%>)">
                Đã giao
            </button>
        </div>
        <%}%>
    </div>
    <%--        cancelBox--%>
    <div id="cancelBox" style="display: none">
        <div style="font-size: 20px"><i class="fa-solid fa-triangle-exclamation"></i></div>
        <div>Bạn có chắc chắn muốn hủy bỏ đơn hàng <strong>#<%=currentOrder.getId()%>
        </strong>?
        </div>
        <div>
            <div class="form-group">
                <label for="exampleFormControlTextarea1">Lý do hủy đơn hàng:</label>
                <textarea class="form-control" id="exampleFormControlTextarea1" rows="3"
                          name="cancelReason"></textarea>
            </div>
        </div>
        <div class="d-flex justify-content-end">
            <div id="loadingCancelBox" style="display:none;">
                <span class="spinner-border spinner-border-sm" role="status"
                      aria-hidden="true"></span>
                Đang hủy bỏ đơn hàng
            </div>
            <button type="button" class="btn btn-danger mx-2" id="cancelButton"
                    onclick="cancelOrder(<%=currentOrder.getId()%>)">
                Xác nhận hủy bỏ
            </button>
            <button type="button" class="btn btn-success mx-2" onclick="hideCancelBox()">
                Thoát
            </button>
        </div>
    </div>
    <%}%>
    <input type="hidden" id="currentPageNumber" name="currentPageNumber"
           value="<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>">
</div>
<script>
    $(document).ready(function () {
        $(document).ready(function () {
            var table = $('#data').DataTable({
                "searching": false, // Không có tính năng tìm kiếm
                "lengthChange": false, // Không cho phép thay đổi số lượng bản ghi trên mỗi trang
                "pageLength": 10,
                "displayStart": document.getElementById("currentPageNumber").value
            });

            function getCurrentPage() {
                let pageInfo = table.page.info();
                document.getElementById("currentPageNumber").value = pageInfo.page + 1;
            }
        });

    })

    function deliveredOrder(orderId) {
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/confirmOrder", // Điều chỉnh URL tới Servlet của bạn
            data: {
                action: "deliveredOrder",
                orderId: orderId
            },
            // Truyền dữ liệu cần thiết cho Servlet
            success: function (response) {
                document.getElementById("orderStatus").innerHTML = 'Thành công'
            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function confirmOrder(orderId) {
        loadingConfirm();
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/confirmOrder", // Điều chỉnh URL tới Servlet của bạn
            data: {
                action: "confirmOrder",
                orderId: orderId
            },
            // Truyền dữ liệu cần thiết cho Servlet
            success: function (response) {
                document.getElementById('loadingConfirmBox').style.display = 'none';
                document.getElementById("orderStatus").innerHTML = 'Đang giao'

                let parentDocument = window.parent.document;
                let waitConfirmOrdersNumber = parentDocument.getElementById('waitConfirmOrdersNumber');
                waitConfirmOrdersNumber.innerHTML =  response;
                //     xóa dòng

            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function cancelOrder(orderId) {
        loadingCancel();
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/confirmOrder",
            data: {
                action: "cancelOrder",
                orderId: orderId
            },
            success: function (response) {
                document.getElementById('loadingCancelBox').style.display = 'none';
                document.getElementById("orderStatus").innerHTML = 'Đã hủy'
                let parentDocument = window.parent.document;
                let waitConfirmOrdersNumber = parentDocument.getElementById('waitConfirmOrdersNumber');
                waitConfirmOrdersNumber.innerHTML =  response;
            },
            error: function () {
                alert("Error deleting user!");
            }
        })
    }

    function submit_showOrderDetails(event, clickedElement) {
        var rowIndex = 0;
        var row = clickedElement;
        while ((row = row.previousElementSibling) != null) {
            rowIndex++;
        }
        // alert("Chỉ số hàng: " + rowIndex);
        event.preventDefault();
        var orderId = clickedElement.id;
        document.getElementById("currentOrderId").value = orderId;
        document.getElementById("orderForm").submit();
    }


    function hideOrderBox() {
        document.getElementById("showBox").style.display = "none";
    }

    function showCancelBox() {
        document.getElementById("cancelBox").style.display = "block";
    }

    function hideCancelBox() {
        document.getElementById("cancelBox").style.display = "none";
    }

    function loadingCancel() {
        document.getElementById("cancelButton").style.display = "none";
        document.getElementById('loadingCancelBox').style.display = 'block';
    };

    function loadingConfirm() {
        document.getElementById("confirmButton").style.display = "none";
        document.getElementById('loadingConfirmBox').style.display = 'block';
    };

    function deleteRow(rowIndex) {
        var table = document.getElementById("data");
        if (rowIndex >= 0 && rowIndex < table.rows.length) {
            table.deleteRow(rowIndex);
        } else {
            console.error("Chỉ số hàng không hợp lệ.");
        }
    }
</script>
</body>
<%
    } else {
        response
                .
                sendRedirect
                        (
                                request
                                        .
                                        getContextPath
                                                (
                                                )
                                        +
                                        "/login"
                        )
        ;
    }%>
</html>