<%@ page import="java.util.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="model.adapter.InventoryProduct" %>
<%@ page import="model.bean.Product" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="model.bean.Image" %>
<%@ page import="model.service.*" %>
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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.datatables.net/v/bs5/jq-3.7.0/dt-2.0.6/datatables.min.css" rel="stylesheet">

    <link rel="stylesheet" href="https://cdn.datatables.net/2.0.7/css/dataTables.dataTables.css">
    <link rel="stylesheet" href="https://cdn.datatables.net/buttons/3.0.2/css/buttons.dataTables.css">

    <%--   2. Cài Jquery v3--%>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/twitter-bootstrap/5.3.0/js/bootstrap.bundle.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>

    <%-- 3. Cài datatables--%>

    <script src="https://cdn.datatables.net/v/dt/dt-2.0.6/datatables.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.min.js"
            integrity="sha384-BBtl+eGJRgqQAUMxJ7pMwbEyER4l1g+O15P+16Ep7Q9Q+zqX6gSbd85u4mG4QzX+"
            crossorigin="anonymous"></script>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-C6RzsynM9kWDrMNeT87bh95OGNyZPhcTNXj1NW7RuBCsyN/o0jlpcV8Qyq46cDfL"
            crossorigin="anonymous"></script>

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
    <title>Kho hàng HandmadeStore</title>
    <style>
        body {
            background-color: #e5e5e5;
            color: #eb1616;
            font-family: "Open Sans", sans-serif;
            font-weight: bold;
            font-size: 16px;
            margin: 0;
            /*display: flex;*/
            /*align-items: center;*/
            /*justify-content: center;*/
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


        .detail-info {
            background-color: #e5e5e5;;
            color: #000;
        }
        .detail-info h3 {
            color: #eb1616;
        }
        .quantity-label {
            justify-content: space-around;
            align-items: center;

        }

        .vertical-line {
            width: 1px;
            height: 24px; /* Adjust the height as needed */
            background-color: black; /* Adjust the color as needed */
            margin: 0 10px; /* Optional: add margin to separate from other elements */
        }


        #overlay {
            display: none;
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 999;
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

<div class="container-fluid w-100 my-0 mt-2">
    <div class="row">
        <div class="header">
            <h2>Kho hàng HandmadeStore</h2>
        </div>

        <form action="<%=request.getContextPath()%>/admin/order" method="post" id="orderForm">
            <div class="col-12">
                <div class="data_table  mt-5 ">
                    <table id="table-inventory" class="display table table-striped table-hover table-bordered">
                        <thead class="table-dark">
                        <tr>
                            <th>Xem</th>
                            <th>Mã</th>
                            <th>Tên</th>
                            <th>Giá nhập</th>
                            <th>Giá bán</th>
                            <th>Lượng tồn</th>
                            <th>Lượng bán</th>
                            <th>Biến động giá</th>
                            <th>Nhập gần nhất</th>
                            <th>Trạng thái</th>

                        </tr>
                        </thead>

                    </table>
                </div>
            </div>
        </form>


            <div id="overlay"></div>
    </div>
</div>

<%InventoryProduct ipd = InventoryService.getInstance().getIdProduct(1);
List<Category> categories = CategoryService.getInstance().getALl();

%>
<div class="detail-info w-80 mx-auto mt-2">
<form action="<%=request.getContextPath()%>/admin/product"  method="post" enctype="multipart/form-data">
    <div id="edit_product" class="w-100 p-3 rounded"
         style="display: block">
<%--        <h3 class="text-center fw-bold p-3">Thông tin chi tiết sản phẩm #<%=pdo.getId()%>--%>
<%--        </h3>--%>

<%--        <div class="err">--%>
<%--&lt;%&ndash;            <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>&ndash;%&gt;--%>
<%--            <p id="errPass" class="text-center" style="color: red"><%="Code đang lỗi"%>--%>
<%--            </p>--%>
<%--        </div>--%>
<%--        <div class="row my-4">--%>
<%--            <div class="col-md-6 mb-2">--%>
<%--                <div class="form-floating w-100 mx-5 my-2 p-2 ">--%>
<%--                    <input type="text" class="form-control" name="last_edit_product_id"--%>
<%--                           value="<%=pdo.getId()%>" style="display: none">--%>
<%--                    <input type="text" class="form-control" id="productName" name="productName"--%>
<%--                           value="<%=pdo.getName()%>">--%>
<%--                    <label for="productName">Tên sản phẩm (Lưu ý: Không nên chứa ký tự '#')</label>--%>
<%--                </div>--%>
<%--                <div class="form-floating w-100 mx-5 my-2 p-2">--%>
<%--                    <input type="number" class="form-control" id="quantity" name="quantity"--%>
<%--                           value="<%="Đang lỗi nha"%>">--%>
<%--                    <label for="quantity">Số lượng</label>--%>
<%--                </div>--%>
<%--                <div class="form-floating w-100 mx-5 my-2 p-2">--%>
<%--                    <input type="number" class="form-control" id="costPrice" name="costPrice"--%>
<%--                           value="<%="Đang lỗi nha"%>">--%>
<%--                    <label for="costPrice">Giá nhập vào</label>--%>
<%--                </div>--%>
<%--                <div class="form-floating w-100 mx-5 my-2 p-2">--%>
<%--                    <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"--%>
<%--                           value="<%=pdo.getSellingPrice()%>">--%>
<%--                    <label for="sellingPrice">Giá bán</label>--%>
<%--                </div>--%>
<%--            </div>--%>
    <h3 class="text-center fw-bold p-3">Thông tin chi tiết sản phẩm #<%=ipd.getId()%>
    </h3>

    <div class="err">
        <p id="errPass" class="text-center" style="color: red">Code đang lỗi
        </p>
    </div>
    <div class="row my-4">
        <div class="col-md-6 mb-2">
            <h4 class="text-center">Thông tin chung</h4>
            <hr>

            <div class="form-floating w-100 my-2 p-2 ">
                <input type="text" class="form-control" name="last_edit_product_id"
                       value="<%=ipd.getId()%>" style="display: none">
                <input type="text" class="form-control" id="productName" name="productName"
                       value="<%=ipd.getName()%>">
                <label for="productName">Tên sản phẩm (Lưu ý: Không nên chứa ký tự '#')</label>
            </div>
            <div class="w-100 my-2 p-2 quantity_statistic">
                <div class="quantity-label d-flex flex-row">

                    <span> Số lượng : <strong><%=ipd.getSoldOut() + ipd.getQuantityRemaining()%></strong> </span>
                    <div class="vertical-line"></div>
                    <span>  Đã bán : <strong><%=ipd.getSoldOut()%></strong>  </span>
                    <div class="vertical-line"></div>
                    <span>  Còn lại: <strong><%=ipd.getQuantityRemaining()%></strong> </span>
                </div>


                <div class="progress mt-2" role="progressbar" aria-label="Success example" aria-valuenow="25"
                     aria-valuemin="0" aria-valuemax="100">
                    <%double ratioValue = (ipd.getSoldOut() *100) / (ipd.getSoldOut() + ipd.getQuantityRemaining());%>
                    <div class="progress-bar bg-success" style="width: <%=ratioValue%>%"><%=ratioValue%>%</div>
                </div>
            </div>
            <div class="quantity_statistic d-flex flex-row">
                <div class="form-floating my-2 p-2 col-6">
                    <span>Giá nhập hiện tại: </span> <strong><%=numberFormat.format(ipd.getCostPrice())%></strong> <br/>
                    <span>Lần nhập gần nhất: </span> <strong><%=ipd.getLastModified()%></strong><br/>
                    <span>Lợi nhuận hiện tại: </span> <strong><%=numberFormat.format(ipd.getSellingPrice() - ipd.getCostPrice())%></strong><br/>
                </div>
                <div class="form-floating my-2 p-2 col-6">
                    <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"
                           value="<%=ipd.getSellingPrice()%>>">
                    <label for="sellingPrice">Giá bán</label>
                </div>
            </div>
            <h4>Tổng doanh thu hiện tại</h4>



        </div>
        <%--        Choice category and create new category--%>
            <div class="col-md-6 mb-5">
                <div >
                    <h4 class="text-center">Phân loại sản phẩm</h4>
                    <hr>
                    <div class="form-floating  mx-5 my-2 p-2">
                        <select class="form-select" id="isSale" aria-label="Tình trạng bán hàng" name="isSale">
                            <option value="0" <%= ipd.getIsSale() == 0 ? "selected" : "" %>>Ngừng kinh doanh</option>
                            <option value="2" <%= ipd.getIsSale() == 2 ? "selected" : "" %>>Tạm hết hàng</option>
                            <option value="1" <%= ipd.getIsSale() == 1 ? "selected" : "" %>>Có sẵn</option>
                        </select>
                        <label for="isSale">Trạng thái sản phẩm</label>
                    </div>


                    <div class="m-0 border alert alert-dismissible d-flex align-items-center  mx-5 my-2 p-2">
                        <div class="me-4 ms-3">
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory" id="case1"
                                <%if (ipd.getCategoryId()>0){%>
                                   checked
                                <%}%>
                                   value="choiceAvailableCategory"
                                   onclick="showAvailableCategory()">
                            <label class="form-check-label" style="cursor: pointer" for="case1">
                                Chọn danh mục có sẵn
                            </label>
                        </div>
                        <div>
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory"
                                   id="case2"
                                <%if (ipd.getCategoryId()<=0){%>
                                   checked
                                <%}%>
                                   value="choiceNewCategory"
                                   onclick="showInputToNewCategory()"
                            >
                            <label class="form-check-label" style="cursor: pointer" for="case2">
                                Tạo danh mục mới
                            </label>
                        </div>
                    </div>
                    <div class="form-floating  mx-5 my-2 p-2 align-content-start"
                            <%if (ipd.getCategoryId() > 0) {%>
                         style="display: block"
                            <%} else {%>
                         style="display: none"
                            <%}%>
                         id="showAvailableCategory">
                        <select class="form-select" id="availableCategory" name="availableCategory"
                                aria-label="Chọn danh mục liên quan">
                            <%for (Category category : categories) {%>
                            <option value="<%=category.getId()%>"
                                    <% if (ipd.getCategoryId() == category.getId()) {%>
                                    selected
                                    <%}%>
                            >
                                <%=category.getName()%>
                            </option>
                            <%}%>
                        </select>
                        <label>Chọn danh mục liên quan</label>
                    </div>
                    <div class="form-floating  mx-5 my-2 p-2 align-content-start"
                            <%if (ipd.getCategoryId() > 0) {%>
                         style="display: none"
                            <%} else {%>
                         style="display: block"
                            <%}%>
                         id="showInputToNewCategory">
                        <input type="text" class="form-control" id="newCategory" name="newCategory">
                        <label for="newCategory">Nhập tên danh mục mới</label>
                    </div>
                    <div class="form-floating  mx-5 my-2 p-2">
                        <select class="form-select" id="discountId" aria-label="Giảm giá áp dụng" name="discount">
                            <option value="" selected></option>
                            <%for (Discount d : DiscountService.getInstance().getAll()) {%>
                            <option value="<%=d.getId()%>"
                                    <%if (ipd.getDiscountId() == d.getId()) {%>
                                    selected
                                    <%}%>
                            >
                                <%=d.getName()%> - giảm <%=d.getPercentageOff() * 100%>%
                            </option>
                            <%}%>
                        </select>
                        <label for="discountId">Chọn giảm giá áp dụng</label>
                    </div>
                    <div class="mx-5" style=" display: block;position: relative;height: 110px;overflow: auto;">
                        <div class="d-flex justify-content-start">
                            <%for (Image image : ImageService.getImagesForProduct(ipd.getId() + "")) {%>
                            <div class="mx-3" id="image_<%=image.getId()%>">
                                <%--                                haha--%>
                                <div class="text-danger fw-bold text-end" style="cursor: pointer"
                                     onclick="showDeleteImageBox(<%=image.getId()%>)">Xóa
                                </div>
                                <img class="border-2" width="80px" , height="80px"
                                     src="<%=request.getContextPath()%>/<%=image.getPath()%>">
                            </div>
                            <%}%>
                            <div class="col-8">
                                <label for="uploadImage">Chọn File Ảnh ít hơn 5MB</label>
                                <input id="uploadImage" type="file" name="images" placeholder="Chọn File Ảnh ít hơn 5MB"
                                       multiple onchange="displayFileNames(this)" accept="image/*">
                                <div id="fileNamesContainer"></div>
                                <%--                                <button class="mt-3 border-2 btn btn-outline-dark" style="width: 80px; height: 80px;"><i--%>
                                <%--                                        style="font-size: 30px" class="fa-solid fa-circle-plus"></i></button>--%>
                            </div>
                        </div>
                    </div>
                    <div id="delete_image_box"></div>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-5 border rounded-3">
            <label for="description" class="form-label">Mô tả sản phẩm</label>
            <textarea class="form-control mx-auto w-70"
                      style="height: 200px; white-space: nowrap; overflow: auto; resize: none;"
                      id="description" name="description"
                      rows="3"><%="Zeze"%></textarea>
        </div>
        <div class="d-flex justify-content-end m-0">
            <button type="button" onclick="hideEditProduct()" class="btn btn-outline-warning m-3 fs-5 fw-bold"
                    style="color: #eeeeee">Thoát
            </button>
            <button type="submit"
                    class="btn btn-outline-success m-3 fs-5 fw-bold"
                    style="color: #eeeeee"
                    title="Hoàn tất nếu bạn chắc chắn đã điền đầy đủ thông tin">Hoàn tất chỉnh sửa
            </button>
        </div>
        <input type="hidden" name="currentPageNumber"
               value=""<%=request.getAttribute("currentPageNumber")==null?0:request.getAttribute("currentPageNumber")%>"">
    </div>
</form>
</div>
<script>
    let viewOrder = document.getElementById("orderView");
    let overlay = document.getElementById("overlay")
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
        'productId': '<%=o.getId()%>',
        'productName': '<%=o.getName()%>',
        'costPrice': '<%=numberFormat.format(o.getCostPrice())%>',
        'sellingPrice': '<%=numberFormat.format(o.getSellingPrice())%>',
        'quantityRemaining': '<%=o.getQuantityRemaining()%>',
        'soldOut': '<%=o.getSoldOut()%>',
        'priceDifference': <%=o.getPriceDifference()%>,
        'lastModified': '<%=o.getLastModified()%>',
        'isSale': '<%=o.getIsSale()%>',
        'detailButton': '<button class="btn btn-primary btn-detail " data-orderId="<%=o.getId()%>"><i class="fa-solid fa-eye"></i></button>'
    }
    dataInventory.push(objectInventory);

    <%}%>


    $(document).ready(function () {
            var table = $("#table-inventory").DataTable(



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
                        {data: 'priceDifference',
                            render: function (data,type) {
                            if(type=='display') {
                                var value = parseInt(data);
                                var colour = 'green';
                                var icon= '';
                                var number = DataTable.render
                                    .number(',', '.', 0, '', ' ₫') // Không cần số thập phân
                                    .display(data);

                                if(value > 0) {
                                    icon = '<i class="fas fa-arrow-alt-circle-up" style=`color:${colour}`></i>'
                                }
                                else if(value < 0) {
                                    colour = 'red';
                                    icon = '<i class="fas fa-arrow-alt-circle-down" style=`color:${colour}`></i>'
                                }
                                else {
                                    colour = 'gray';
                                    icon = '<i class="fas fa-minus-circle" style=`color:${colour}`></i>'
                                }
                                return `<span style="color:${colour}">${icon} ${number}</span>`;

                            }
                            return data;
                            }


                        },
                        {data: 'lastModified'},
                        {data: 'isSale',
                        render: function (data, type) {
                            if (type === 'display') {
                                if (data === "0") {
                                    return 'Ngừng bán';
                                } else if (data === "2") {
                                    return 'Hết hàng';
                                } else {
                                    return 'Có sẵn';
                                }
                            }
                            return data; // Trả về giá trị gốc trong các chế độ khác (sort, filter, type)
                        }
                        }
                    ]


                });


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


    function showEdit(productId) {
        window.location.href = "<%=request.getContextPath()%>/admin/product?func=inventory_management&edit_product_id=" + productId;
    }


    function showAvailableCategory() {
        document.getElementById("showInputToNewCategory").style.display = "none";
        document.getElementById("showAvailableCategory").style.display = "block";
    }

    function showInputToNewCategory() {
        document.getElementById("showAvailableCategory").style.display = "none";
        document.getElementById("showInputToNewCategory").style.display = "block";
    }

    function hideEditProduct() {
        document.getElementById("edit_product").style.display = "none";
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
    }
%>
</html>