package controller.admin;

import model.bean.Order;
import model.service.JavaMail.MailService;
import model.service.OrderService;
import model.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/confirmOrder")
public class ConfirmOrderAjax extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String orderId = req.getParameter("orderId");
        if (action != null && orderId != null) {
            Order order = OrderService.getInstance().getOrderById(orderId);
            if (action.equals("deliveredOrder")) {
                OrderService.getInstance().deliveredOrder(orderId);
            } else if (action.equals("confirmOrder")) {
                MailService.sendNotifyConfirmOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order);
                OrderService.getInstance().confirmOrder(orderId);
            } else if (action.equals("cancelOrder")) {
                String cancelReason = req.getParameter("cancelReason");
                MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order, cancelReason == null ? "" : cancelReason);
                OrderService.getInstance().cancelOrder(orderId);
            }
        }
        resp.getWriter().write("("+OrderService.getInstance().waitConfirmOrdersNumber()+")");
    }
}
