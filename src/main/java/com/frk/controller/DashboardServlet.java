package com.frk.controller;

import com.frk.dao.AddressDAO;
import com.frk.dao.OrderDAO;
import com.frk.dao.UserDAO;
import com.frk.dao.WishlistDAO;
import com.frk.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet — Handles the user dashboard.
 * Tabs: profile, orders, wishlist, addresses.
 */
@WebServlet(urlPatterns = { "/dashboard", "/dashboard/profile", "/dashboard/orders",
        "/dashboard/addresses", "/dashboard/address/add", "/dashboard/address/delete" })
public class DashboardServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private WishlistDAO wishlistDAO;
    private AddressDAO addressDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        wishlistDAO = new WishlistDAO();
        addressDAO = new AddressDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        // Determine active tab
        String tab = "profile";
        if (path.contains("/orders"))
            tab = "orders";
        else if (path.contains("/addresses"))
            tab = "addresses";

        request.setAttribute("activeTab", tab);

        // Load data based on tab
        switch (tab) {
            case "orders":
                List<Order> orders = orderDAO.getOrdersByUser(user.getId());
                request.setAttribute("orders", orders);
                break;
            case "addresses":
                List<Address> addresses = addressDAO.getByUser(user.getId());
                request.setAttribute("addresses", addresses);
                break;
            default:
                // Profile - reload fresh user data
                User freshUser = userDAO.findById(user.getId());
                if (freshUser != null) {
                    request.setAttribute("profileUser", freshUser);
                }
                break;
        }

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        if ("/dashboard/profile".equals(path)) {
            // Update profile
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");

            if (name != null && !name.trim().isEmpty()) {
                user.setName(name.trim());
                user.setPhone(phone != null ? phone.trim() : user.getPhone());

                if (userDAO.updateProfile(user)) {
                    session.setAttribute("user", user);
                    request.setAttribute("success", "Profile updated successfully.");
                } else {
                    request.setAttribute("error", "Failed to update profile.");
                }
            }

            request.setAttribute("activeTab", "profile");
            request.setAttribute("profileUser", user);
            request.getRequestDispatcher("/dashboard.jsp").forward(request, response);

        } else if ("/dashboard/address/add".equals(path)) {
            Address address = new Address();
            address.setUserId(user.getId());
            address.setName(request.getParameter("addressName"));
            address.setPhone(request.getParameter("addressPhone"));
            address.setLine1(request.getParameter("line1"));
            address.setLine2(request.getParameter("line2"));
            address.setCity(request.getParameter("city"));
            address.setState(request.getParameter("state"));
            address.setPincode(request.getParameter("pincode"));
            address.setDefault("on".equals(request.getParameter("isDefault")));

            addressDAO.add(address);
            response.sendRedirect(request.getContextPath() + "/dashboard/addresses");

        } else if ("/dashboard/address/delete".equals(path)) {
            String idParam = request.getParameter("addressId");
            if (idParam != null) {
                try {
                    addressDAO.delete(Integer.parseInt(idParam), user.getId());
                } catch (NumberFormatException ignored) {
                }
            }
            response.sendRedirect(request.getContextPath() + "/dashboard/addresses");
        }
    }
}
