<%@ page import="java.util.List" %>
<%@ page import="logs.Log" %>
<%@ page import="logs.LoggingService" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    List<Log> logs = LoggingService.getInstance().getLogs();
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý log</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
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
        .pagination {
            position: fixed;
            overflow: auto;
            bottom: 20%;
            left: 50%;
            transform: translateX(-50%);
            z-index: 1000;
        }

        .dt-empty, .dt-info {
            display: none;
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<div class="container-fluid mx-auto mt-2">
    <h1><%=LoggingService.getInstance().getAbsolutePath()%></h1>
    <div class="table-wrapper-scroll-y my-custom-scrollbar  d-flex justify-content-center">
        <table id="data" class="table table-striped table-hover">
            <thead>
            <tr class="text-center sticky-top">
                <th class="text-nowrap fix-column" scope="col"
                    style=" position: sticky;left: 0;z-index: 1;">Mã Log</th>
                <th class="text-nowrap" scope="col">Mức độ</th>
                <th class="text-nowrap" scope="col">Hoạt động</th>
                <th class="text-nowrap" scope="col">Nội dung</th>
                <th scope="col">Thời gian</th>
                <th class="text-nowrap" scope="col">Địa chỉ IP</th>
                <th class="text-nowrap" scope="col">Thành phố</th>
                <th class="text-nowrap" scope="col">Khu vực</th>
                <th class="text-nowrap" scope="col">Quốc gia</th>
            </tr>
            </thead>
            <tbody>
            <% for (int i = logs.size() - 1; i >= 0; i--) { %>
            <tr class="text-center">
                <td><%= logs.get(i).getId() %></td>
                <td style="background-color:
                    <% if (logs.get(i).isINFORMLevel()) { %>
                        #0dcaf0
                    <% } else if (logs.get(i).isALERTLevel()) { %>
                        #ffecb3
                    <% } else if (logs.get(i).isWARNINGLevel()) { %>
                        #fd7e14
                    <% } else if (logs.get(i).isDANGERLevel()) { %>
                        #dc3545
                        <% } %>">
                    <%= logs.get(i).getLevel() %>
                </td>
                <td><%= logs.get(i).getAction() %></td>
                <td><%= logs.get(i).getMessage() %></td>
                <td><%= logs.get(i).getFormattedCreatedTime() %></td>
                <td><%= logs.get(i).getIpAddress() %></td>
                <td><%= logs.get(i).getCity() %></td>
                <td><%= logs.get(i).getRegion() %></td>
                <td><%= logs.get(i).getCountryName() %></td>
            </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
<script>
    $(document).ready(function () {
        const table = $('#data').DataTable({
            "searching": true,
            "lengthChange": false,
            "pageLength": 10,
            "order": [[0, "desc"]],
            language: {
                search: "Nhập từ khóa tìm kiếm"
            }
        });
    });
</script>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }
%>
</html>
