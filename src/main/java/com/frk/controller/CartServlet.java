package com.frk.controller;

import com.frk.dao.ProductDAO;
import com.frk.model.CartItem;
import com.frk.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CartServlet — Handles shopping cart operations.
 * Cart is stored in HttpSession. Supports add, remove, update with size
 * selection.
 */
@WebServlet("/cart")
public class CartServlet extends HttpServlet {

    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart != null && !cart.isEmpty()) {
            // Calculate totals
            double subtotal = 0;
            for (CartItem item : cart) {
                subtotal += item.getSubtotal();
            }

            double gst = subtotal * 0.18; // 18% GST
            double shipping = subtotal >= 2999 ? 0 : 199; // Free shipping over ₹2,999
            double grandTotal = subtotal + gst + shipping;

            request.setAttribute("subtotal", subtotal);
            request.setAttribute("gst", gst);
            request.setAttribute("shipping", shipping);
            request.setAttribute("grandTotal", grandTotal);
            request.setAttribute("freeShippingThreshold", 2999);
        }

        request.getRequestDispatcher("/cart.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        HttpSession session = request.getSession();

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");
        if (cart == null) {
            cart = new ArrayList<>();
            session.setAttribute("cart", cart);
        }

        try {
            if ("add".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String size = request.getParameter("size");
                if (size == null || size.isEmpty())
                    size = "M";

                // Check if product with same size already exists in cart
                boolean found = false;
                for (CartItem item : cart) {
                    if (item.getProduct().getId() == productId &&
                            size.equals(item.getSelectedSize())) {
                        item.setQuantity(item.getQuantity() + 1);
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    Product product = productDAO.getProductById(productId);
                    if (product != null) {
                        cart.add(new CartItem(product, 1, size));
                    }
                }

                // Set recently viewed cookie
                Cookie viewedCookie = new Cookie("last_viewed", String.valueOf(productId));
                viewedCookie.setMaxAge(60 * 60 * 24);
                viewedCookie.setPath("/");
                response.addCookie(viewedCookie);

                response.sendRedirect(request.getContextPath() + "/cart");
                return;

            } else if ("remove".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                String size = request.getParameter("size");
                cart.removeIf(item -> item.getProduct().getId() == productId &&
                        (size == null || size.equals(item.getSelectedSize())));

                response.sendRedirect(request.getContextPath() + "/cart");
                return;

            } else if ("update".equals(action)) {
                int productId = Integer.parseInt(request.getParameter("productId"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));
                String size = request.getParameter("size");

                if (quantity <= 0) {
                    cart.removeIf(item -> item.getProduct().getId() == productId &&
                            (size == null || size.equals(item.getSelectedSize())));
                } else {
                    for (CartItem item : cart) {
                        if (item.getProduct().getId() == productId &&
                                (size == null || size.equals(item.getSelectedSize()))) {
                            item.setQuantity(quantity);
                            break;
                        }
                    }
                }
                response.sendRedirect(request.getContextPath() + "/cart");
                return;
            }

        } catch (NumberFormatException e) {
            System.err.println("Cart error: invalid number format - " + e.getMessage());
        }

        response.sendRedirect(request.getContextPath() + "/cart");
    }
}
