package controller;

import model.bean.Product;
import model.dao.ProductDAO;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/findProduct2")
public class FindProduct extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req,resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("html/text; charset= UTF-8");
        String query = req.getParameter("findProducts");
        req.setAttribute("resultFind",query);
        List<Product> productList1 = ProductDAO.findProduct(query);
        int numberProduct = productList1.size();
        req.setAttribute("numberProduct",numberProduct);

        int itemPerPage1 = 15; // số lượng sp trên mỗi trang
        //lấy số trang hiện tại từ tham số yêu cầu
        int currentPage1 = 1;
        String paraParam1 = req.getParameter("page");
        if (paraParam1 != null && !paraParam1.isEmpty()) {
            currentPage1 = Integer.parseInt(paraParam1);
        }
        //Tính số sản phẩm bắt đầu và kết thúc
        int startIndex1 = (currentPage1 - 1) * itemPerPage1;
        int endIndex1 = Math.min(startIndex1 + itemPerPage1, numberProduct);
        //lấy danh sách sản phẩm cho trang hiện tại
        List<Product> currentPageItems1 = productList1.subList(startIndex1, endIndex1);

        req.setAttribute("currentPage1", currentPage1);
        req.setAttribute("totalPage1", (int) Math.ceil((double) productList1.size() / itemPerPage1));
        req.setAttribute("productInPage1", currentPageItems1);
        String path = "./views/SearchProduct/findProduct.jsp";
        req.getRequestDispatcher(path).forward(req, resp);
    }
}
