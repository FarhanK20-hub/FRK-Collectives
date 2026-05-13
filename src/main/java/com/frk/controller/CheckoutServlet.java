package com.frk.controller;

import com.frk.dao.AddressDAO;
import com.frk.dao.OrderDAO;
import com.frk.dao.ProductDAO;
import com.frk.model.*;
import com.frk.util.Constants;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

/**
 * CheckoutServlet — Handles the checkout flow.
 * Requires authenticated user. Creates order in database.
 *
 * SECURITY FIXES:
 * - Added null guard for session user in doPost
 * - Uses Constants for GST, shipping, and session keys
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
        if (session == null || session.getAttribute(Constants.SESSION_USER) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Check cart
        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute(Constants.SESSION_CART);

        if (cart == null || cart.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        // Load user addresses
        User user = (User) session.getAttribute(Constants.SESSION_USER);
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
        if (session == null || session.getAttribute(Constants.SESSION_USER) == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User user = (User) session.getAttribute(Constants.SESSION_USER);

        @SuppressWarnings("unchecked")
        List<CartItem> cart = (List<CartItem>) session.getAttribute(Constants.SESSION_CART);

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
        if (Constants.isBlank(shippingName) || Constants.isBlank(shippingPhone) || Constants.isBlank(shippingAddress)) {
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
        if (!Constants.isBlank(couponCode)) {
            if ("FRK10".equalsIgnoreCase(couponCode.trim())) {
                discount = subtotal * 0.10;
            } else if ("FRK20".equalsIgnoreCase(couponCode.trim())) {
                discount = subtotal * 0.20;
            }
        }

        double afterDiscount = subtotal - discount;
        double gst = afterDiscount * Constants.GST_RATE;
        double shipping = afterDiscount >= Constants.FREE_SHIPPING_THRESHOLD ? 0 : Constants.SHIPPING_FEE;
        double grandTotal = afterDiscount + gst + shipping;

        // Build order
        Order order = new Order();
        order.setUserId(user.getId());
        order.setSubtotal(subtotal);
        order.setGst(gst);
        order.setShipping(shipping);
        order.setGrandTotal(grandTotal);
        order.setStatus(Constants.STATUS_CONFIRMED);
        order.setShippingName(shippingName.trim());
        order.setShippingPhone(shippingPhone.trim());
        order.setShippingAddress(shippingAddress.trim());
        order.setCouponCode(!Constants.isBlank(couponCode) ? couponCode.trim() : null);
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
            for (CartItem cartItem : cart) {
                productDAO.decrementStock(cartItem.getProduct().getId(), cartItem.getQuantity());
            }

            session.removeAttribute(Constants.SESSION_CART);
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
        double gst = subtotal * Constants.GST_RATE;
        double shipping = subtotal >= Constants.FREE_SHIPPING_THRESHOLD ? 0 : Constants.SHIPPING_FEE;
        double grandTotal = subtotal + gst + shipping;

        request.setAttribute("subtotal", subtotal);
        request.setAttribute("gst", gst);
        request.setAttribute("shipping", shipping);
        request.setAttribute("grandTotal", grandTotal);
    }
}
