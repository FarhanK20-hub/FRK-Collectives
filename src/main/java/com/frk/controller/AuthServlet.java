package com.frk.controller;

import com.frk.dao.UserDAO;
import com.frk.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthServlet — Handles user authentication: login, register, logout.
 * Uses BCrypt password hashing via UserDAO.
 */
@WebServlet(urlPatterns = { "/login", "/register", "/logout" })
public class AuthServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/login":
                // Check if already logged in
                HttpSession session = request.getSession(false);
                if (session != null && session.getAttribute("user") != null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;

            case "/register":
                session = request.getSession(false);
                if (session != null && session.getAttribute("user") != null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;

            case "/logout":
                session = request.getSession(false);
                if (session != null) {
                    session.invalidate();
                }
                // Clear remember-me cookie
                Cookie cookie = new Cookie("frk_remember", "");
                cookie.setMaxAge(0);
                cookie.setPath("/");
                response.addCookie(cookie);

                response.sendRedirect(request.getContextPath() + "/home");
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/home");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/register".equals(path)) {
            handleRegister(request, response);
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String remember = request.getParameter("remember");

        // Input validation
        if (email == null || email.trim().isEmpty() || password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Email and password are required.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate
        User user = userDAO.authenticate(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Remember me cookie
            if ("on".equals(remember)) {
                Cookie rememberCookie = new Cookie("frk_remember", user.getEmail());
                rememberCookie.setMaxAge(60 * 60 * 24 * 30); // 30 days
                rememberCookie.setHttpOnly(true);
                rememberCookie.setPath("/");
                response.addCookie(rememberCookie);
            }

            // Redirect to stored URL or appropriate page
            String redirectUrl = (String) session.getAttribute("redirectAfterLogin");
            if (redirectUrl != null) {
                session.removeAttribute("redirectAfterLogin");
                response.sendRedirect(redirectUrl);
            } else if (user.isAdmin()) {
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
            } else {
                response.sendRedirect(request.getContextPath() + "/home");
            }
        } else {
            request.setAttribute("error", "Invalid email or password. Please try again.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String confirmPassword = request.getParameter("confirmPassword");
        String phone = request.getParameter("phone");

        // Input validation
        if (name == null || name.trim().isEmpty() ||
                email == null || email.trim().isEmpty() ||
                password == null || password.trim().isEmpty()) {
            request.setAttribute("error", "Name, email, and password are required.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < 6) {
            request.setAttribute("error", "Password must be at least 6 characters long.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("error", "An account with this email already exists.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(password); // DAO will hash it
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole("CUSTOMER");

        if (userDAO.register(user)) {
            // Auto-login after registration
            User authenticatedUser = userDAO.authenticate(email.trim(), password);
            if (authenticatedUser != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute("user", authenticatedUser);
                session.setMaxInactiveInterval(30 * 60);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("success", "Account created successfully. Please log in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            request.setAttribute("name", name);
            request.setAttribute("email", email);
            request.setAttribute("phone", phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }
}
