package com.frk.controller;

import com.frk.dao.AddressDAO;
import com.frk.dao.OrderDAO;
import com.frk.dao.ProductDAO;
import com.frk.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CheckoutServlet — Handles the checkout flow.
 * Requires authenticated user. Creates order in database.
 */
@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {

    private OrderDAO orderDAO;
    private AddressDAO addressDAO;
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        orderDAO = new OrderDAO();
        addressDAO = new AddressDAO();
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        // Check cart
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (session != null) ? (List<CartItem>) session.getAttribute("cart") : null;

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Load user addresses
        User user = (User) session.getAttribute("user");
        List<Address> addresses = addressDAO.getByUser(user.getId());
        request.setAttribute("addresses", addresses);

        // Calculate totals
        setCartTotals(request, cart);

        request.getRequestDispatcher("/checkout.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = (User) session.getAttribute("user");

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute("cart");

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Gather shipping info
        String shippingName = request.getParameter("shippingName");
        String shippingPhone = request.getParameter("shippingPhone");
        String shippingAddress = request.getParameter("shippingAddress");
        String couponCode = request.getParameter("couponCode");

        // Validate
        if (shippingName == null || shippingName.trim().isEmpty() ||
                shippingPhone == null || shippingPhone.trim().isEmpty() ||
                shippingAddress == null || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "Please fill in all shipping details.");
            setCartTotals(request, cart);
            List<Address> addresses = addressDAO.getByUser(user.getId());
            request.setAttribute("addresses", addresses);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
            return;
        }

        // Calculate totals
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getSubtotal();
        }

        double discount = 0;
        // Simple coupon logic
        if (couponCode != null && !couponCode.trim().isEmpty()) {
            if ("FRK10".equalsIgnoreCase(couponCode.trim())) {
                discount = subtotal * 0.10; // 10% off
            } else if ("FRK20".equalsIgnoreCase(couponCode.trim())) {
                discount = subtotal * 0.20; // 20% off
            }
        }

        double afterDiscount = subtotal - discount;
        double gst = afterDiscount * 0.18;
        double shipping = afterDiscount >= 2999 ? 0 : 199;
        double grandTotal = afterDiscount + gst + shipping;

        // Build order
        Order order = new Order();
        order.setUserId(user.getId());
        order.setSubtotal(subtotal);
        order.setGst(gst);
        order.setShipping(shipping);
        order.setGrandTotal(grandTotal);
        order.setStatus("CONFIRMED");
        order.setShippingName(shippingName.trim());
        order.setShippingPhone(shippingPhone.trim());
        order.setShippingAddress(shippingAddress.trim());
        order.setCouponCode(couponCode != null ? couponCode.trim() : null);
        order.setDiscount(discount);

        // Build order items
        List<OrderItem> orderItems = new ArrayList<>();
        for (CartItem cartItem : cart) {
            OrderItem orderItem = new OrderItem();
            orderItem.setProductId(cartItem.getProduct().getId());
            orderItem.setProductName(cartItem.getProduct().getName());
            orderItem.setQuantity(cartItem.getQuantity());
            orderItem.setSize(cartItem.getSelectedSize());
            orderItem.setPrice(cartItem.getProduct().getPrice());
            orderItems.add(orderItem);
        }
        order.setItems(orderItems);

        // Save order
        int orderId = orderDAO.createOrder(order);

        if (orderId > 0) {
            // Decrement stock for each item
            for (CartItem cartItem : cart) {
                productDAO.decrementStock(cartItem.getProduct().getId(), cartItem.getQuantity());
            }

            // Clear cart
            session.removeAttribute("cart");

            // Set order for confirmation page
            order.setId(orderId);
            request.setAttribute("order", order);
            request.getRequestDispatcher("/order-confirmation.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Failed to place order. Please try again.");
            setCartTotals(request, cart);
            request.getRequestDispatcher("/checkout.jsp").forward(request, response);
        }
    }

    private void setCartTotals(HttpServletRequest request, List<CartItem> cart) {
        double subtotal = 0;
        for (CartItem item : cart) {
            subtotal += item.getSubtotal();
        }
        double gst = subtotal * 0.18;
        double shipping = subtotal >= 2999 ? 0 : 199;
        double grandTotal = subtotal + gst + shipping;

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("gst", gst);
        request.setAttribute("shipping", shipping);
        request.setAttribute("grandTotal", grandTotal);
    }
}
