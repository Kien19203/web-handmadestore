package logs;

import com.google.gson.Gson;
import controller.Validation;
import model.bean.Discount;
import model.bean.Product;
import model.bean.User;
import model.service.DiscountService;
import model.service.ProductService;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/log-ajax-handle")
public class LogAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action != null) {
            if (action.equals("removeLog")) {
                String id = req.getParameter("id");
//             xóa log
            } else if (action.equals("clearInformLogs")) {

            } else if (action.equals("clearAlertLogs")) {

            }
        }
    }
}
