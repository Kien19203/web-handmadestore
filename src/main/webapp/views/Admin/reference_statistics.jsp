<%@ page import="model.bean.User" %>
<%@ page import="model.bean.Product" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="model.service.*" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Title</title>
    <link rel="stylesheet" href="../css/main.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.1/font/bootstrap-icons.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css">

    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Lato&display=swap" rel="stylesheet">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Alumni+Sans+Inline+One&display=swap" rel="stylesheet">
    <script
            src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.4/Chart.js">
    </script>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="m-2 title-main">
    <h5 class="p-3">Chào bạn quay trở lại, Admin ơi!</h5>
</div>
<div class="main-content">
    <div class="card-box m-4 d-flex align-middle">
        <div class="row border border border-success rounded-2">
            <div class="col-6 d-flex align-items-center fs-5">
                <div class="fw-bold"><%=CounterFilter.getCount()%>
                <i class="bi bi-eye"></i>
            </div>
            <div class="col-6">Tổng số lượt ghé thăm trang web</div>
        </div>

        <div class="card mb-3 me-3 " style="max-width: 300px;">
            <div class="row g-0">
                <div class="col-md-4 card-icon">
                    <i class="bi bi-bag-fill"></i>
                    <p class="card-text"><%=ProductService.getInstance().getNumberAvailProduct()%>
                    </p>
                </div>
                <div class="col-md-8">
                    <div class="card-body">
                        <h5 class="card-title">Sản phẩm</h5>
                        <p class="card-text">Tổng số lượng sản phẩm có sẵn</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-3 me-3  " style="max-width: 300px;">
            <div class="row g-0">
                <div class="col-md-4 card-icon">
                    <i class="bi bi-truck"></i>
                    <p class="card-text"><%=OrderService.getInstance().deliveringOrdersNumber()%>
                    </p>
                </div>
                <div class="col-md-8">
                    <div class="card-body">
                        <h5 class="card-title">Đơn hàng</h5>
                        <p class="card-text">Số lượng đơn hàng đang vận chuyển</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="card mb-3   " style="max-width: 300px;">
            <div class="row g-0">
                <div class="col-md-4 card-icon">
                    <i class="bi bi-people-fill"></i>
                    <p class="card-text"><%=UserService.getInstance().usersNumber()%>
                    </p>
                </div>
                <div class="col-md-8">
                    <div class="card-body">
                        <h5 class="card-title">Khách hàng</h5>
                        <p class="card-text">Tổng số lượng khách hàng đang có</p>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
<!--ĐƠN HÀNG-->
<div class="main-content-se row mx-2 mb-2">
    <div class="chart-product row p-3">
        <div class="best-sell-pd  col-sm-5">
            <h5 class="title-f">Top 5 sản phẩm bán chạy</h5>
            <hr class="line-split">
            <table class="table">
                <thead>
                <tr>
                    <th scope="col">STT</th>
                    <th scope="col">Mã sản phẩm</th>
                    <th scope="col">Tên sản phẩm</th>
                    <th scope="col">Số lượng đã bán</th>
                    <th scope="col">Số lượng còn lại</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int count = 0;
                    for (InventoryProduct p : InventoryService.getInstance().getTopSoldoutProduct(5)) {
                        count++;
                %>
                <tr>
                    <td><%=count%>
                    </td>
                    <th scope="row"><%=p.getId()%>
                    </th>
                    <th scope="row"><%=p.getName()%>
                    </th>
                    <th><%=p.getSoldOut()%>
                    </th>
                    <th><%=p.getQuantityRemaining()%>
                    </th>
                </tr>
                <%}%>
                </tbody>
            </table>
        </div>

        <div class="profit col-sm-7">
            <h5 class="title-f">Doanh thu bán hàng gần nhất <%=LocalDate.now().getYear()%>
            </h5>
            <hr class="line-split">
            <canvas id="myCharts" style="width:100%;max-width:600px"></canvas>
        </div>
    </div>
    <div class="row">
        <div class="user-header">
            <h5 class="title-f">10 Khách hàng mới</h5>
        </div>
        <hr class="line-split">
        <%for (User u : UserService.getInstance().getNewUsersTop(10)) {%>
        <div class="d-flex">
            <div class="d-flex align-items-center mx-3">
                <i class="bi bi-person-circle"></i>
            </div>
            <div class="mx-3"><%=u.getName()%>
            </div>
            <div class="mx-3"><%=u.getEmail()%>
            </div>
            <div class="mx-3"><%=u.getCreateDate()%>
            </div>
        </div>
        <%}%>
    </div>
</div>

<%!int year = LocalDate.now().getYear();%>
<input type="hidden" id="year" value="<%=year%>">
<%!double lastyear_max = OrderService.getInstance().getMonthRevenueMax(year - 1);%>;
<input type="hidden" id="lastyear_m1" value="<%=OrderService.getInstance().getRevenueForMonth(1,year-1)%>">
<input type="hidden" id="lastyear_m2" value="<%=OrderService.getInstance().getRevenueForMonth(2,year-1)%>">
<input type="hidden" id="lastyear_m3" value="<%=OrderService.getInstance().getRevenueForMonth(3,year-1)%>">
<input type="hidden" id="lastyear_m4" value="<%=OrderService.getInstance().getRevenueForMonth(4,year-1)%>">
<input type="hidden" id="lastyear_m5" value="<%=OrderService.getInstance().getRevenueForMonth(5,year-1)%>">
<input type="hidden" id="lastyear_m6" value="<%=OrderService.getInstance().getRevenueForMonth(6,year-1)%>">
<input type="hidden" id="lastyear_m7" value="<%=OrderService.getInstance().getRevenueForMonth(7,year-1)%>">
<input type="hidden" id="lastyear_m8" value="<%=OrderService.getInstance().getRevenueForMonth(8,year-1)%>">
<input type="hidden" id="lastyear_m9" value="<%=OrderService.getInstance().getRevenueForMonth(9,year-1)%>">
<input type="hidden" id="lastyear_m10" value="<%=OrderService.getInstance().getRevenueForMonth(10,year-1)%>">
<input type="hidden" id="lastyear_m11" value="<%=OrderService.getInstance().getRevenueForMonth(11,year-1)%>">
<input type="hidden" id="lastyear_m12" value="<%=OrderService.getInstance().getRevenueForMonth(12,year-1)%>">


<%!double current_max = OrderService.getInstance().getMonthRevenueMax(year);%>
<input type="hidden" id="max" value="<%=(current_max>lastyear_max)?current_max:lastyear_max%>">
<input type="hidden" id="m1" value="<%=OrderService.getInstance().getRevenueForMonth(1,year)%>">
<input type="hidden" id="m2" value="<%=OrderService.getInstance().getRevenueForMonth(2,year)%>">
<input type="hidden" id="m3" value="<%=OrderService.getInstance().getRevenueForMonth(3,year)%>">
<input type="hidden" id="m4" value="<%=OrderService.getInstance().getRevenueForMonth(4,year)%>">
<input type="hidden" id="m5" value="<%=OrderService.getInstance().getRevenueForMonth(5,year)%>">
<input type="hidden" id="m6" value="<%=OrderService.getInstance().getRevenueForMonth(6,year)%>">
<input type="hidden" id="m7" value="<%=OrderService.getInstance().getRevenueForMonth(7,year)%>">
<input type="hidden" id="m8" value="<%=OrderService.getInstance().getRevenueForMonth(8,year)%>">
<input type="hidden" id="m9" value="<%=OrderService.getInstance().getRevenueForMonth(9,year)%>">
<input type="hidden" id="m10" value="<%=OrderService.getInstance().getRevenueForMonth(10,year)%>">
<input type="hidden" id="m11" value="<%=OrderService.getInstance().getRevenueForMonth(11,year)%>">
<input type="hidden" id="m12" value="<%=OrderService.getInstance().getRevenueForMonth(12,year)%>">


<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
        crossorigin="anonymous"></script>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"
        integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script src="../js/main.js"></script>
<script src="../js/main.js"></script>
<script>
    var y_last1 = parseFloat(document.getElementById("lastyear_m1").value);
    var y_last2 = parseFloat(document.getElementById("lastyear_m2").value);
    var y_last3 = parseFloat(document.getElementById("lastyear_m3").value);
    var y_last4 = parseFloat(document.getElementById("lastyear_m4").value);
    var y_last5 = parseFloat(document.getElementById("lastyear_m5").value);
    var y_last6 = parseFloat(document.getElementById("lastyear_m6").value);
    var y_last7 = parseFloat(document.getElementById("lastyear_m7").value);
    var y_last8 = parseFloat(document.getElementById("lastyear_m8").value);
    var y_last9 = parseFloat(document.getElementById("lastyear_m9").value);
    var y_last10 = parseFloat(document.getElementById("lastyear_m10").value);
    var y_last11 = parseFloat(document.getElementById("lastyear_m11").value);
    var y_last12 = parseFloat(document.getElementById("lastyear_m12").value);

    var y1 = parseFloat(document.getElementById("m1").value);
    var y2 = parseFloat(document.getElementById("m2").value);
    var y3 = parseFloat(document.getElementById("m3").value);
    var y4 = parseFloat(document.getElementById("m4").value);
    var y5 = parseFloat(document.getElementById("m5").value);
    var y6 = parseFloat(document.getElementById("m6").value);
    var y7 = parseFloat(document.getElementById("m7").value);
    var y8 = parseFloat(document.getElementById("m8").value);
    var y9 = parseFloat(document.getElementById("m9").value);
    var y10 = parseFloat(document.getElementById("m10").value);
    var y11 = parseFloat(document.getElementById("m11").value);
    var y12 = parseFloat(document.getElementById("m12").value);
    var ymax = parseFloat(document.getElementById("max").value);

    var year = parseFloat(document.getElementById("year").value);
    var lastYear = year - 1;

    var yValues = [];
    var xValues = [];

    for (var i = 1; i <= 12; i++) {
        var lastYearValue = parseFloat(document.getElementById("lastyear_m" + i).value);
        yValues.push(lastYearValue);
        xValues.push(i + "/" + lastYear);
    }

    var currentMonth = new Date().getMonth() + 1;

    for (var i = 1; i < currentMonth; i++) {
        var currentValue = parseFloat(document.getElementById("m" + i).value);
        yValues.push(currentValue);
        xValues.push(i + "/" + year);
    }

    var ymax = parseFloat(document.getElementById("max").value);

    new Chart("myCharts", {
        type: "line",
        data: {
            labels: xValues,
            datasets: [{
                fill: false,
                lineTension: 0,
                backgroundColor: "#ff0000",
                borderColor: "#1a73e8",
                data: yValues
            }]
        },
        options: {
            legend: {display: false},
            scales: {
                yAxes: [{ticks: {min: 0, max: ymax}}],
            }
        }
    });


</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>