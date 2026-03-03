package com.frk.model;

import java.io.Serializable;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

/**
 * Product JavaBean — Represents a product in the FRK Collectives catalog.
 * Maps to the 'products' table with joined data from 'categories' and
 * 'product_images'.
 */
public class Product implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private int categoryId;
    private String categoryName;
    private double price;
    private int stock;
    private String brand;
    private String shortDescription;
    private String detailedDescription;
    private double rating;
    private int reviewCount;
    private String sizeOptions;
    private boolean featured;
    private Timestamp createdAt;

    // Joined data
    private String primaryImageUrl;
    private List<String> images;

    public Product() {
        this.images = new ArrayList<>();
        this.brand = "FRK";
    }

    // --- Getters and Setters ---

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getStock() {
        return stock;
    }

    public void setStock(int stock) {
        this.stock = stock;
    }

    public String getBrand() {
        return brand;
    }

    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getShortDescription() {
        return shortDescription;
    }

    public void setShortDescription(String shortDescription) {
        this.shortDescription = shortDescription;
    }

    public String getDetailedDescription() {
        return detailedDescription;
    }

    public void setDetailedDescription(String detailedDescription) {
        this.detailedDescription = detailedDescription;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getReviewCount() {
        return reviewCount;
    }

    public void setReviewCount(int reviewCount) {
        this.reviewCount = reviewCount;
    }

    public String getSizeOptions() {
        return sizeOptions;
    }

    public void setSizeOptions(String sizeOptions) {
        this.sizeOptions = sizeOptions;
    }

    public boolean isFeatured() {
        return featured;
    }

    public void setFeatured(boolean featured) {
        this.featured = featured;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public String getPrimaryImageUrl() {
        return primaryImageUrl;
    }

    public void setPrimaryImageUrl(String primaryImageUrl) {
        this.primaryImageUrl = primaryImageUrl;
    }

    public List<String> getImages() {
        return images;
    }

    public void setImages(List<String> images) {
        this.images = images;
    }

    /**
     * Returns size options as a List for easy iteration in JSP.
     */
    public List<String> getSizeList() {
        if (sizeOptions == null || sizeOptions.isEmpty()) {
            return new ArrayList<>();
        }
        return Arrays.asList(sizeOptions.split(","));
    }

    /**
     * Checks if the product is in stock.
     */
    public boolean isInStock() {
        return stock > 0;
    }

    // Legacy compatibility getter
    public String getImageUrl() {
        return primaryImageUrl;
    }

    public String getCategory() {
        return categoryName;
    }

    public String getDescription() {
        return shortDescription;
    }

    @Override
    public String toString() {
        return "Product{id=" + id + ", name='" + name + "', price=" + price + ", brand='" + brand + "'}";
    }
}
