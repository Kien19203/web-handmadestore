package controller.ajax_handle;

import model.bean.Order;
import model.bean.OrderDetail;
import model.bean.Product;
import model.bean.User;

import java.util.List;

public class OrderResponse {
    private Order order;
    private User user;
    private List<OrderDetail> orderDetails;
    private List<Product> mappingProducts;

    public OrderResponse(Order order, User user, List<OrderDetail> orderDetails, List<Product> mappingProducts) {
        this.order = order;
        this.user = user;
        this.orderDetails = orderDetails;
        this.mappingProducts = mappingProducts;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public List<OrderDetail> getOrderDetails() {
        return orderDetails;
    }

    public void setOrderDetails(List<OrderDetail> orderDetails) {
        this.orderDetails = orderDetails;
    }

    public List<Product> getMappingProducts() {
        return mappingProducts;
    }

    public void setMappingProducts(List<Product> mappingProducts) {
        this.mappingProducts = mappingProducts;
    }
}