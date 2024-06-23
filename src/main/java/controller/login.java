package controller;

import io.ipinfo.api.IPinfo;
import io.ipinfo.api.errors.RateLimitedException;
import io.ipinfo.api.model.IPResponse;
import model.bean.Cart;
import model.bean.User;
import model.dao.UserDAO;
import model.service.UserService;
import utils.HashPassword;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.net.Socket;

@WebServlet("/login")
public class login extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/jsp; charset=UTF-8");
        req.getSession().invalidate();
        req.removeAttribute("auth");
        req.getSession().removeAttribute("isAdmin");
        String email = req.getParameter("email");
        String pw = req.getParameter("password");
        pw = HashPassword.toSHA1(pw);
        Cart cart = new Cart();
        User checkEmail = UserDAO.getUserByEmail(email);
        User user = UserService.getInstance().checkLogin(email, pw);

        String clientIP = req.getRemoteAddr();
        String clientLocation = getLocation(clientIP);

        System.out.println("Ip: " + clientIP + " - Location: " + clientLocation);
        if (email == null) {
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        } else if (checkEmail == null) {
            req.setAttribute("errEmail", "Email không tồn tại!");
            req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
        }
        if (user != null) {
            if (user.isLock()) {
                req.setAttribute("result", "Tài khoản đã bị vô hiệu hóa!");
                req.getRequestDispatcher("./views/Login/view_login/login.jsp").forward(req, resp);
            } else {
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

    private String getLocation(String ipAddress) {
        IPinfo ipInfo = new IPinfo.Builder()
                .setToken("c354a4c7f892c2")
                .build();
        try {
            IPResponse response = ipInfo.lookupIP(ipAddress);
            return response.getCity() + ", " + response.getRegion() + ", " + response.getCountryName();
        } catch (RateLimitedException ex) {
            ex.printStackTrace();
            return "Rate limit exceeded";
        }
    }
}
