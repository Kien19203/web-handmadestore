package model.bean;

public class OrderDetail {
    private int orderId;
    private int productId;
    private int quantity;

    public OrderDetail() {
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    @Override
    public String toString() {
        return
                "orderId=" + orderId +
                        "{" + productId + " - " + quantity +
                        '}';
    }
}
