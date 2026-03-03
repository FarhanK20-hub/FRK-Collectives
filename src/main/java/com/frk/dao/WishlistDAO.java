package com.frk.dao;

import com.frk.model.Product;
import com.frk.model.WishlistItem;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * WishlistDAO — Data Access Object for user wishlist management.
 */
public class WishlistDAO {

    public boolean add(int userId, int productId) {
        String sql = "INSERT IGNORE INTO wishlist (user_id, product_id) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding to wishlist: " + e.getMessage());
            return false;
        }
    }

    public boolean remove(int userId, int productId) {
        String sql = "DELETE FROM wishlist WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error removing from wishlist: " + e.getMessage());
            return false;
        }
    }

    public List<WishlistItem> getByUser(int userId) {
        List<WishlistItem> items = new ArrayList<>();
        String sql = "SELECT w.*, p.name, p.price, p.brand, p.short_description, p.rating, p.stock, " +
                "c.name AS category_name, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image "
                +
                "FROM wishlist w " +
                "JOIN products p ON w.product_id = p.id " +
                "JOIN categories c ON p.category_id = c.id " +
                "ORDER BY w.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    WishlistItem item = new WishlistItem();
                    item.setId(rs.getInt("id"));
                    item.setUserId(rs.getInt("user_id"));
                    item.setProductId(rs.getInt("product_id"));
                    item.setCreatedAt(rs.getTimestamp("created_at"));

                    Product product = new Product();
                    product.setId(rs.getInt("product_id"));
                    product.setName(rs.getString("name"));
                    product.setPrice(rs.getDouble("price"));
                    product.setBrand(rs.getString("brand"));
                    product.setShortDescription(rs.getString("short_description"));
                    product.setRating(rs.getDouble("rating"));
                    product.setStock(rs.getInt("stock"));
                    product.setCategoryName(rs.getString("category_name"));
                    product.setPrimaryImageUrl(rs.getString("primary_image"));
                    item.setProduct(product);

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching wishlist: " + e.getMessage());
        }
        return items;
    }

    public boolean isInWishlist(int userId, int productId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ? AND product_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.err.println("Error checking wishlist: " + e.getMessage());
        }
        return false;
    }

    public int getWishlistCount(int userId) {
        String sql = "SELECT COUNT(*) FROM wishlist WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting wishlist: " + e.getMessage());
        }
        return 0;
    }
}
