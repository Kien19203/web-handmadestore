package controller;

import com.google.gson.Gson;
import model.bean.*;
import model.dao.OrderDAO;
import model.service.ProductService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.text.NumberFormat;
import java.util.*;


@WebServlet(name= "PaymentController", value = "/payment" )
public class PayMentController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        User user = (User) sessions.getAttribute("auth");
        Cart cart = (Cart) sessions.getAttribute("cart");
        Locale locale = new Locale("vi", "VN");
        Currency currency = Currency.getInstance(locale);
        NumberFormat numberFormat = NumberFormat.getCurrencyInstance(locale);
        numberFormat.setCurrency(currency);







//        Validation (isSale, discount & stock.
        boolean isValidCart = true;
        List<String> errorMessage = new ArrayList<>();


        for(Map.Entry<Integer, Item> entry : cart.getItems().entrySet() ) {
            int productId = entry.getKey();
            Item item = entry.getValue();
            Product p = ProductService.getInstance().getProductById(productId);

            double price = ProductService.getInstance().productPriceIncludeDiscount(p);
            System.out.println("Item: " + item.toString());
            System.out.println("Product " + p.getName() + " isSale" + p.getIsSale() + "price : " + price);

            if(p.getIsSale() != 1) {
                isValidCart = false;
                errorMessage.add("Sản phẩm \"" + p.getName() + "\" hiện đã ngừng kinh doanh.");
            }

            if(item.getQuantity() > p.getStock()) {
                isValidCart = false;
                errorMessage.add("Sản phẩm \"" + p.getName() + "\" hiện nay chỉ còn " + p.getStock() + " sản phẩm.");
            }

            if(item.getPrice() != price) {
                isValidCart = false;
                errorMessage.add("Giá của sản phẩm \"" + p.getName() + "\" đã được cập nhật thành " + numberFormat.format(price));

            }

        }


        System.out.println(isValidCart + "  ----------");

        if (user == null) {
            resp.sendRedirect("views/Login/view_login/login.jsp");
        } else {


            if(isValidCart) {
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                resp.getWriter().write("{ \"isValid\": true }"); // gui fan hoi json voi isValid = true
//                doPost(req, resp);
            }
            else {
                sendErrorResponse(resp, errorMessage);

            }

        }

//        NEW SESSION cho viec thanhtoan.
        HttpSession paymentSession = req.getSession(true);
        paymentSession.setAttribute("paymentStartTime", System.currentTimeMillis());

    }

    //
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        User user = (User) sessions.getAttribute("auth");
        Cart cart = (Cart) sessions.getAttribute("cart");

        OrderDAO orderZ = new OrderDAO();

        req.setCharacterEncoding("UTF-8");
        String namePay = req.getParameter("namePay");
        String phonePay = req.getParameter("phonePay");
        String address = req.getParameter("address");


//check validation
        Map<String, String> errors = new HashMap<>();

        validateRequireField("namePay", namePay, "Tên hiển thị", errors);
        validateRequireField("phonePay", phonePay, "Số điện thoại", errors);
        validateRequireField("address", address, "Địa chỉ", errors);


        if (!errors.isEmpty()) {
            req.setAttribute("errors", errors);
            req.getRequestDispatcher("views/PaymentPage/payment.jsp").forward(req, resp);
        } else {

            Order order = new Order();
            order.setConsigneeName(namePay);
            order.setConsigneePhoneNumber(phonePay);
            order.setAddress(address);

//           Xoasa sesion gio hàng
            orderZ.addOrder(order, cart, user);
            cart.clear();
            req.getSession().setAttribute("cart", cart);
            resp.sendRedirect(req.getContextPath() + "/views/MainPage/view_mainpage/mainpage.jsp");

        }
    }

    public static void validateRequireField(String fieldName, String value, String viewName, Map<String, String> errors) {
        if (value == null || value.trim().isEmpty()) {
            errors.put(fieldName, viewName + " không được bỏ trống");
        }
    }

    // Phương thức để gửi phản hồi lỗi về cho client
    private void sendErrorResponse(HttpServletResponse response,  List<String> errorMessage) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();
        response.getWriter().write(gson.toJson(errorMessage));
//        response.getWriter().write("{ \"isValid\": false, \"errorMessage\": \"" + errorMessage + "\" }");
    }
}