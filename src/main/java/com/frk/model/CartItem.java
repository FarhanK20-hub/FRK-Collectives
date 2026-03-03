package com.frk.model;

import java.io.Serializable;

/**
 * CartItem JavaBean — Represents an item in the shopping cart.
 * Stored in HttpSession. Includes selected size.
 */
public class CartItem implements Serializable {
    private static final long serialVersionUID = 1L;

    private Product product;
    private int quantity;
    private String selectedSize;

    public CartItem() {
    }

    public CartItem(Product product, int quantity) {
        this.product = product;
        this.quantity = quantity;
        this.selectedSize = "M"; // Default size
    }

    public CartItem(Product product, int quantity, String selectedSize) {
        this.product = product;
        this.quantity = quantity;
        this.selectedSize = selectedSize;
    }

    // --- Getters and Setters ---

    public Product getProduct() {
        return product;
    }

    public void setProduct(Product product) {
        this.product = product;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public String getSelectedSize() {
        return selectedSize;
    }

    public void setSelectedSize(String selectedSize) {
        this.selectedSize = selectedSize;
    }

    /**
     * Calculates the line subtotal (price × quantity).
     */
    public double getSubtotal() {
        return this.product.getPrice() * this.quantity;
    }
}
