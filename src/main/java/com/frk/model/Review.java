package com.frk.model;

import java.io.Serializable;
import java.sql.Timestamp;

/**
 * Review JavaBean — Represents a product review.
 * Maps to the 'reviews' table.
 */
public class Review implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private int productId;
    private int userId;
    private String userName;
    private int rating;
    private String comment;
    private Timestamp createdAt;

    public Review() {
    }

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "Review{id=" + id + ", rating=" + rating + ", user='" + userName + "'}";
    }
}
