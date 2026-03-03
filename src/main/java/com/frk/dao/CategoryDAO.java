package com.frk.dao;

import com.frk.model.Category;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * CategoryDAO — Data Access Object for product categories.
 */
public class CategoryDAO {

    public List<Category> getAll() {
        List<Category> categories = new ArrayList<>();
        String sql = "SELECT * FROM categories ORDER BY name ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                categories.add(extractCategory(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching categories: " + e.getMessage());
        }
        return categories;
    }

    public Category getById(int id) {
        String sql = "SELECT * FROM categories WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return extractCategory(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching category by ID: " + e.getMessage());
        }
        return null;
    }

    public Category getBySlug(String slug) {
        String sql = "SELECT * FROM categories WHERE slug = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, slug);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return extractCategory(rs);
            }
        } catch (SQLException e) {
            System.err.println("Error fetching category by slug: " + e.getMessage());
        }
        return null;
    }

    private Category extractCategory(ResultSet rs) throws SQLException {
        Category cat = new Category();
        cat.setId(rs.getInt("id"));
        cat.setName(rs.getString("name"));
        cat.setSlug(rs.getString("slug"));
        cat.setDescription(rs.getString("description"));
        return cat;
    }
}
