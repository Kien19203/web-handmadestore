package controller;

import model.bean.Cart;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(name = "CartController", value = "/add-cart")
public class AddCartController extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        Cart cart = (Cart) sessions.getAttribute("cart");
        if(cart == null) {
            cart= new Cart();
        }
        sessions.setAttribute("cart", cart);

        doPost(req, resp);

    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession sessions = req.getSession();
        Cart cart = (Cart) sessions.getAttribute("cart");
        String action = req.getParameter("actionCart");
         String referer = req.getHeader("Referer");//Hàm lấy url của trang hiện tại để reload
        switch (action) {
            case "get":

//                req.getRequestDispatcher(req.getContextPath()+"/views/CartPage/cart.jsp").forward(req, resp);
                resp.sendRedirect(referer);
//                resp.sendRedirect(req.getContextPath()+"/views/CartPage/cart.jsp" );
                break;

            case "delete":
                DeleteP(req,resp);
                resp.sendRedirect(referer);
                            break;
            case "put":
                putP(req,resp);
//                resp.sendRedirect(referer);
//                req.getRequestDispatcher(req.getContextPath() +"/add-cart?actionCart=get").forward(req,resp);
                break;

            case "post":
            int id = Integer.parseInt(req.getParameter("id")); // lay id product
                int num = Integer.parseInt(req.getParameter("num"));
            cart.add(id, num);
            sessions.setAttribute("cart", cart);
                resp.sendRedirect(referer);
            break;
            default:

                break;
        }

    }

    protected void putP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession sessions = req.getSession();
        Cart cart = (Cart) sessions.getAttribute("cart");
        int id = Integer.parseInt(req.getParameter("id"));
        int num = Integer.parseInt(req.getParameter("num"));
        if((num==-1) && (cart.getQuantityById(id) <= 1)) {
            cart.remove(id);
        }
        else {
          cart.add(id, num);
        }
        sessions.setAttribute("cart", cart);
        req.getRequestDispatcher("/add-cart?actionCart=get").forward(req,resp);
//        resp.sendRedirect(req.getContextPath() + "/add-cart?actionCart=get");

    }


    protected void DeleteP(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {

        HttpSession sessions = req.getSession();
        Cart cart = (Cart) sessions.getAttribute("cart");
        int id = Integer.parseInt(req.getParameter("id"));
        cart.remove(id);
        sessions.setAttribute("cart", cart);
//        req.getRequestDispatcher("/add-cart?actionCart=get").forward(req,resp);
    }

}
