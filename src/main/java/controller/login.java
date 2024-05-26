package controller;

import model.bean.Cart;
import model.bean.Role;
import model.bean.User;
import model.dao.UserDAO;
import model.service.RoleService;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.*;

@WebServlet("/login")
public class login extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");

        req.removeAttribute("auth");
        req.getSession().removeAttribute("isAdmin");
        String email = req.getParameter("email");// nhận input từ ng dùng
        String pw = req.getParameter("password");
        pw = HashPassword.toSHA1(pw);// Hàm băm code
        Cart cart = new Cart();
        User checkEmail = UserDAO.getUserByEmail(email);
        User user = UserService.getInstance().checkLogin(email, pw);
        if (email == null) {
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        } else if (checkEmail == null) {
            req.setAttribute("errEmail", "Email không tồn tại!");
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        }
        if (user != null) {
            if(user.isLock()){
                req.setAttribute("result", "Tài khoản đã bị vô hiệu hóa!");
                req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
            }else{
                HttpSession session = req.getSession();
                session.setAttribute("auth", user);
                if (user.isOwn() || user.isAdmin()) {
                    req.getSession().setAttribute("isAdmin", true);
                    resp.sendRedirect(req.getContextPath() + "/views/Admin/admin.jsp");
                } else {
                    req.getSession().setAttribute("isAdmin", false);
                    resp.sendRedirect(req.getContextPath() + "/views/MainPage/view_mainpage/mainpage.jsp");
                }
            }
        } else {
            req.setAttribute("result", "Mật khẩu không chính xác!");
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        }
    }
}
