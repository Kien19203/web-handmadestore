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

@WebServlet(name = "OrderAdminController", value = "/admin/order")
public class OrderAdminController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.setCharacterEncoding("UTF-8");
        String currentFilter = req.getParameter("currentFilter");
        char delim = ':';
        System.out.println("Controller>> IN: " + currentFilter);
//        Find
        String submit_filter = req.getParameter("submit_filter");
        if (submit_filter != null) {
            if (submit_filter.equals("submit_find")) {
                String choiceFindType = req.getParameter("choiceFindType");
                String findText = req.getParameter("findText");
                if (findText != null && !findText.equals("")) {
                    req.setAttribute("currentFindText", findText);
                    if (choiceFindType.equals("orderId_rdo")) {
                        currentFilter = "orderId_rdo" + delim + findText;
                    } else if (choiceFindType.equals("customerId_rdo")) {
                        currentFilter = "customerId_rdo" + delim + findText;
                    } else if (choiceFindType.equals("customerName_rdo")) {
                        currentFilter = "customerName_rdo" + delim + findText;
                    }
                } else {
                    req.setAttribute("result", "Bạn chưa nhập từ khóa vào ô tìm kiếm");
                }
            } else if (submit_filter.equals("all")) {
                currentFilter = "all";
            } else if (submit_filter.equals("waitConfirmOrders")) {
                currentFilter = "waitConfirmOrders";
            } else if (submit_filter.equals("deliveringOrders")) {
                currentFilter = "deliveringOrders";
            } else if (submit_filter.equals("canceledOrders")) {
                currentFilter = "canceledOrders";
            } else if (submit_filter.equals("succcessfulOrders")) {
                currentFilter = "succcessfulOrders";
            }
        }
//      confirm or cancel order: orderId + action: cancel/confirm
        String currentOrderId = req.getParameter("currentOrderId");
        if (currentOrderId != null) {
            Order currentOrder = OrderService.getInstance().getOrderById(currentOrderId);
            String action = req.getParameter("action");
            if (action != null) {
                if (action.equals("cancel")) {
                    String cancelReason = req.getParameter("cancelReason");
                    MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(currentOrder.getUserId() + "").getEmail(), currentOrder, cancelReason);
                    OrderService.getInstance().cancelOrder(currentOrderId);
                } else if (action.equals("confirm")) {
                    MailService.sendNotifyConfirmOrder(UserService.getInstance().getUserById(currentOrder.getUserId() + "").getEmail(), currentOrder);
                    OrderService.getInstance().confirmOrder(currentOrderId);
                } else if (action.equals("delivered")) {
                    OrderService.getInstance().deliveredOrder(currentOrderId);
                }
            }
            req.setAttribute("currentOrderId", currentOrderId);
        }
        System.out.println("Controller>> out: " + currentFilter);
        req.setAttribute("currentFilter", currentFilter);
        req.getRequestDispatcher("/views/Admin/order_management.jsp").forward(req, resp);
    }
}
