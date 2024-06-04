package model.service;

import model.adapter.InventoryProduct;
import model.dao.InventoryDAO;

import java.util.List;

public class InventoryService {

    public static InventoryService instance;

    public static InventoryService getInstance() {
        if(instance==null) instance = new InventoryService();
        return  instance;
    }

    public List<InventoryProduct> showInventoryView() {
        return InventoryDAO.showInventoryView();
    }




}
