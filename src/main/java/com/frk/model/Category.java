package com.frk.model;

import java.io.Serializable;

/**
 * Category JavaBean — Represents a product category.
 * Maps to the 'categories' table.
 */
public class Category implements Serializable {
    private static final long serialVersionUID = 1L;

    private int id;
    private String name;
    private String slug;
    private String description;

    public Category() {
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

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Category{id=" + id + ", name='" + name + "', slug='" + slug + "'}";
    }
}
