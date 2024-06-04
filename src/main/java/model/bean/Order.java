package model.bean;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Order implements Serializable {
    private int id;
    private double totalPrice;
    private Timestamp orderDate;
    private String status;
    private String consigneeName;
    private String consigneePhoneNumber;
    private String address;

    private double shippingFee;
    private int userId;
    private String note;


    public Order() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Timestamp getOrderDate() {
        return orderDate;
    }

    public void setOrderDate(Timestamp orderDate) {
        this.orderDate = orderDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public double getShippingFee() {
        return shippingFee;
    }

    public void setShippingFee(double shippingFee) {
        this.shippingFee = shippingFee;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getConsigneeName() {
        return consigneeName;
    }

    public void setConsigneeName(String consigneeName) {
        this.consigneeName = consigneeName;
    }

    public String getConsigneePhoneNumber() {
        return consigneePhoneNumber;
    }

    public void setConsigneePhoneNumber(String consigneePhoneNumber) {
        this.consigneePhoneNumber = consigneePhoneNumber;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public boolean isWaitConfirmOrder() {
        return this.getStatus().equalsIgnoreCase("Chờ xác nhận");
    }

    public boolean isPackingOrder() {
        return this.getStatus().equalsIgnoreCase("Đang đóng gói");
    }

    public boolean isDeliveringOrder() {
        return this.getStatus().equalsIgnoreCase("Đang giao");
    }

    public boolean isSucccessfulOrder() {
        return this.getStatus().equalsIgnoreCase("Thành công");
    }

    public boolean isCanceledOrder() {
        return this.getStatus().equalsIgnoreCase("Đã hủy");
    }

    @Override
    public String toString() {
        return "Order{" +
                "id=" + id +
                ", totalPrice=" + totalPrice +
                ", orderDate=" + orderDate +
                ", status='" + status + '\'' +
                ", consigneeName='" + consigneeName + '\'' +
                ", consigneePhoneNumber='" + consigneePhoneNumber + '\'' +
                ", address='" + address + '\'' +
                ", note='" + note + '\'' +
                ", shippingFee=" + shippingFee +
                ", userId=" + userId +
                '}';
    }
}
