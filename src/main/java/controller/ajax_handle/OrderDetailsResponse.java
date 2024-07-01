package controller.ajax_handle;

import model.bean.*;

import java.io.Serializable;
import java.util.HashMap;
import java.util.List;

public class OrderDetailsResponse implements Serializable {
    private Order order;
    private List<OrderDetailMapping> orderDetailMappings;

    public OrderDetailsResponse(Order order, List<OrderDetailMapping> orderDetailMappings) {
        this.order = order;
        this.orderDetailMappings = orderDetailMappings;
    }

    public Order getOrder() {
        return order;
    }

    public void setOrder(Order order) {
        this.order = order;
    }

    public List<OrderDetailMapping> getOrderDetails() {
        return orderDetailMappings;
    }

    public void setOrderDetails(List<OrderDetailMapping> orderDetailMappings) {
        this.orderDetailMappings = orderDetailMappings;
    }
}