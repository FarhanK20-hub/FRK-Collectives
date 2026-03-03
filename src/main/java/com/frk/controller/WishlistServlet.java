package com.frk.controller;

import com.frk.dao.WishlistDAO;
import com.frk.model.User;
import com.frk.model.WishlistItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * WishlistServlet — Handles wishlist add/remove/view operations.
 * Requires authenticated user (protected by AuthFilter).
 */
@WebServlet(urlPatterns = { "/wishlist", "/wishlist/add", "/wishlist/remove" })
public class WishlistServlet extends HttpServlet {

    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        List<WishlistItem> wishlistItems = wishlistDAO.getByUser(user.getId());
        request.setAttribute("wishlistItems", wishlistItems);

        request.getRequestDispatcher("/wishlist.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");
        String path = request.getServletPath();

        String productIdParam = request.getParameter("productId");
        String redirectUrl = request.getParameter("redirect");

        if (productIdParam == null) {
            response.sendRedirect(request.getContextPath() + "/wishlist");
            return;
        }

        try {
            int productId = Integer.parseInt(productIdParam);

            if ("/wishlist/add".equals(path)) {
                wishlistDAO.add(user.getId(), productId);
            } else if ("/wishlist/remove".equals(path)) {
                wishlistDAO.remove(user.getId(), productId);
            }

        } catch (NumberFormatException e) {
            System.err.println("Wishlist error: " + e.getMessage());
        }

        if (redirectUrl != null && !redirectUrl.isEmpty()) {
            response.sendRedirect(redirectUrl);
        } else {
            response.sendRedirect(request.getContextPath() + "/wishlist");
        }
    }
}
