
<%@ page import="java.util.Map" %>
<%@ page import="model.bean.Item" %>
<%@ page import="model.service.ImageService" %><%--
=======
<<<<<<< HEAD
<%--
>>>>>>> origin/main
  Created by IntelliJ IDEA.
  User: Kien Nguyen
  Date: 1/19/2024
  Time: 11:47 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Giỏ Hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->


    <link rel="stylesheet" href="cartCSS.css"/>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">

    <style>
        .pause_bt {
            padding: 10px 40px;
            margin-right: 10px;
            border: none;
            font-weight: bold;
        }

        .complete_bt {
            padding: 10px 40px;
            border: none;
            font-weight: bold;
            background-color: red;
            color: white;
        }
    </style>
</head>
<body>

<%--Thanh điều hướng - header--%>

<%@include file="/views/MenuBar/menu.jsp" %>
<%--<%Map<Integer, Item> list = cart. %>--%>


<nav aria-label="breadcrumb">
    <ol class="breadcrumb ">
        <li class="breadcrumb-item"><a href="/">Trang Chủ</a></li>
        <li class="breadcrumb-item active" aria-current="page" style="color: #e32124">Giỏ hàng
        </li>
    </ol>
</nav>



<div class="row">
    <div class="col-12">
        <form action="">
            <div class="vh-100 w-100 bg-body d-flex justify-content-center align-items-center ">
                <!--Main-->
                <div>
                    <div class="w-70">
                        <table id="order-list" class="table table-borderless text-center mb-5">
                            <thead>
                            <tr class="align-middle border">
                                <th class="border-0" style="width: 19%">Sản phẩm</th>
                                <th class="border-0" style="width: 28%">Thông tin sản phẩm</th>
                                <th class="border-0" style="width: 17%">Đơn giá</th>
                                <th class="border-0" style="width: 18%">Số lượng</th>
                                <th class="border-0" style="width: 13%">Thành tiền</th>
                                <th class="border-0" style="width: 5%">Xóa</th>
                            </tr>
                            </thead>
                            <tbody>

                            <% for (Item item : cart.getItems().values()) { %>
                            <tr class="border-1">
                                <td class="align-middle">
                                  <%  String pathImage = ImageService.getInstance().pathImageOnly(item.getProduct().getId()); %>

                                    <img class="product-img" src="<%=request.getContextPath()%>/<%=pathImage%>" alt="sanpham" width="80%"
                                         height="80%">
                                </td>
                                <td class="align-middle">
                                    <div>
                                        <h6><%=item.getProduct().getName()%>
                                        </h6>

                                    </div>
                                </td>
                                <td class="align-middle">
                                    <%=numberFormat.format(item.getPrice())%>
                                </td>
                                <td class="align-middle">
                                    <div class="quantity-box d-flex p-1 border justify-content-center">
                                            <form action="<%=request.getContextPath()%>/add-cart" method="get" >
                                                <input type="hidden" name="id" value="<%=item.getProduct().getId()%>">
                                            <button id="increase_bt" name="actionCart" value="put" class="text-center border-0 bg-body fw-bold"
                                                    style="width: 30px;">-
                                            </button>
                                            <input id="quantity_input" class="border-0 w-50 text-center" type="text" name="actionCart"

                                                   value="<%=item.getQuantity()%>">

                                            <button type="submit" name="actionCart" value="put"
                                                    id="reduce_bt" class="text-center border-0 bg-body fw-bold"
                                                    style="width:30px;">+
                                            </button>

                                            </form>
                                    </div>
                                </td>
                                <td class="align-middle">
                                    <%=numberFormat.format(item.getQuantity() * item.getPrice())%>
                                </td>
                                <td class="align-middle">

<%--                                    <form action="<%=request.getContextPath()%>/add-cart" method="get" >--%>
<%--                                        <input type="hidden" name="id" value="<%=item.getProduct().getId()%>">--%>
<%--                                        <button type="submit" class="btn" name="actionCart" value="delete">--%>
<%--                                        <i class="fa-solid fa-trash-can"></i>--%>
<%--                                    </button>--%>

<%--                                    </form>--%>
    <form action="<%=request.getContextPath()%>/add-cart" method="get" >
        <input type="hidden" name="id" value="<%=item.getProduct().getId()%>">
        <button type="submit" class="btn" name="actionCart" value="delete">
            <i class="fa-solid fa-trash-can"></i>
        </button>

    </form>
                                </td>
                            </tr>

                            <%total += (item.getQuantity() * item.getPrice());%>
                            <%}%>


                            </tbody>
                        </table>
                    </div>
                    <div class="line-block text-end mb-3">
                        <span class="total-amount h4 me-1 fw-normal">Tổng tiền:</span>
                        <span id="total_amount" class="h5"><%=numberFormat.format(total)%></span>
                    </div>

                    <div class="line-block text-end">

                        <button type="button" class="pause_bt"
                                onclick="window.location = '../MainPage/view_mainpage/mainpage.jsp'">Tiếp tục mua hàng
                        </button>
                        <button type="button" class="complete_bt"
                                onclick="window.location = '../PaymentPage/payment.html'">Tiếp tục đặt hàng
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</div>



<!--    Footer-->
<%@include file="/views/Footer/footer.jsp" %>
<script>
    function updateItemTotal(unitPrice) {
        var quantityInput = document.getElementById('quantity_input');
        var itemTotalSpan = document.getElementById('item_total');

        var currentQuantity = parseInt(quantityInput.value);

        // Calculate total amount for the item
        var itemTotal = currentQuantity * unitPrice;

        // Update item total amount in the UI
        itemTotalSpan.textContent = '';
    }


</script>
</body>
</html>
>>>>>>> origin/main
