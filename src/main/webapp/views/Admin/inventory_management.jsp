<%@ page import="model.bean.Order" %>
<%@ page import="model.service.OrderService" %>
<%@ page import="model.service.UserService" %>
<%@ page import="model.bean.User" %>
<%@ page import="model.bean.OrderDetail" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="model.service.InventoryService" %>
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
    List<InventoryProduct> ipList = InventoryService.getInstance().showInventoryView();
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

    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.7/css/dataTables.dataTables.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.dataTables.css">

    <%--   2. Cài Jquery v3--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

    <%-- 3. Cài datatables--%>

    <script src="https://cdn.datatables.net/v/dt/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js" integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+" crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL" crossorigin="anonymous"></script>

<%--    Print excel, pdf, start  vv...v--%>
    <script src="https://cdn.datatables.net/2.0.7/js/dataTables.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/dataTables.buttons.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.dataTables.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jszip/3.10.1/jszip.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/pdfmake.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/pdfmake/0.2.7/vfs_fonts.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.html5.min.js"></script>
    <script src="https://cdn.datatables.net/buttons/3.0.2/js/buttons.print.min.js"></script>
    <%--    Print excel, pdf, start  end--%>

<%--    END DATATABLES.  --%>
    <title>Quản lý đơn hàng</title>
    <style>
        body {
            background-color: #e5e5e5;
            color: #eb1616;
            font-family: "Open Sans", sans-serif;
            font-weight: bold;
            font-size: 16px;
            margin: 0;
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }


        .header {

            margin-top: 20px;
        }

        .header h2 {
            text-align: center;
        }

        .data_table {
            background-color: #FFFFFF;
            padding: 15px;
            box-shadow: 1px 3px 5px #aaa;
            border-radius: 5px;
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

<div class="container mx-auto mt-2">
<div class="row">
    <div class="header">
        <h2>Kho hàng HandmadeStore</h2>
    </div>

    <form action="<%=request.getContextPath()%>/admin/order" method="post" id="orderForm">
        <div class="col-12">
        <div class="data_table  mt-5 ">
                <table id="table-inventory"  class="display table table-striped table-hover table-bordered">
                    <thead class="table-dark">
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

                </table>
        </div>
        </div>
<%--    </form>--%>


    <div id="overlay"></div>
</div>
</div>
<script>
    let viewOrder = document.getElementById("orderView");
    let overlay =document.getElementById("overlay")
<%-- BẮT ĐẦU LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ --%>
let dataInventory = []
let objectInventory;
<%
    for(InventoryProduct o : ipList) {
 %>
/* NOte về data-orderId : đây là dữ liệu tùy chỉnh, được lưu trữ trong phần tử button.
- Lấy nó bằng cách .data(orderId).
- Ta gán data-orderId = 15. -> data là dữ liệu của thẻ., orderId = 15 !.

 */
    objectInventory = {
    'productId' : '<%=o.getId()%>',
    'productName': '<%=o.getName()%>',
    'costPrice': '<%=numberFormat.format(o.getCostPrice())%>',
    'sellingPrice': '<%=numberFormat.format(o.getSellingPrice())%>',
    'quantityRemaining': '<%=o.getQuantityRemaining()%>',
    'soldOut': '<%=o.getSoldOut()%>',
    'lastModified': '<%=o.getLastModified()%>',
    'detailButton' : '<button class="btn btn-primary btn-detail " data-orderId="<%=o.getId()%>"><i class="fa-solid fa-eye"></i></button>'
}
dataInventory.push(objectInventory);

<%}%>


    $(document).ready(function () {
     var table =   $("#table-inventory").DataTable(
            {
                layout: {
                    topStart: {
                        buttons: ['copy', 'csv', 'excel', 'pdf', 'print']
                    }
                }
                ,
                paging: false,
                scrollCollapse: true,
                scrollY: '50vh',
                order: [[5, 'desc']],

                data: dataInventory, columns: [
                    {data: 'detailButton'},
                    {data: 'productId'},
                    {data: 'productName'},
                    {data: 'costPrice'},
                    {data: 'sellingPrice'},
                    {data: 'quantityRemaining'},
                    {data: 'soldOut'},
                    {data: 'lastModified'}
                ]



            } );


    }
    );

<%--KẾT THÚC LOAD DỮ LIỆU TỪ DB VÀO AJAX FILE -> HIỂN THỊ--%>

<%--BẮT ĐẦU XỬ LÝ NÚT XEM CHI TIẾT ĐƠN HÀNG--%>

$('#table-inventory').on('click', '.btn-detail', function () {
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