package controller.ajax_handle;

import com.google.gson.Gson;
import model.bean.Image;
import model.bean.Order;
import model.bean.OrderDetail;
import model.bean.Product;
import model.service.ImageService;
import model.service.JavaMail.MailService;
import model.service.OrderService;
import model.service.ProductService;
import model.service.UserService;
import org.eclipse.tags.shaded.org.apache.xpath.operations.Or;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

@WebServlet("/order-ajax-handle")
public class OrderAjaxHandle extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doGet(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        String orderId = req.getParameter("orderId");
        System.out.println("init: "+action);
        if (action != null && orderId != null) {
            Order order = OrderService.getInstance().getOrderById(orderId);
            if (action.equals("deliveredOrder")) {
                OrderService.getInstance().deliveredOrder(orderId);
                resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
            } else if (action.equals("confirmOrder")) {
                MailService.sendNotifyConfirmOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order);
                OrderService.getInstance().confirmOrder(orderId);
                resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
            } else if (action.equals("cancelOrder")) {
                String cancelReason = req.getParameter("cancelReason");
                MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order, cancelReason == null ? "" : cancelReason);
                OrderService.getInstance().cancelOrder(orderId);
                resp.getWriter().write("(" + OrderService.getInstance().waitConfirmOrdersNumber() + ")");
            } else if (action.equals("showOrder")) {
                Order o = OrderService.getInstance().getOrderById(orderId);
                List<OrderDetailMapping> orderDetailMappings = new ArrayList<>();
                Product product;
                String image;
                for (OrderDetail od : OrderService.getInstance().getOrderDetailsByOrderId(orderId)) {
                    product = ProductService.getInstance().getProductById(od.getProductId());
                    image = ImageService.pathImageOnly(product.getId());
                    orderDetailMappings.add(new OrderDetailMapping(od, product.getName(),image));
                }
                OrderDetailsResponse orderDetailsResponse = new OrderDetailsResponse(o, orderDetailMappings);
                Gson gson = new Gson();
                resp.setContentType("application/json");
                resp.setCharacterEncoding("UTF-8");
                String jsonResponse = gson.toJson(orderDetailsResponse);
                resp.getWriter().write(jsonResponse);
            }else if(action.equals("customerCancelOrder")){
                String cancelReason = req.getParameter("cancelReason");
                OrderService.getInstance().cancelOrder(orderId);
                MailService.sendNotifyCanceledOrder(UserService.getInstance().getUserById(order.getUserId() + "").getEmail(), order, cancelReason == null ? "" : cancelReason);
                resp.getWriter().write(String.valueOf(OrderService.getInstance().getOrderById(orderId).getStatus()));
            }
        } else {
            if (action.equals("moreOrder")) {
                String userId = req.getParameter("userId");
                String limit = req.getParameter("limit");
                String offset = req.getParameter("offset");
                String statusNumber = req.getParameter("statusNumber");
                try {
                    List<Order> moreOrders = (statusNumber != null && (
                            statusNumber.equals("0")
                                    || statusNumber.equals("1")
                                    || statusNumber.equals("2")
                                    || statusNumber.equals("3")
                                    || statusNumber.equals("4"))) ?
                            OrderService.getInstance().getOrderByCustomerId(userId, Integer.parseInt(limit), Integer.parseInt(offset), Integer.parseInt(statusNumber)) :
                            OrderService.getInstance().getOrderByCustomerId(userId, Integer.parseInt(limit), Integer.parseInt(offset));
                    List<OrderResponse> orderResponses = new ArrayList<>();
                    HashMap map;
                    Product p;
                    String imagePath;
                    OrderResponse orderResponse;
                    for (Order o : moreOrders) {
                        map = new HashMap();
                        for (OrderDetail orderDetail : OrderService.getInstance().getOrderDetailsByOrderId(o.getId()
                                + "")) {
                            p = ProductService.getInstance().getProductById(orderDetail.getProductId() + "");
                            imagePath = ImageService.pathImageOnly(p.getId());
                            map.put(p.getName(), imagePath);
                        }
                        orderResponse = new OrderResponse(o, map);
                        orderResponses.add(orderResponse);
                    }

                    Gson gson = new Gson();
                    resp.setContentType("application/json");
                    resp.setCharacterEncoding("UTF-8");
                    String jsonResponse = gson.toJson(orderResponses);
                    resp.getWriter().write(jsonResponse);
                } catch (Exception e) {
                    e.printStackTrace();
                }
            } else if (action.equals("getNumberFilter")) {
                String userId = req.getParameter("userId");
                String statusNumber = req.getParameter("statusNumber");
                if (userId != null) {
                    try {
                        int number = (statusNumber != null) ? OrderService.getInstance().ordersNumber(userId, Integer.parseInt(statusNumber)) : OrderService.getInstance().ordersNumber(userId);
                        resp.getWriter().write(String.valueOf(number));
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    }
}
