package com.frk.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * WishlistItem JavaBean — Represents a product in a user's wishlist.
 * Maps to the 'wishlist' table with embedded Product data.
 */
public class WishlistItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int userId;
    private int productId;
    private Timestamp createdAt;

    // Embedded product data for display
    private Product product;

    public WishlistItem() {
    }

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    @Override
    public String toString() {
        return "WishlistItem{id=" + id + ", productId=" + productId + "}";
    }
}
