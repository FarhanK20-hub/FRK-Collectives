package com.frk.dao;

import com.frk.model.Order;
import com.frk.model.OrderItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * OrderDAO — Data Access Object for order management.
 * Handles order creation, retrieval, and status updates.
 */
public class OrderDAO {

    /**
     * Creates a new order with its items in a transaction.
     *
     * @param order Order object with items populated
     * @return Generated order ID, or -1 on failure
     */
    public int createOrder(Order order) {
        String orderSql = "INSERT INTO orders (user_id, subtotal, gst, shipping, grand_total, status, " +
                "shipping_name, shipping_phone, shipping_address, coupon_code, discount) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        String itemSql = "INSERT INTO order_items (order_id, product_id, product_name, quantity, size, price) " +
                "VALUES (?, ?, ?, ?, ?, ?)";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            // Insert order
            int orderId;
            try (PreparedStatement ps = conn.prepareStatement(orderSql, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, order.getUserId());
                ps.setDouble(2, order.getSubtotal());
                ps.setDouble(3, order.getGst());
                ps.setDouble(4, order.getShipping());
                ps.setDouble(5, order.getGrandTotal());
                ps.setString(6, order.getStatus());
                ps.setString(7, order.getShippingName());
                ps.setString(8, order.getShippingPhone());
                ps.setString(9, order.getShippingAddress());
                ps.setString(10, order.getCouponCode());
                ps.setDouble(11, order.getDiscount());

                ps.executeUpdate();
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        orderId = keys.getInt(1);
                    } else {
                        conn.rollback();
                        return -1;
                    }
                }
            }

            // Insert order items
            try (PreparedStatement ps = conn.prepareStatement(itemSql)) {
                for (OrderItem item : order.getItems()) {
                    ps.setInt(1, orderId);
                    ps.setInt(2, item.getProductId());
                    ps.setString(3, item.getProductName());
                    ps.setInt(4, item.getQuantity());
                    ps.setString(5, item.getSize());
                    ps.setDouble(6, item.getPrice());
                    ps.addBatch();
                }
                ps.executeBatch();
            }

            conn.commit();
            return orderId;

        } catch (SQLException e) {
            System.err.println("Error creating order: " + e.getMessage());
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            return -1;
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
        }
    }

    /**
     * Retrieves orders for a specific user.
     */
    public List<Order> getOrdersByUser(int userId) {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Order order = extractOrder(rs);
                    order.setItems(getOrderItems(order.getId()));
                    orders.add(order);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching user orders: " + e.getMessage());
        }
        return orders;
    }

    /**
     * Retrieves a single order by ID.
     */
    public Order getOrderById(int orderId) {
        String sql = "SELECT o.*, u.name AS user_name FROM orders o " +
                "JOIN users u ON o.user_id = u.id WHERE o.id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Order order = extractOrder(rs);
                    try {
                        order.setUserName(rs.getString("user_name"));
                    } catch (SQLException ignored) {
                    }
                    order.setItems(getOrderItems(orderId));
                    return order;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order by ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves all orders (admin).
     */
    public List<Order> getAllOrders() {
        List<Order> orders = new ArrayList<>();
        String sql = "SELECT o.*, u.name AS user_name FROM orders o " +
                "JOIN users u ON o.user_id = u.id ORDER BY o.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Order order = extractOrder(rs);
                try {
                    order.setUserName(rs.getString("user_name"));
                } catch (SQLException ignored) {
                }
                orders.add(order);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all orders: " + e.getMessage());
        }
        return orders;
    }

    /**
     * Updates order status.
     */
    public boolean updateStatus(int orderId, String status) {
        String sql = "UPDATE orders SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setInt(2, orderId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating order status: " + e.getMessage());
            return false;
        }
    }

    /**
     * Gets total order count (admin stats).
     */
    public int getOrderCount() {
        String sql = "SELECT COUNT(*) FROM orders";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting orders: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Gets total revenue (admin stats).
     */
    public double getTotalRevenue() {
        String sql = "SELECT COALESCE(SUM(grand_total), 0) FROM orders WHERE status != 'CANCELLED'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getDouble(1);
        } catch (SQLException e) {
            System.err.println("Error calculating revenue: " + e.getMessage());
        }
        return 0;
    }

    private List<OrderItem> getOrderItems(int orderId) {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT * FROM order_items WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, orderId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setProductName(rs.getString("product_name"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setSize(rs.getString("size"));
                    item.setPrice(rs.getDouble("price"));
                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching order items: " + e.getMessage());
        }
        return items;
    }

    private Order extractOrder(ResultSet rs) throws SQLException {
        Order order = new Order();
        order.setId(rs.getInt("id"));
        order.setUserId(rs.getInt("user_id"));
        order.setSubtotal(rs.getDouble("subtotal"));
        order.setGst(rs.getDouble("gst"));
        order.setShipping(rs.getDouble("shipping"));
        order.setGrandTotal(rs.getDouble("grand_total"));
        order.setStatus(rs.getString("status"));
        order.setShippingName(rs.getString("shipping_name"));
        order.setShippingPhone(rs.getString("shipping_phone"));
        order.setShippingAddress(rs.getString("shipping_address"));
        order.setCouponCode(rs.getString("coupon_code"));
        order.setDiscount(rs.getDouble("discount"));
        order.setCreatedAt(rs.getTimestamp("created_at"));
        return order;
    }
}
