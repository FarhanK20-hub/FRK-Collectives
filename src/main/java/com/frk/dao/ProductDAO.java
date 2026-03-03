package com.frk.dao;

import com.frk.model.Product;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * ProductDAO — Data Access Object for product catalog operations.
 * Supports search, filter, sort, pagination, and admin CRUD.
 */
public class ProductDAO {

    /**
     * Retrieves all products with primary image and category name.
     */
    public List<Product> getAllProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image "
                +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "ORDER BY p.created_at DESC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching all products: " + e.getMessage());
        }
        return products;
    }

    /**
     * Retrieves a product by ID with all images.
     */
    public Product getProductById(int id) {
        String sql = "SELECT p.*, c.name AS category_name, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image "
                +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "WHERE p.id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Product product = extractProduct(rs);
                    // Load all images
                    product.setImages(getProductImages(id));
                    return product;
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product by ID: " + e.getMessage());
        }
        return null;
    }

    /**
     * Retrieves featured products for the landing page.
     */
    public List<Product> getFeaturedProducts() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image "
                +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "WHERE p.is_featured = TRUE ORDER BY p.rating DESC LIMIT 6";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching featured products: " + e.getMessage());
        }
        return products;
    }

    /**
     * Retrieves best-selling products (highest review count).
     */
    public List<Product> getBestSellers() {
        List<Product> products = new ArrayList<>();
        String sql = "SELECT p.*, c.name AS category_name, " +
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image "
                +
                "FROM products p JOIN categories c ON p.category_id = c.id " +
                "ORDER BY p.review_count DESC LIMIT 4";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                products.add(extractProduct(rs));
            }
        } catch (SQLException e) {
            System.err.println("Error fetching best sellers: " + e.getMessage());
        }
        return products;
    }

    /**
     * Advanced product search with filters, sort, and pagination.
     *
     * @param search     Search term (name/description)
     * @param categoryId Filter by category (0 = all)
     * @param minPrice   Minimum price (0 = no min)
     * @param maxPrice   Maximum price (0 = no max)
     * @param size       Size filter (null/empty = all)
     * @param minRating  Minimum rating (0 = no filter)
     * @param sortBy     Sort: "price_asc", "price_desc", "newest", "popular",
     *                   "rating"
     * @param page       Page number (1-based)
     * @param pageSize   Items per page
     */
    public List<Product> getFilteredProducts(String search, int categoryId, double minPrice,
            double maxPrice, String size, double minRating,
            String sortBy, int page, int pageSize) {
        List<Product> products = new ArrayList<>();
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT p.*, c.name AS category_name, ");
        sql.append(
                "(SELECT pi.image_url FROM product_images pi WHERE pi.product_id = p.id AND pi.is_primary = TRUE LIMIT 1) AS primary_image ");
        sql.append("FROM products p JOIN categories c ON p.category_id = c.id WHERE 1=1 ");

        // Search filter
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.short_description LIKE ? OR p.detailed_description LIKE ?) ");
            String searchTerm = "%" + search.trim() + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }

        // Category filter
        if (categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }

        // Price range filter
        if (minPrice > 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }

        // Size filter
        if (size != null && !size.trim().isEmpty()) {
            sql.append("AND FIND_IN_SET(?, p.size_options) > 0 ");
            params.add(size.trim());
        }

        // Rating filter
        if (minRating > 0) {
            sql.append("AND p.rating >= ? ");
            params.add(minRating);
        }

        // Sort order
        if (sortBy == null)
            sortBy = "newest";
        switch (sortBy) {
            case "price_asc":
                sql.append("ORDER BY p.price ASC ");
                break;
            case "price_desc":
                sql.append("ORDER BY p.price DESC ");
                break;
            case "popular":
                sql.append("ORDER BY p.review_count DESC ");
                break;
            case "rating":
                sql.append("ORDER BY p.rating DESC ");
                break;
            case "newest":
            default:
                sql.append("ORDER BY p.created_at DESC ");
                break;
        }

        // Pagination
        int offset = (page - 1) * pageSize;
        sql.append("LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add(offset);

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String) {
                    ps.setString(i + 1, (String) param);
                } else if (param instanceof Integer) {
                    ps.setInt(i + 1, (Integer) param);
                } else if (param instanceof Double) {
                    ps.setDouble(i + 1, (Double) param);
                }
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    products.add(extractProduct(rs));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching filtered products: " + e.getMessage());
        }
        return products;
    }

    /**
     * Gets total count matching the filter criteria (for pagination).
     */
    public int getFilteredProductCount(String search, int categoryId, double minPrice,
            double maxPrice, String size, double minRating) {
        StringBuilder sql = new StringBuilder();
        List<Object> params = new ArrayList<>();

        sql.append("SELECT COUNT(*) FROM products p WHERE 1=1 ");

        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (p.name LIKE ? OR p.short_description LIKE ? OR p.detailed_description LIKE ?) ");
            String searchTerm = "%" + search.trim() + "%";
            params.add(searchTerm);
            params.add(searchTerm);
            params.add(searchTerm);
        }
        if (categoryId > 0) {
            sql.append("AND p.category_id = ? ");
            params.add(categoryId);
        }
        if (minPrice > 0) {
            sql.append("AND p.price >= ? ");
            params.add(minPrice);
        }
        if (maxPrice > 0) {
            sql.append("AND p.price <= ? ");
            params.add(maxPrice);
        }
        if (size != null && !size.trim().isEmpty()) {
            sql.append("AND FIND_IN_SET(?, p.size_options) > 0 ");
            params.add(size.trim());
        }
        if (minRating > 0) {
            sql.append("AND p.rating >= ? ");
            params.add(minRating);
        }

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < params.size(); i++) {
                Object param = params.get(i);
                if (param instanceof String)
                    ps.setString(i + 1, (String) param);
                else if (param instanceof Integer)
                    ps.setInt(i + 1, (Integer) param);
                else if (param instanceof Double)
                    ps.setDouble(i + 1, (Double) param);
            }

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            System.err.println("Error counting filtered products: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Gets all images for a product.
     */
    public List<String> getProductImages(int productId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_url FROM product_images WHERE product_id = ? ORDER BY sort_order ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_url"));
                }
            }
        } catch (SQLException e) {
            System.err.println("Error fetching product images: " + e.getMessage());
        }
        return images;
    }

    // ==================== ADMIN CRUD ====================

    /**
     * Adds a new product (admin).
     */
    public int addProduct(Product product) {
        String sql = "INSERT INTO products (name, category_id, price, stock, brand, short_description, " +
                "detailed_description, rating, size_options, is_featured) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getName());
            ps.setInt(2, product.getCategoryId());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setString(5, product.getBrand());
            ps.setString(6, product.getShortDescription());
            ps.setString(7, product.getDetailedDescription());
            ps.setDouble(8, product.getRating());
            ps.setString(9, product.getSizeOptions());
            ps.setBoolean(10, product.isFeatured());

            int affected = ps.executeUpdate();
            if (affected > 0) {
                try (ResultSet keys = ps.getGeneratedKeys()) {
                    if (keys.next()) {
                        return keys.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            System.err.println("Error adding product: " + e.getMessage());
        }
        return -1;
    }

    /**
     * Updates an existing product (admin).
     */
    public boolean updateProduct(Product product) {
        String sql = "UPDATE products SET name=?, category_id=?, price=?, stock=?, brand=?, " +
                "short_description=?, detailed_description=?, size_options=?, is_featured=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, product.getName());
            ps.setInt(2, product.getCategoryId());
            ps.setDouble(3, product.getPrice());
            ps.setInt(4, product.getStock());
            ps.setString(5, product.getBrand());
            ps.setString(6, product.getShortDescription());
            ps.setString(7, product.getDetailedDescription());
            ps.setString(8, product.getSizeOptions());
            ps.setBoolean(9, product.isFeatured());
            ps.setInt(10, product.getId());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Deletes a product by ID (admin).
     */
    public boolean deleteProduct(int id) {
        String sql = "DELETE FROM products WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error deleting product: " + e.getMessage());
            return false;
        }
    }

    /**
     * Updates product stock (admin).
     */
    public boolean updateStock(int productId, int newStock) {
        String sql = "UPDATE products SET stock = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, newStock);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error updating stock: " + e.getMessage());
            return false;
        }
    }

    /**
     * Adds a product image.
     */
    public boolean addProductImage(int productId, String imageUrl, boolean isPrimary) {
        String sql = "INSERT INTO product_images (product_id, image_url, is_primary, sort_order) " +
                "VALUES (?, ?, ?, (SELECT COALESCE(MAX(sort_order), 0) + 1 FROM product_images pi WHERE pi.product_id = ?))";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, productId);
            ps.setString(2, imageUrl);
            ps.setBoolean(3, isPrimary);
            ps.setInt(4, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error adding product image: " + e.getMessage());
            return false;
        }
    }

    /**
     * Gets the total number of products (for admin stats).
     */
    public int getProductCount() {
        String sql = "SELECT COUNT(*) FROM products";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {

            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            System.err.println("Error counting products: " + e.getMessage());
        }
        return 0;
    }

    /**
     * Decrements stock for a product when ordered.
     */
    public boolean decrementStock(int productId, int quantity) {
        String sql = "UPDATE products SET stock = stock - ? WHERE id = ? AND stock >= ?";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, productId);
            ps.setInt(3, quantity);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Error decrementing stock: " + e.getMessage());
            return false;
        }
    }

    /**
     * Helper method to extract Product from ResultSet.
     */
    private Product extractProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setCategoryId(rs.getInt("category_id"));
        product.setPrice(rs.getDouble("price"));
        product.setStock(rs.getInt("stock"));
        product.setBrand(rs.getString("brand"));
        product.setShortDescription(rs.getString("short_description"));
        product.setDetailedDescription(rs.getString("detailed_description"));
        product.setRating(rs.getDouble("rating"));
        product.setReviewCount(rs.getInt("review_count"));
        product.setSizeOptions(rs.getString("size_options"));
        product.setFeatured(rs.getBoolean("is_featured"));
        product.setCreatedAt(rs.getTimestamp("created_at"));

        // Joined fields
        try {
            product.setCategoryName(rs.getString("category_name"));
        } catch (SQLException ignored) {
        }
        try {
            product.setPrimaryImageUrl(rs.getString("primary_image"));
        } catch (SQLException ignored) {
        }

        return product;
    }
}
