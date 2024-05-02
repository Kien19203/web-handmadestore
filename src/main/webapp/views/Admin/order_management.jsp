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
                <div class="col-lg-6 col-sm-12">
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
                <button type="submit" name="submit_filter" value="all" class="btn btn-secondary mx-2 col-lg-1 col-sm-1">Tất cả đơn
                    hàng
                </button>
                <button type="submit" name="submit_filter" value="waitConfirmOrders" class="btn btn-warning mx-2 col-sm-1">
                    Đơn
                    hàng cần xác nhận
                </button>
                <button type="submit" name="submit_filter" value="deliveringOrders" class="btn btn-primary mx-2 col-sm-1">Đơn
                    hàng đang giao
                </button>
                <button type="submit" name="submit_filter" value="canceledOrders" class="btn btn-danger mx-2 col-sm-1">Đơn
                    hàng
                    đã hủy
                </button>
                <button type="submit" name="submit_filter" value="succcessfulOrders" class="btn btn-success mx-2 col-sm-1">
                    Đơn
                    hàng thành công
                </button>
            </div>
            <div class="table-wrapper-scroll-y my-custom-scrollbar">
                <table class="table table-striped table-hover">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap">Mã Đơn Hàng</th>
                        <th class="text-nowrap">Mã Khách Hàng</th>
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
                        <td><%=o.getId()%>
                        </td>
                        <td><%=customer.getId()%>
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
                                <%!
                                    String backgroundColor = "";
                                    String sttvalue = "";
                                %>
                                <%
                                    if (o.isDeliveringOrder()) {
                                        backgroundColor = "#0171d3";
                                        sttvalue = "Đang giao";
                                    } else if (o.isWaitConfirmOrder()) {
                                        backgroundColor = "#ffcc00";
                                        sttvalue = "Cần xác nhận";
                                    } else if (o.isCanceledOrder()) {
                                        backgroundColor = "#ff0000";
                                        sttvalue = "Đã hủy";
                                    } else if (o.isSucccessfulOrder()) {
                                        backgroundColor = "#4d8a54";
                                        sttvalue = "Thành công";
                                    }%>
                                style="background-color: <%=backgroundColor%>; color: #ffffff"
                        ><%=sttvalue%>
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
                                    <strong><%=currentOrder.getStatus()%>
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
            <%--                lý do hủy -> mail khách--%>
            <button class="btn btn-danger mx-2" onclick="showCancelBox()">
                Hủy bỏ đơn hàng
            </button>
            <div id="loadingConfirmBox" style="display:none;">
                <span class="spinner-border spinner-border-sm" role="status"
                      aria-hidden="true"></span>
                Đang xác nhận đơn hàng
            </div>
            <a class="btn btn-success mx-2" id="confirmButton" onclick="loadingConfirm()"
               href="<%=request.getContextPath()%>/admin/order?action=confirm&currentOrderId=<%=currentOrder.getId()%>&currentFilter=<%=currentFilter%>">
                Xác nhận đơn hàng</a>
        </div>
        <%} else if (currentOrder.isDeliveringOrder()) {%>
        <div class="text-end">
            <%--                lý do hủy -> mail khách--%>
            <button class="btn btn-danger mx-2" onclick="showCancelBox()">
                Hủy bỏ đơn hàng
            </button>
            <a class="btn btn-success mx-2" title="Tạm thời dùng cách thủ công thay vì có API!"
               href="<%=request.getContextPath()%>/admin/order?action=delivered&currentOrderId=<%=currentOrder.getId()%>&currentFilter=<%=currentFilter%>">
                Đã giao</a>
        </div>
        <%}%>
    </div>
    <%--        cancelBox--%>

    <div id="cancelBox" style="display: none">
        <form action="<%=request.getContextPath()%>/admin/order" method="post">
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
                <input type="hidden" name="action" value="cancel">
                <input type="hidden" name="currentOrderId" value="<%=currentOrder.getId()%>">
                <input type="hidden" name="currentFilter" value="<%=currentFilter%>">
                <button type="submit" class="btn btn-danger mx-2" id="cancelButton" onclick="loadingCancel()">
                    Xác nhận hủy bỏ
                </button>
                <button class="btn btn-success mx-2" onclick="hideCancelBox()">
                    Thoát
                </button>
            </div>
        </form>
    </div>
    <%}%>

</div>
<script>
    function submit_showOrderDetails(event, clickedElement) {
        event.preventDefault();
        var orderId = clickedElement.id;
        //set cho hide input
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
        // Hiển thị thẻ loading
        document.getElementById('loadingCancelBox').style.display = 'block';
        // Thực hiện công việc cần thiết ở đây, có thể làm gì đó mất vài giây

        // Sau khi hoàn thành công việc, ẩn thẻ loading
        setTimeout(function () {
            document.getElementById('loadingCancelBox').style.display = 'none';
        }, 5000); // Đặt thời gian (2 giây) tùy thuộc vào công việc cần thực hiện
    };

    function loadingConfirm() {
        document.getElementById("confirmButton").style.display = "none";
        // Hiển thị thẻ loading
        document.getElementById('loadingConfirmBox').style.display = 'block';
        // Thực hiện công việc cần thiết ở đây, có thể làm gì đó mất vài giây

        // Sau khi hoàn thành công việc, ẩn thẻ loading
        setTimeout(function () {
            document.getElementById('loadingConfirmBox').style.display = 'none';
        }, 5000); // Đặt thời gian (2 giây) tùy thuộc vào công việc cần thực hiện
    };

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