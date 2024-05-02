<%@ page import="java.util.List" %>
<%@ page import="model.bean.Product" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="model.bean.Category" %>
<%@ page import="model.service.CategoryService" %>
<%@ page import="model.service.DiscountService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="model.bean.Discount" %>
<%@ page import="java.util.Locale" %>
<%@ page import="java.util.Currency" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    Locale locale = new Locale("vi", "VN");
    Currency currency = Currency.getInstance(locale);
    NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
    numberFormat.setCurrency(currency);
%>
<%List<Product> products = (List<Product>) request.getAttribute("products");%>
<%products = (products == null) ? ProductService.getInstance().getAll() : products;%>
<%List<Category> categories = (List<Category>) request.getAttribute("categories");%>
<%categories = (categories == null) ? CategoryService.getInstance().getALl() : categories;%>
<%
    String selectedCategory = (String) request.getAttribute("selectedCategory");
    selectedCategory = (selectedCategory == null) ? "all" : selectedCategory;
%>
<% Product edit_product = (Product) request.getAttribute("edit_product");%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <title>Quản lý sản phẩm</title>
    <link rel="stylesheet" href="<%=request.getContextPath()%>/views/Admin/css/table_style.css">
    <style>
        #edit_product {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            overflow: auto;
            display: none;
            z-index: 1030;
            background-color: #2c3e50; /* Adjust the background color as needed */
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.5); /* Optional: Add a box shadow for a subtle effect */
        }
    </style>
</head>
<%
    boolean isAdmin = ((request.getSession().getAttribute("isAdmin") == null) ? false : ((boolean) request.getSession().getAttribute("isAdmin")));
    if (isAdmin) {
%>
<body>
<%--edit--%>
<%if (edit_product != null) {%>
<form action="<%=request.getContextPath()%>/admin/product">
    <div id="edit_product" class="w-75 bg-secondary p-3 rounded"
         style="display: block">
        <div class="text-center fw-bold p-3" style="font-size: 30px; color: #0dcaf0">Chỉnh sửa thông tin sản phẩm có
            mã: <%=edit_product.getId()%>
        </div>

        <div class="err">
            <% String re = request.getAttribute("result") == null ? "" : request.getAttribute("result").toString(); %>
            <p id="errPass" class="text-center" style="color: red"><%=re%>
            </p>
        </div>
        <div class="row my-4">
            <div class="col-md-6 mb-2">
                <div class="form-floating w-100 mx-5 my-2 p-2 ">
                    <input type="text" class="form-control" name="last_edit_product_id"
                           value="<%=edit_product.getId()%>" style="display: none">
                    <input type="text" class="form-control" id="productName" name="productName"
                           value="<%=edit_product.getName()%>">
                    <label for="productName">Tên sản phẩm (Lưu ý: Không nên chứa ký tự '#')</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="quantity" name="quantity"
                           value="<%=edit_product.getQuantity()%>">
                    <label for="quantity">Số lượng</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="costPrice" name="costPrice"
                           value="<%=edit_product.getCostPrice()%>">
                    <label for="costPrice">Giá nhập vào</label>
                </div>
                <div class="form-floating w-100 mx-5 my-2 p-2">
                    <input type="number" class="form-control" id="sellingPrice" name="sellingPrice"
                           value="<%=edit_product.getSellingPrice()%>">
                    <label for="sellingPrice">Giá bán</label>
                </div>
            </div>
            <%--        Choice category and create new category--%>
            <div class="col-md-6 mb-5">
                <div class="mt-4">
                    <div class="m-0 border alert alert-dismissible d-flex align-items-center  mx-5 my-2 p-2">
                        <div class="me-4">
                            <input class="form-check-input fs-5" style="cursor: pointer" type="radio"
                                   name="choiceCategory" id="case1"
                                <%if (edit_product.getCategoryId()>0){%>
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
                                <%if (edit_product.getCategoryId()<=0){%>
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
                            <%if (edit_product.getCategoryId() > 0) {%>
                         style="display: block"
                            <%} else {%>
                         style="display: none"
                            <%}%>
                         id="showAvailableCategory">
                        <select class="form-select" id="availableCategory" name="availableCategory"
                                aria-label="Chọn danh mục liên quan">
                            <%for (Category category : categories) {%>
                            <option value="<%=category.getId()%>"
                                    <% if (edit_product.getCategoryId() == category.getId()) {%>
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
                            <%if (edit_product.getCategoryId() > 0) {%>
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
                                    <%if (edit_product.getDiscountId() == d.getId()) {%>
                                    selected
                                    <%}%>
                            >
                                <%=d.getName()%> - giảm <%=d.getPercentageOff() * 100%>%
                            </option>
                            <%}%>
                        </select>
                        <label for="discountId">Chọn giảm giá áp dụng</label>
                    </div>
                </div>
            </div>
        </div>
        <div class="row my-4 mx-5 border rounded-3">
            <label for="description" class="form-label">Mô tả sản phẩm</label>
            <textarea class="form-control mx-auto w-70"
                      style="height: 200px; white-space: nowrap; overflow: auto; resize: none;"
                      id="description" name="description"
                      rows="3"><%=edit_product.getDescription()%></textarea>
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
    </div>
</form>
<script>
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
<%}%>
<%--main--%>
<div class="container-fluid mx-auto mt-2">
    <div class="row m-4 fs-6">
        <div class="col-6 align-content-center">
            <select class="form-select form-select-lg" id="optionFunction" onchange="location=this.value;">
                </option>
                <option class="fw-bold" value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=all"
                        <%if (selectedCategory == null || selectedCategory.equals("all")) {%>
                        selected
                        <%}%>
                >Tất cả sản phẩm
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=isSaleTrue"
                        <%if (selectedCategory != null && selectedCategory.equals("isSaleTrue")) {%>
                        selected
                        <%}%>
                >Sản phẩm đang kinh doanh
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=isSaleFalse"
                        <%if (selectedCategory != null && selectedCategory.equals("isSaleFalse")) {%>
                        selected
                        <%}%>
                >Sản phẩm ngừng kinh doanh
                </option>
                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=hasDiscountTrue"
                        <%if (selectedCategory != null && selectedCategory.equals("hasDiscountTrue")) {%>
                        selected
                        <%}%>
                >Sản phẩm đang áp dụng giảm giá
                </option>
                </option>
                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=hasDiscountFalse"
                        <%if (selectedCategory != null && selectedCategory.equals("hasDiscountFalse")) {%>
                        selected
                        <%}%>
                >Sản phẩm không áp dụng giảm giá nào
                </option>

                <option class="fw-bold"
                        value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=nullQuantity"
                        <%if (selectedCategory != null && selectedCategory.equals("nullQuantity")) {%>
                        selected
                        <%}%>
                >Sản phẩm hết hàng
                </option>

                <%for (Category c : categories) {%>
                <option class="fst-italic" value="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=<%=c.getId()%>"
                        <%if (selectedCategory != null && selectedCategory.equals(c.getId() + "")) {%>
                        selected
                        <%}%>
                ><%=c.getName()%>
                </option>
                <%}%>
                <option
                    <%if (request.getAttribute("nameFilter") != null) {%>
                        selected
                    <%}%>
                        disabled
                >
            </select>
        </div>
        <div class="col-6">
            <form action="<%=request.getContextPath()%>/admin/product">
                <div class="input-group justify-content-end">
                    <div>
                        <div class="form-text">Nhập ký tự # ở đầu để tìm theo mã sản phẩm</div>
                        <div class="d-flex">
                            <input type="text" class="form-control" placeholder="Nhập từ khóa"
                                   name="nameFilter"
                                   id="nameFilter"
                                   value="<%=request.getAttribute("nameFilter")==null?"":request.getAttribute("nameFilter")%>">
                            <button
                                    class="btn btn-outline-secondary" type="submit">Tìm
                            </button>
                        </div>
                        <input type="text" name="func" value="product_management" style="display: none">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <div class="solid"></div>
    <div class="product_list m-auto" id="product">
        <div class="table-wrapper-scroll-y my-custom-scrollbar">
            <table class="table table-striped table-hover">
                <thead>
                <tr class="text-center sticky-top">
                    <th class="text-nowrap fix-column" scope="col"
                        style=" position: sticky;left: 0;z-index: 1;"
                    >Mã sản phẩm
                    </th>
                    <th scope="col">Tên sản phẩm</th>
                    <th class="text-nowrap" scope="col">Mô tả</th>
                    <th class="text-nowrap" scope="col">Số lượng có sẵn</th>
                    <th class="text-nowrap" scope="col">Số lượng đã bán</th>
                    <th class="text-nowrap" scope="col">Giá nhập vào</th>
                    <th class="text-nowrap" scope="col">Giá bán ra</th>
                    <th class="text-nowrap" scope="col">Giảm giá được áp dụng</th>
                    <th class="text-nowrap" scope="col">Giá sản phẩm hiện tại</th>
                    <th class="text-nowrap" scope="col">
                        Trạng thái kinh doanh
                    </th>
                    <th class="text-nowrap" scope="col">Chức năng</th>
                </tr>
                </thead>
                <tbody>
                <%for (Product p : products) {%>
                <tr class="text-center">
                    <td class="fix-column"
                        style=" position: sticky;left: 0;z-index: 1;"
                    >
                        <%--                        show--%>
                        <a href="<%=request.getContextPath()%>/product-detail?id=<%=p.getId()%>" target="_blank"
                           class="px-2 btn btn-primary">
                            <%=p.getId()%>
                        </a>
                    </td>
                    <td><%=p.getName()%>
                    </td>
                    <td>
                        <%if (p.getDescription().length() > 9) {%>
                        <%=p.getDescription().substring(0, 10) + "..."%>
                        <%} else {%>
                        <%=p.getDescription() + "..."%>
                        <%}%>
                    </td>
                    <td><%=p.getQuantity()%>
                    </td>
                    <td><%=p.getSoldout()%>
                    </td>
                    <td><%=numberFormat.format(p.getCostPrice())%>
                    </td>
                    <td><%=numberFormat.format(p.getSellingPrice())%>
                    </td>
                    <%!double finalSellingPrice;%>
                    <%finalSellingPrice = ProductService.getInstance().productPriceIncludeDiscount(p);%>
                    <td>

                        <%Discount d = DiscountService.getInstance().getDiscountById(p.getDiscountId() + "");%>
                        <%if (finalSellingPrice == p.getSellingPrice()) {%>
                        <del style="text-decoration-color: red;">
                            <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                        </del>
                        <%} else {%>
                        <%=(d == null) ? "" : d.getName() + " - giảm " + (d.getPercentageOff() * 100) + "%"%>
                        <%}%>
                    </td>
                    <td><%=numberFormat.format(finalSellingPrice)%>
                    <td>
                        <%if (p.getIsSale() == 0) {%>
                        <%--0: false--%>
                        <a title="Nhấp vào để: Tiếp tục kinh doanh sản phẩm này" class="btn btn-outline-primary"
                           href="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=<%=selectedCategory%>&switch_product_isSale=<%=p.getId()%>">
                            <i class="fa-solid fa-xmark fs-4" style="color: red"></i>
                        </a>
                        <%} else {%>
                        <%--1: true--%>
                        <a title="Nhấp vào để: Ngừng kinh doanh sản phẩm này" class="btn btn-outline-primary"
                           href="<%=request.getContextPath()%>/admin/product?func=product_management&category_id=<%=selectedCategory%>&switch_product_isSale=<%=p.getId()%>">
                            <i class="fa-solid fa-check fs-4"></i>
                        </a>
                        <%}%>
                    </td>
                    <td>
                        <%--                        Delete product--%>
                        <a href="<%=request.getContextPath()%>/admin/product?func=product_management&edit_product_id=<%=p.getId()%>"
                           class="px-2">
                            <i class="fa-solid fa-pen fs-4" style="color: #5c7093;"></i></a>
                        <a href="<%=request.getContextPath()%>/admin/product?func=product_management&func_2=showConfirmBox&delete_product_id=<%=p.getId()%>&category_id=<%=selectedCategory%>"
                           class="px-2">
                            <i class="fa-solid fa-trash-can fs-4" style="color: #5c7093;"></i></a>
                    </td>
                </tr>
                <%}%>
                </tbody>
            </table>
        </div>
    </div>
</div>
</body>
<%
    } else {
        response.sendRedirect(request.getContextPath() + "/login");
    }%>
</html>