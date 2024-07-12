<%@ page import="model.bean.Product" %>
<%@ page import="model.service.ImageService" %>
<%@ page import="model.service.ProductService" %>
<%@ page import="java.util.List" %>
<%@ page import="model.dao.SortOption" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%String textSearch = (String) request.getAttribute("textSearch");%>
<%Integer searchResultNumber = (Integer) request.getAttribute("searchResultNumber");%>
<%List<Product> productList = request.getAttribute("products") != null ? (List<Product>) request.getAttribute("products") : ProductService.getInstance().getAllProducts(15, 0);%>
<%String filterFromHome = (String) request.getAttribute("filterFromHome");%>
<%String isDiscount = request.getAttribute("isDiscount") != null ? (String) request.getAttribute("isDiscount") : "false";%>
<html>
<head>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-T3c6CoIi6uLrA9TneNEoa7RxnatzjcDSCmG1MXxSR1GAsXEV/Dwwykc2MPK8M2HN" crossorigin="anonymous">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"> <!--icon-->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"
            integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
    <title>Danh sách sản phẩm</title>
    <link href="<%=request.getContextPath()%>/views/products/findProduct.css" rel="stylesheet" type="text/css">
    <style>
        .price-range-filter {
            align-items: center;
            display: flex;
            justify-content: space-between;
            margin: 1.25rem 0 .625rem;
        }

        .price-range-filter_input {
            font-size: .75rem;
            width: 5rem;
            background-color: #fff;
            border: 1px solid rgba(0, 0, 0, .26);
            border-radius: .125rem;
            box-shadow: inset 0 1px 0 0 rgba(0, 0, 0, .05);
            box-sizing: border-box;
            font-size: .8125rem;
            height: 1.875rem;
            outline: none;
            padding-left: .3125rem;
            width: 4.375rem;
        }

        .price-range-line {
            background: #bdbdbd;
            flex: 1;
            height: 1px;
            margin: 0 .625rem;
        }
    </style>
</head>
<body>
<div class="header">
    <%@include file="/views/MenuBar/menu.jsp" %>
</div>
<%----%>
<div id="findProducts" style="display: none">Tìm kiếm tại đây</div>
<%if (textSearch != null && !textSearch.isEmpty()) {%>
<h3 class="mx-3">
    <span>Có </span>
    <span class="fw-bold"><%=searchResultNumber%> sản phẩm </span>
    <span>cho tìm kiếm từ khóa </span>
    <span class="fw-bold">"<%=textSearch%>"</span>
</h3>
<%}%>
<%if (textSearch == null || (textSearch != null && searchResultNumber != null && searchResultNumber > 0)) {%>
<div class="content row mb-5 mx-3">
    <div class="col-2 ms-4 mt-4">
        <%if (textSearch == null || textSearch.isEmpty()) {%>
        <div class="row">
            <select id="categoryFilter" class="form-select" aria-label="Default select example" onchange="filter()">
                <option selected value="all">Tất cả sản phẩm</option>
                <%for (Category c : CategoryService.getInstance().getALl()) {%>
                <option value="<%=c.getId()%>"
                        <%if (filterFromHome != null && filterFromHome.equals(c.getId() + "")) {%>
                        selected
                        <%}%>
                ><%=c.getName()%>
                </option>
                <%}%>
            </select>
        </div>
        <%}%>
        <div class="row my-5">
            <label>Sắp xếp theo</label>
            <select id="sort" class="form-select" aria-label="Default select example" onchange="filter()">
                <option value="<%=SortOption.SORT_DEFAULT%>" selected>Liên quan nhất</option>
                <option value="<%=SortOption.SORT_DISCOUNT%>"
                        <%if (isDiscount.equals("true")) {%>
                        selected
                        <%}%>
                >Đang khuyến mãi
                </option>
                <option value="<%=SortOption.SORT_MOST_RATES%>">Có nhiều đánh giá nhất</option>
                <option value="<%=SortOption.SORT_HIGHEST_RATING%>">Xếp hạng cao nhất</option>
                <option value="<%=SortOption.SORT_PRICE_ASC%>">Giá tăng dần</option>
                <option value="<%=SortOption.SORT_PRICE_DESC%>">Giá giảm dần</option>
            </select>
        </div>
        <div class="row price-filter-group bg-light">
            <div>Khoảng giá</div>
            <div class="price-range-filter">
                <input
                        id="startPrice"
                        class="price-range-filter_input"
                        type="text"
                        maxLength="13"
                        placeholder="₫ Từ"
                />
                <div class="price-range-line"></div>
                <input
                        id="endPrice"
                        class="price-range-filter_input"
                        type="text"
                        maxLength="13"
                        placeholder="₫ ĐẾN"
                />
            </div>
            <div id="rangePriceValidation" class="text-center text-danger"></div>
            <div class="d-flex">
                <button type="button" class="w-75 btn btn-outline-success" onclick="filter()">
                    Áp Dụng
                </button>
                <button type="button" class="w-25 btn btn-outline-warning" onclick="resetRangePrice()">
                    Hoàn tác
                </button>
            </div>
        </div>
    </div>
    <div class="product_find col-9">
        <div id="products">
            <ul id="allProduct" class="products m-2 me-5 ms-3 d-flex flex-wrap">
                <%for (Product pfp : productList) {%>
                <%String pathImagefp = ImageService.getInstance().pathImageOnly(pfp.getId());%>
                <li class="product_li">
                    <div class="item_product  me-4">
                        <a class="image" href="<%=request.getContextPath()%>/product-detail?id=<%=pfp.getId()%>"> <img
                                src="<%=request.getContextPath()%>/<%=pathImagefp%>"> </a>
                        <a href="<%=request.getContextPath()%>/product-detail?id=<%=pfp.getId()%>"><p
                                class="pt-2 px-4 fw-bold"><%=pfp.getName() %>
                        </p></a>
                        <%!double giaBanSauCung;%>
                        <% giaBanSauCung = ProductService.getInstance().productPriceIncludeDiscount(pfp);%>
                        <%if (pfp.getCategoryId() >= 0 && giaBanSauCung != pfp.getSellingPrice()) {%>
                        <%! int discountProduct;%>
                        <% discountProduct = ProductService.getInstance().discountProduct(pfp.getId());%>
                        <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProduct%>
                            %
                        </div>
                        <del><p class="mt-2" style="margin-bottom: 0"><%=numberFormat.format(pfp.getSellingPrice())%>
                        </p></del>
                        <p class="fw-bold text-danger"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pfp))%>
                        </p>
                        <%} else {%>
                        <p class="fw-bold mt-2"
                           style="margin-bottom: 0"><%=numberFormat.format(ProductService.getInstance().productPriceIncludeDiscount(pfp))%>
                        </p>
                        <%}%>
                        <div class="add-to-cart">
                            <button onclick="addcart(this,<%=pfp.getId()%>)"><span class="fw-bold">Thêm vào giỏ <i
                                    class="fa-solid fa-cart-shopping"></i></span></button>
                        </div>
                    </div>
                </li>
                <%}%>
            </ul>
        </div>
        <%--    Số Trang--%>
        <div class="d-flex justify-content-center" id="morebox">
            <%if (productList.size() >= 15) {%>
            <span id="moreButton" class="fst-italic fw-bold" style="cursor: pointer"
                  onclick="more(15,15)"
            >Xem thêm...
                </span>
            <%}%>
        </div>
    </div>
    <input type="hidden" id="textSearch" value="<%=(textSearch!=null?textSearch:"")%>">
    <input type="hidden" id="offset" value="0">
</div>
<%} else {%>
<div class="content row mb-5 mx-3" style="height: 50vh">
</div>
<%}%>
<div class="footer">
    <%@include file="../Footer/footer.jsp" %>
</div>
</body>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<script>
    <%--    Chưa khắc phục đc lỗi--%>

    function addcart(btn, idP) {
        let num = 1;
        $.ajax({
            url: "/HandMadeStore/add-cart-2",
            method: "POST",
            data: {
                id: idP,
                actionCart: "post",
                num: num
            },
            success: function (response) {
                console.log("thanh cong");
                handleAddToCart(response);
                Swal.fire({
                    position: "center",
                    icon: "success",
                    title: "Thêm Sản Phẩm Vào Giỏ Hàng Thành Công!",
                    showConfirmButton: false,
                    timer: 1500
                });
            }
        })
    }

    function reloadProduct(response) {
        const products = $('#products');
        if (response.length != 0) {
            let productsHtml = '';
            let p = '';
            productsHtml +=
                `
             <ul id="allProduct" class="products m-2 me-5 ms-3 d-flex flex-wrap">
            `
            console.log(response)
            response.forEach(function (r) {
                let priceHtml = '';
                if (r.sellingPrice != r.finalPrice) {
                    priceHtml = `
                    <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProduct%>%</div>
                        <del ><p class="mt-2" style="margin-bottom: 0">${formattedPrice(r.sellingPrice)}</p></del>
                        <p class="fw-bold text-danger">${formattedPrice(r.finalPrice)}</p>
                `
                } else {
                    priceHtml = `
                <p class="fw-bold mt-2" style="margin-bottom: 0">${formattedPrice(r.finalPrice)}</p>
                `
                }
                p += `
                <li class="product_li">
                    <div class="item_product  me-4">
                        <a class="image" href="<%=request.getContextPath()%>/product-detail?id=${r.id}"> <img
                                src="<%=request.getContextPath()%>/${r.imagePath}"> </a>
                        <a href="<%=request.getContextPath()%>/product-detail?id=${r.id}"><p
                                class="pt-2 px-4 fw-bold">${r.name}
                        </p></a>
                        ` + priceHtml + `
                        <div class="add-to-cart">
                            <button onclick="addcart(this,${r.id})"><span class="fw-bold">Thêm vào giỏ <i
                                    class="fa-solid fa-cart-shopping"></i></span></button>
                        </div>
                    </div>
                </li>
                    `;
            });
            productsHtml += p;
            productsHtml += `
            </ul>
        `
            products.html(productsHtml)
        } else {
            products.html(
                `<div class="d-flex justify-content-center align-items-center fs-4">Hix, không có sản phẩm nào!</div>`
            )
        }
    }

    function moreProduct(response) {
        const more = $('#allProduct');
        let productsHtml = '';
        let p = '';
        response.forEach(function (r) {
            let priceHtml = '';
            if (r.sellingPrice != r.finalPrice) {
                priceHtml = `
                    <div style="position: absolute;top: 0;z-index: 1000;background: red;color: white;padding: 5px;"><%=discountProduct%>%</div>
                        <del ><p class="mt-2" style="margin-bottom: 0">${formattedPrice(r.sellingPrice)}</p></del>
                        <p class="fw-bold text-danger">${formattedPrice(r.finalPrice)}</p>
                `
            } else {
                priceHtml = `
                <p class="fw-bold mt-2" style="margin-bottom: 0">${formattedPrice(r.finalPrice)}</p>
                `
            }
            p += `
               <li class="product_li">
                    <div class="item_product  me-4">
                        <a class="image" href="<%=request.getContextPath()%>/product-detail?id=${r.id}"> <img
                                src="<%=request.getContextPath()%>/${r.imagePath}"> </a>
                        <a href="<%=request.getContextPath()%>/product-detail?id=${r.id}"><p
                                class="pt-2 px-4 fw-bold">${r.name}
                        </p></a>
                        ` + priceHtml + `
                        <div class="add-to-cart">
                            <button onclick="addcart(this,${r.id})"><span class="fw-bold">Thêm vào giỏ <i
                                    class="fa-solid fa-cart-shopping"></i></span></button>
                        </div>
                    </div>
                </li>
                    `;
        });
        productsHtml += p;
        more.append(productsHtml);
    }

    function resetRangePrice() {
        const categoryFilter = $('#categoryFilter');
        const sort = $('#sort');
        const textSearch = $('#textSearch');
        const startPrice = $('#startPrice');
        const endPrice = $('#endPrice');
        startPrice.val('');
        endPrice.val('');

        let categoryValue = "all";
        if (categoryFilter) categoryValue = categoryFilter.val();

        let sortValue = 0;
        if (sort)
            sortValue = sort.val();

        $.ajax({
            method: "POST",
            url: "/HandMadeStore/productsPage",
            data: {
                action: "filter",
                searchFilter: textSearch.val(),
                categoryFilter: categoryValue,
                sort: sortValue,
                limit: 15,
                offset: 0
            },
            success: function (response) {
                reloadProduct(response)
                if (response.length < 15) {
                    if ($('#moreButton'))
                        $('#moreButton').remove()
                } else {
                    if ($('#offset'))
                        $('#offset').val(response.length)

                    if ($('#morebox'))
                        $('#morebox').html(`
                        <span id="moreButton" class="fst-italic fw-bold" style="cursor: pointer"
                            onclick="more(${response.length},15)"
                        >Xem thêm...
                        </span>
                        `)
                }
            },
            error: function () {
                alert("Lỗi khi sử dụng bộ lọc");
            }
        })
    }

    function filter() {
        const categoryFilter = $('#categoryFilter');
        const sort = $('#sort');
        const startPrice = $('#startPrice');
        const endPrice = $('#endPrice');
        const textSearch = $('#textSearch');

        let categoryValue = "all";
        if (categoryFilter) categoryValue = categoryFilter.val();

        let sortValue = 0;
        if (sort)
            sortValue = sort.val();

        $.ajax({
            method: "POST",
            url: "/HandMadeStore/productsPage",
            data: {
                action: "filter",
                searchFilter: textSearch.val(),
                categoryFilter: categoryValue,
                sort: sortValue,
                startPrice: startPrice.val(),
                endPrice: endPrice.val(),
                limit: 15,
                offset: 0
            },
            success: function (response) {
                reloadProduct(response)
                if (response.length < 15) {
                    if ($('#moreButton'))
                        $('#moreButton').remove()
                } else {
                    if ($('#offset'))
                        $('#offset').val(response.length)

                    if ($('#morebox'))
                        $('#morebox').html(`
                        <span id="moreButton" class="fst-italic fw-bold" style="cursor: pointer"
                            onclick="more(${response.length},15)"
                        >Xem thêm...
                        </span>
                        `)
                }
            },
            error: function () {
                alert("Lỗi khi sử dụng bộ lọc");
            }
        })
    }

    function more(startElement, moreNumber) {
        const categoryFilter = $('#categoryFilter');
        const sort = $('#sort');
        const startPrice = $('#startPrice');
        const endPrice = $('#endPrice');
        const textSearch = $('#textSearch');
        const offset = $('#offset');

        let categoryValue = "all";
        if (categoryFilter) categoryValue = categoryFilter.val();

        let sortValue = 0;
        if (sort)
            sortValue = sort.val();
        $.ajax({
            method: "POST",
            url: "/HandMadeStore/productsPage",
            data: {
                action: "more",
                searchFilter: textSearch.val(),
                categoryFilter: categoryValue,
                sort: sortValue,
                startPrice: startPrice.val(),
                endPrice: endPrice.val(),
                limit: 15,
                offset: offset.val()
            },
            success: function (response) {
                moreProduct(response)

                if (response.length < 15) {
                    if ($('#moreButton'))
                        $('#moreButton').remove()
                } else {
                    if ($('#offset'))
                        $('#offset').val((Number.parseInt(offset.val()) + response.length))
                }
            },
            error: function () {
                alert("Lỗi khi nhấn xem thêm");
            }
        })
    }

    function formattedPrice(value) {
        const formattedPrice = new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(value);
        return formattedPrice;
    }
</script>
</html>
