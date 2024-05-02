<%@ page import="model.bean.User" %>
<%@ page import="model.bean.Order" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="java.util.List" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.bean.OrderDetail" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.RoleService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Title</title>
    <style>
        .my-custom-scrollbar {
            position: relative;
            height: 30%;
            overflow: auto;
        }

        .table-wrapper-scroll-y {
            display: block;
        }
    </style>
</head>
<%
    User user = (User) (request.getSession().getAttribute("auth"));
    if (user != null) {
%>
<%
    List<Order> orders = OrderService.getInstance().getOrderByCustomerId(user.getId() + "");%>
<body>
<div class="container p-4 rounded">
    <div class="fw-bold text-start" style="font-size: 30px; color: #0dcaf0">
        <%if (RoleService.getInstance().checkRole(user).equals("admin")) {%>
        <a href="<%=request.getContextPath()%>/admin">
                <%} else {%>
            <a href="<%=request.getContextPath()%>/views/MainPage/view_mainpage/mainpage.jsp">
                <%}%>
                <i
                        class="fa-solid fa-arrow-left" style="color: #183153"></i>
            </a>
    </div>
    <form action="<%=request.getContextPath()%>/changeUserInfo" method="post">
        <div class="input-group d-flex justify-content-center">
            <div class="w-50">
                <div class="my-5">
                    <label for="input_name">Tên tài khoản: </label>
                    <input type="text" class="form-control"
                           disabled
                           id="input_name"
                           name="input_name"
                           value="<%=user.getName()%>">
                    <div class="input-group-append d-flex">
                        <button class="btn btn-outline-warning" type="button"
                                onclick="editName()"
                                id="edit_name"
                        >Thay đổi
                        </button>
                        <button class="btn btn-outline-warning" type="button"
                                onclick="cancelName()"
                                style="display: none"
                                id="cancel_name"
                        >Hủy bỏ
                        </button>
                        <%--                        edit--%>
                        <button class="btn btn-outline-success" type="submit"
                                name="submit"
                                value="change_name"
                                style="display: none"
                                id="save_name"
                        >Lưu thay đổi
                        </button>
                    </div>
                    <%--                    --%>
                    <div class="my-5">
                        <label for="input_name">Số điện thoại: </label>
                        <input type="text" class="form-control"
                               disabled
                               id="input_phone"
                               name="input_phone"
                               value="<%=user.getPhoneNumber()%>">
                        <div class="input-group-append d-flex">
                            <button class="btn btn-outline-warning" type="button"
                                    onclick="editPhone()"
                                    id="edit_phone"
                            >Thay đổi
                            </button>
                            <button class="btn btn-outline-warning" type="button"
                                    onclick="cancelPhone()"
                                    style="display: none"
                                    id="cancel_phone"
                            >Hủy bỏ
                            </button>
                            <%--                        edit--%>
                            <button class="btn btn-outline-success" type="submit"
                                    name="submit"
                                    value="change_phone"
                                    style="display: none"
                                    id="save_phone"
                            >Lưu thay đổi
                            </button>
                        </div>
                    </div>
                    <%!String result = null;%>
                    <% result = (String) request.getAttribute("result");
                        if (result != null) {
                    %>
                    <div class="text-center" style="color: red">
                        <%=result%>
                    </div>
                    <%}%>
                    <div class="my-5 text-end">
                        <a class="text-decoration-none" href="<%=request.getContextPath()%>/forgotpassword">Đặt lại mật
                            khẩu?</a>
                    </div>
                </div>
            </div>
            <%--         --%>
            <div class="table-wrapper-scroll-y my-custom-scrollbar">
                <div style="font-size: 20px; font-weight: bold">Lịch sử đơn hàng</div>
                <table class="table table-striped table-hover">
                    <thead>
                    <tr class="text-center sticky-top">
                        <th class="text-nowrap">Mã Đơn Hàng</th>
                        <th class="text-nowrap">Địa Chỉ Giao</th>
                        <th class="text-nowrap">Ngày Đặt Hàng</th>
                        <th class="text-nowrap">Trạng thái</th>
                        <th class="text-nowrap">Tên người nhận</th>
                        <th class="text-nowrap">SĐT người nhận</th>
                        <th class="text-nowrap">Link sản phẩm - Giá đã mua - số lượng - thành tiền</th>
                        <th class="text-nowrap">Tiền Hóa Đơn</th>
                        <th class="text-nowrap">Phí Vận Chuyển</th>
                        <th class="text-nowrap">Tổng Tiền Hóa Đơn</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        for (Order o : orders) {
                            if (o != null) {
                                User customer = UserService.getInstance().getUserById(o.getUserId() + "");
                    %>
                    <tr class="text-center" style=" cursor: pointer;"
                    >
                        <td><%=o.getId()%>
                        </td>
                        <td class="text-start"><%=o.getAddress()%>
                        </td>
                        <td><%=o.getOrderDate()%>
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
                        <td><%=o.getConsigneeName()%>
                        </td>

                        <td><%=o.getConsigneePhoneNumber()%>
                        </td>

                        <td>
                            <select class="form-select" id="productSelect">
                                <%!Product p;%>
                                <%
                                    for (OrderDetail orderDetail : OrderService.getInstance().getOrderDetailsByOrderId(o.getId()
                                            + "")) {
                                        p = ProductService.getInstance().getProductById(orderDetail.getProductId() + "");
                                %>

                                <option value="<%=p.getId()%>">
                                        <%=p.getName()%>
                                        - <%=orderDetail.getFinalSellingPrice()%>
                                        - <%=orderDetail.getQuantity()%>
                                        - <%=orderDetail.getQuantity() * orderDetail.getFinalSellingPrice()%>
                                </option>
                                <%}%>
                            </select>
                        </td>

                        <td>
                            <%=OrderService.getInstance().getExactlyTotalPriceNoShippingFee(o.getId() + "")%>
                        </td>
                        <td><%=o.getShippingFee()%>
                        </td>
                        <td><%=o.getTotalPrice()%>
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
    </form>
</div>
<div>
    <%@include file="../Footer/footer.jsp" %>
</div>
<script>
    function editName() {
        document.getElementById("input_name").disabled = false;
        document.getElementById('save_name').style.display = 'inline';
        document.getElementById('cancel_name').style.display = 'inline';
        document.getElementById('edit_name').style.display = 'none';
    }

    function cancelName() {
        document.getElementById("input_name").disabled = true;
        document.getElementById('save_name').style.display = 'none';
        document.getElementById('cancel_name').style.display = 'none';
        document.getElementById('edit_name').style.display = 'inline';
    }

    function editPhone() {
        document.getElementById("input_phone").disabled = false;
        document.getElementById('save_phone').style.display = 'inline';
        document.getElementById('cancel_phone').style.display = 'inline';
        document.getElementById('edit_phone').style.display = 'none';
    }

    function cancelPhone() {
        document.getElementById("input_phone").disabled = true;
        document.getElementById('save_phone').style.display = 'none';
        document.getElementById('cancel_phone').style.display = 'none';
        document.getElementById('edit_phone').style.display = 'inline';
    }

    document.getElementById('productSelect').addEventListener('change', function () {
        var productId = this.value;
        var url = '<%=request.getContextPath()%>/product-detail?id=' + productId;
        window.open(url, '_blank');
    });
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
    }
%>
</html>