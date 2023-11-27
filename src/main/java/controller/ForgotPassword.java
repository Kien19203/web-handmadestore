package controller;

import model.bean.User;
import model.dao.UserDAO;
import model.db.JDBIConnector;
import model.service.RoleService;
import model.service.UserService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet(urlPatterns = {"/forgotpassword"})
public class ForgotPassword extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        super.doPost(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html; charset=UTF-8");
        String action = req.getParameter("action");

        if ("back_login".equals(action)) {
            // Handle back button click
            resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/login.jsp");
        }else if("back_forgotpassword".equals(action)){
            resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/forgotpassword.jsp");
        } else {

            String page = req.getParameter("page");
            if (page.equals("1")) {
                String email = req.getParameter("email");

                User user = UserDAO.getUserByEmail(email);
                if (user != null) {
                    req.getSession().setAttribute("code", "abcd");
                    req.getSession().setAttribute("email", email);
                    //gởi email
                    resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/forgotpw_code.jsp?email=" + email);
                } else {
                    req.setAttribute("result", "Email không tồn tại trong hệ thống");
                    req.getRequestDispatcher("views/Login/view_login/forgotpassword.jsp").forward(req, resp);
                }
            } else if (page.equals("2")) {
                String code_input = req.getParameter("code_input");
                String email = (String) req.getSession().getAttribute("email");
                String code = (String) req.getSession().getAttribute("code");
                if (email != null && code.equals(code_input)) {
                    resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/resetpw.jsp?email=" + email);
                    req.getSession().removeAttribute("code");
                } else if ((email != null && !code.equals(code_input))) {
                    req.setAttribute("result", "Mã không chính xác");
                    req.getRequestDispatcher("views/Login/view_login/forgotpw_code.jsp?email=" + email).forward(req, resp);
                } else
                    resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/forgotpassword.jsp");

            } else if (page.equals("3")) {
                String email = (String) req.getSession().getAttribute("email");
                req.getSession().removeAttribute("email");
                String new_pw = req.getParameter("new_pw");
                String confirm_new_pw = req.getParameter("confirm_new_pw");
                if (new_pw.equals(confirm_new_pw)) {
                    //update password
                    UserDAO.setPasswordByEmail(email, new_pw);
                    resp.sendRedirect(req.getContextPath() + "/views/Login/view_login/login.jsp");
                } else {
                    req.setAttribute("result", "Mật khẩu xác nhận không khớp. Vui lòng thử lại");
                    req.setAttribute("new_pw", null);
                    req.setAttribute("confirm_new_pw", null);
                    req.getRequestDispatcher("views/Login/view_login/resetpw.jsp?email=" + email).forward(req, resp);
                }
            }
        }
    }
}

