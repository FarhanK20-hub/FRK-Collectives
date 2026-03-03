package com.frk.dao;

import com.frk.model.Review;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ReviewDAO — Data Access Object for product reviews.
 */
public class ReviewDAO {

    public boolean addReview(Review review) {
        String sql = "INSERT INTO reviews (product_id, user_id, rating, comment) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, review.getProductId());
            ps.setInt(2, review.getUserId());
            ps.setInt(3, review.getRating());
            ps.setString(4, review.getComment());

            boolean success = ps.executeUpdate() > 0;
            if (success) {
                updateProductRating(review.getProductId());
            }
            return success;
        } catch (SQLException e) {
            System.err.println("Error adding review: " + e.getMessage());
            return false;
        }
    }

    public List<Review> getByProduct(int productId) {
        List<Review> reviews = new ArrayList<>();
        String sql = "SELECT r.*, u.name AS user_name FROM reviews r " +
                "JOIN users u ON r.user_id = u.id WHERE r.product_id = ? ORDER BY r.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Review review = new Review();
                    review.setId(rs.getInt("id"));
                    review.setProductId(rs.getInt("product_id"));
                    review.setUserId(rs.getInt("user_id"));
                    review.setUserName(rs.getString("user_name"));
                    review.setRating(rs.getInt("rating"));
                    review.setComment(rs.getString("comment"));
                    review.setCreatedAt(rs.getTimestamp("created_at"));
                    reviews.add(review);
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching reviews: " + e.getMessage());
        }
        return reviews;
    }

    /**
     * Updates the product's average rating and review count.
     */
    private void updateProductRating(int productId) {
        String sql = "UPDATE products SET " +
                "rating = (SELECT AVG(rating) FROM reviews WHERE product_id = ?), " +
                "review_count = (SELECT COUNT(*) FROM reviews WHERE product_id = ?) " +
                "WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setInt(2, productId);
            ps.setInt(3, productId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.err.println("Error updating product rating: " + e.getMessage());
        }
    }
}
