<%@ page import="model.bean.Order" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.bean.User" %>
<%@ page import="model.bean.OrderDetail" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    /**
     * FORMAT GIÁ TIỀN THEO ĐƠN VỊ CỦA VIỆT NAM.
     */
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency); %>

<%
    List<Order> orders =  OrderService.getInstance().getAllOrder();;
%>
<%
    /** XEM CHI TIẾT ĐƠN HÀNG :
     *  currentOrderId = mã đơn hàng muốn xem.
     */
    String currentOrderId =  request.getAttribute("currentOrderId")==null?"": (String) request.getAttribute("currentOrder");

    Order currentOrder = OrderService.getInstance().getOrderById(currentOrderId);
%>

<html lang="en">
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">

<%--   IMPORT DATATABLES.  --%>
    <%--    1. Cài bootstrap cdn v5 --%>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">
    <%--   2. Cài Jquery v3--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <%-- 3. Cài datatables--%>
    <script src="https://cdn.datatables.net/v/dt/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>
<%--    END DATATABLES.  --%>
    <title>Quản lý đơn hàng</title>
    <style>
        body {
            background-color: #F0EDCF;
        }

        .header {

            margin-top: 20px;
        }

        .header h2 {
            text-align: center;
        }

        /*.form-check {*/
        /*    color: #EEEEEE;*/
        /*}*/

        /*CSS cho radio tìm kiếm theo tên khách hàng, mã đơn hàng*/
        .searchId {
            position: absolute;
            z-index: 1000;
            display: flex;
            flex-wrap: wrap;
            border-radius: 0.5rem;
            background-color: #EEEEEE;
            box-sizing: border-box;
            box-shadow: 0 0 0 1px rgba(0, 0, 0, 0.06);
            /*padding: 0.25rem;*/
            width: 300px;
            font-size: 14px;
        }

        .searchId .form-check-label {
            flex: 1 1 auto;
            text-align: center;
        }

        .searchId .form-check-label input {
            display: none;
        }

        .searchId .form-check-label .label-name {
            display: flex;
            cursor: pointer;
            align-items: center;
            justify-content: center;
            border-radius: 0.5rem;
            border: none;
            padding: .5rem 0;
            color: #393E46;
            transition: all .15s ease-in-out;
        }

        .searchId .form-check-label input:checked + .label-name {
            background-color: #00ADB5;
            color:#EEEEEE ;
            font-weight: 600;
        }

        /*Input */
        .form-control {
            padding-left: 310px;
            padding-right: 20px;


        }
        .form-check-input:active {
            border-bottom-color: #00ADB5;

        }
        .input-group-append {
            position: absolute;
        }
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

        /* Filter theo giai đoạn xử lý đơn hàng*/
        .process-filter .btn {
            background-color: #393E46;
            border-bottom: solid 2px;
            border-bottom-color: #EEEEEE;
            color: #FFFFFF;
            border-radius: 0;
        }

        .process-filter .btn:hover {
            border-bottom-color: #00ADB5;
        }

        #orderView {
            display: none;
            position : fixed;
            top: 35%;
            left: 50%;
            transform: translate(-50%,-50%);
            z-index: 1000;
            background-color: #0d0d0d;
            color: #FFFFFF;



        }

        #overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0,0,0,0.5);
            z-index:  999;
        }


    </style>
</head>
<%
    /** XỬ LÝ ĐỂ VÀO TÀI KHOẢN ADMIN.
     * + check nếu không phải admin => quay trở về đăng nhập.
     */

    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {



%>
<body>

<div class="container-fluid mx-auto mt-2">
    <div class="header">
        <h2>Quản lý kho hàng</h2>


    </div>

    <form action="<%=request.getContextPath()%>/admin/order" method="post" id="orderForm">
        <div class="customer_list  mt-5 ">
                <table id="table-order"  class="display table table-striped table-hover table-bordered" style="width:100%">
                    <thead>
                    <tr>
                        <th>Xem</th>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá nhập</th>
                        <th>Giá bán ra</th>
                        <th>Số lượng tồn</th>
                        <th>Đã bán</th>
                        <th>Lần nhập gần nhất</th>

                    </tr>
                    </thead>
                    <tfoot>
                    <tr>
                        <th>Xem</th>
                        <th>Mã sản phẩm</th>
                        <th>Tên sản phẩm</th>
                        <th>Giá nhập</th>
                        <th>Giá bán ra</th>
                        <th>Số lượng tồn</th>
                        <th>Đã bán</th>
                        <th>Lần nhập gần nhất</th>
                    </tr>
                    </tfoot>
                </table>
        </div>
<%--    </form>--%>


    <div id="orderView">
        <%if(currentOrder!= null) {%>
        <h3>Đơn hàng #<%=currentOrder.getId()%></h3>
        <%}%>
        <p>Trạng thái của đơn hàng: </p>
    </div>


    <div id="overlay"></div>


</div>
<script>
    let viewOrder = document.getElementById("orderView");
    let overlay =document.getElementById("overlay")
<%-- BẮT ĐẦU LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ --%>
let dataOrder = []
let objectOrder;
<%
    for(Order o : orders) {
    if(o != null) { User customer = UserService.getInstance().getUserById(o.getUserId()+ "");
 %>
/* NOte về data-orderId : đây là dữ liệu tùy chỉnh, được lưu trữ trong phần tử button.
- Lấy nó bằng cách .data(orderId).
- Ta gán data-orderId = 15. -> data là dữ liệu của thẻ., orderId = 15 !.

 */
objectOrder = {
    'id' : '<%=o.getId()%>',
    'userId': '<%=o.getUserId()%>',
    'userName': '<%=customer.getName()%>',
    'address': '<%=o.getAddress()%>',
    'orderDate': '<%=o.getOrderDate()%>',
    'priceNoneShip': '<%=numberFormat.format(o.getTotalPrice()-o.getShippingFee()) %>',
    'shippingFee': '<%=numberFormat.format(o.getShippingFee())%>',
    'totalPrice': '<%=numberFormat.format(o.getTotalPrice())%>',
    'status': '<%=o.getStatus()%>',
    'detailButton' : '<button class="btn btn-primary btn-detail " data-orderId="<%=o.getId()%>"><i class="fa-solid fa-eye"></i></button>'
}
dataOrder.push(objectOrder);
<%}}%>


    $(document).ready(function () {
        $("#table-order").DataTable(

            {
                data: dataOrder, columns: [
                    {data: 'detailButton'},
                    {data:'id' },
                    {data:'userId'},
                    {data: 'userName'},
                    {data: 'address'},
                    {data: 'orderDate'},
                    {data: 'priceNoneShip'},
                    {data: 'shippingFee'},
                    {data: 'totalPrice'},
                    {data: 'status'}
                ]
            }
            );
    }
    );

<%--KẾT THÚC LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ--%>

<%--BẮT ĐẦU XỬ LÝ NÚT XEM CHI TIẾT ĐƠN HÀNG--%>

$('#table-order').on('click', '.btn-detail', function () {
   let orderId = $(this).data('orderId'); // lấy giá trị o.getId từ button.
    document.getElementById('currentOrderId').value = orderId;
    viewOrder.style.display = "block";
    overlay.style.display = "block";
    console.log("danbam");





})

<%--KẾT THÚC XỬ LÝ NÚT XEM CHI TIẾT ĐƠN HÀNG--%>

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