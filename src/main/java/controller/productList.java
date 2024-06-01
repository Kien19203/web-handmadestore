package controller;

import com.fasterxml.jackson.databind.ObjectMapper;
import model.bean.Category;
import model.bean.Image;
import model.bean.Product;
import model.dao.CategoryDAO;
import model.dao.ProductDAO;
import model.service.ProductService;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;
import java.util.ArrayList;
import java.util.List;


@WebServlet(urlPatterns = {"/product"})

public class productList extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("html/text; charset= UTF-8");
        List<Product> productList = null;/**/
        String filter = req.getParameter("filter");
        String category = req.getParameter("category");
        if (filter != null && category != null) {
            if (filter.equals("ascPrice")) {
                List<Category> categoryList = CategoryDAO.getAll();
                if (category.equals("khuyenmai")) {
                    productList = ProductService.getInstance().sortListProductDiscountAZ();
                } else {
                    for (Category value : categoryList) {
                        String values = String.valueOf(value.getId());
                        if (category.equals(values)) {
                            productList = ProductDAO.sortProductByCategoryAZ(value.getId());
                            break;
                        }
                    }
                }
            } else if (filter.equals("descPrice")) {
                List<Category> categoryList = CategoryDAO.getAll();
                if (category.equals("khuyenmai")) {
                    productList = ProductService.getInstance().sortListProductDiscountZA();
                } else {
                    for (Category value : categoryList) {
                        String values = String.valueOf(value.getId());
                        if (category.equals(values)) {
                            productList = ProductDAO.sortProductByCategoryZA(value.getId());
                            break;
                        }
                    }
                }
            }
        } else if (filter == null && category != null) {
            List<Category> categoryList = CategoryDAO.getAll();
            if (category.equals("khuyenmai")) {
                productList = ProductService.getInstance().listProductDiscount();
            } else {
                for (Category value : categoryList) {
                    String values = String.valueOf(value.getId());
                    if (category.equals(values)) {
                        productList = ProductService.getInstance().getProductsByCategoryId(value.getId());
                        break;
                    }
                }
            }
        } else if (filter != null) {
            if (filter.equals("ascPrice")) {
                productList = ProductService.getInstance().sortProductsAZ();
            } else if (filter.equals("descPrice")) {
                productList = ProductService.getInstance().sortProductsZA();
            }
        } else {
            productList = ProductService.getInstance().getAll();
        }
        req.setAttribute("filter", filter);
        int itemPerPage = 16; // số lượng sp trên mỗi trang
        //lấy số trang hiện tại từ tham số yêu cầu
        int currentPage = 1;
        String paraParam = req.getParameter("page");
        if (paraParam != null && !paraParam.isEmpty()) {
            currentPage = Integer.parseInt(paraParam);
        }
        //Tính số sản phẩm bắt đầu và kết thúc
        int startIndex = (currentPage - 1) * itemPerPage;
        int endIndex = Math.min(startIndex + itemPerPage, productList.size());
        //lấy danh sách sản phẩm cho trang hiện tại
        List<Product> currentPageItems = productList.subList(startIndex, endIndex);

        req.setAttribute("currentPage", currentPage);
        req.setAttribute("totalPage", (int) Math.ceil((double) productList.size() / itemPerPage));
        req.setAttribute("productInPage", currentPageItems);
        String path = "./views/ProductList/productList.jsp";
        req.getRequestDispatcher(path).forward(req, resp);
        // ----------------------------
//        boolean loadfile = req.getParameter("loadfile") != null;
//        if(loadfile){
//            System.out.println("Load");
//            ObjectMapper mapper = new ObjectMapper();
//            String jsonReponse = mapper.writeValueAsString(productList);
//            resp.setContentType("application/json");
//            resp.getWriter().write(jsonReponse);
//            resp.getWriter().flush();
//            resp.getWriter().close();
//        }
//        System.out.println("Ko Load");

// ----------------------------
    }
}
