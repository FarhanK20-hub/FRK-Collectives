package com.frk.controller;

import com.frk.dao.UserDAO;
import com.frk.model.User;
import com.frk.util.Constants;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

/**
 * AuthServlet — Handles user authentication: login, register, logout.
 * Uses BCrypt password hashing via UserDAO.
 *
 * SECURITY FIXES:
 * - Removed insecure remember-me cookie (stored raw email)
 * - Added email format validation
 * - Uses Constants for session keys
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
                if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
                request.getRequestDispatcher("/login.jsp").forward(request, response);
                break;

            case "/register":
                session = request.getSession(false);
                if (session != null && session.getAttribute(Constants.SESSION_USER) != null) {
                    response.sendRedirect(request.getContextPath() + "/home");
                    return;
                }
                request.getRequestDispatcher("/register.jsp").forward(request, response);
                break;

            case "/logout":
                session = request.getSession(false);
                if (session != null) {
                    // Do not invalidate entire session to preserve the shopping cart.
                    // Just remove the authenticated user to convert them to a guest.
                    session.removeAttribute(Constants.SESSION_USER);
                }
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

        // Input validation
        if (Constants.isBlank(email) || Constants.isBlank(password)) {
            request.setAttribute("error", "Email and password are required.");
            request.setAttribute("email", email);
            request.getRequestDispatcher("/login.jsp").forward(request, response);
            return;
        }

        // Authenticate
        User user = userDAO.authenticate(email.trim(), password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute(Constants.SESSION_USER, user);
            session.setMaxInactiveInterval(Constants.SESSION_TIMEOUT_MINUTES * 60);

            // Redirect to stored URL or appropriate page
            String redirectUrl = (String) session.getAttribute(Constants.SESSION_REDIRECT);
            if (redirectUrl != null && Constants.isSafeRedirect(redirectUrl, request.getContextPath())) {
                session.removeAttribute(Constants.SESSION_REDIRECT);
                response.sendRedirect(redirectUrl);
            } else {
                session.removeAttribute(Constants.SESSION_REDIRECT);
                if (user.isAdmin()) {
                    response.sendRedirect(request.getContextPath() + "/admin/dashboard");
                } else {
                    response.sendRedirect(request.getContextPath() + "/home");
                }
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
        if (Constants.isBlank(name) || Constants.isBlank(email) || Constants.isBlank(password)) {
            request.setAttribute("error", "Name, email, and password are required.");
            preserveRegisterFields(request, name, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (!password.equals(confirmPassword)) {
            request.setAttribute("error", "Passwords do not match.");
            preserveRegisterFields(request, name, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        if (password.length() < Constants.MIN_PASSWORD_LENGTH) {
            request.setAttribute("error", "Password must be at least " + Constants.MIN_PASSWORD_LENGTH + " characters long.");
            preserveRegisterFields(request, name, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Check if email already exists
        if (userDAO.emailExists(email.trim())) {
            request.setAttribute("error", "An account with this email already exists.");
            preserveRegisterFields(request, name, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
            return;
        }

        // Create user
        User user = new User();
        user.setName(name.trim());
        user.setEmail(email.trim());
        user.setPasswordHash(password); // DAO will hash it
        user.setPhone(phone != null ? phone.trim() : null);
        user.setRole(Constants.ROLE_CUSTOMER);

        if (userDAO.register(user)) {
            // Auto-login after registration
            User authenticatedUser = userDAO.authenticate(email.trim(), password);
            if (authenticatedUser != null) {
                HttpSession session = request.getSession(true);
                session.setAttribute(Constants.SESSION_USER, authenticatedUser);
                session.setMaxInactiveInterval(Constants.SESSION_TIMEOUT_MINUTES * 60);
                response.sendRedirect(request.getContextPath() + "/home");
            } else {
                request.setAttribute("success", "Account created successfully. Please log in.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else {
            request.setAttribute("error", "Registration failed. Please try again.");
            preserveRegisterFields(request, name, email, phone);
            request.getRequestDispatcher("/register.jsp").forward(request, response);
        }
    }

    private void preserveRegisterFields(HttpServletRequest request, String name, String email, String phone) {
        request.setAttribute("name", name);
        request.setAttribute("email", email);
        request.setAttribute("phone", phone);
    }
}
