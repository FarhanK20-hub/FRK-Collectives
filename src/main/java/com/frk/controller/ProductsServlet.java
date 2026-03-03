package com.frk.controller;

import com.frk.dao.CategoryDAO;
import com.frk.dao.ProductDAO;
import com.frk.model.Category;
import com.frk.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * ProductsServlet — Handles the products listing page with search, filter,
 * sort, and pagination.
 */
@WebServlet("/products")
public class ProductsServlet extends HttpServlet {

    private ProductDAO productDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Parse filter parameters
        String search = request.getParameter("search");
        String categoryParam = request.getParameter("category");
        String minPriceParam = request.getParameter("minPrice");
        String maxPriceParam = request.getParameter("maxPrice");
        String size = request.getParameter("size");
        String minRatingParam = request.getParameter("minRating");
        String sortBy = request.getParameter("sort");
        String pageParam = request.getParameter("page");

        int categoryId = 0;
        double minPrice = 0;
        double maxPrice = 0;
        double minRating = 0;
        int page = 1;
        int pageSize = 9;

        try {
            if (categoryParam != null && !categoryParam.isEmpty())
                categoryId = Integer.parseInt(categoryParam);
        } catch (NumberFormatException ignored) {
        }

        try {
            if (minPriceParam != null && !minPriceParam.isEmpty())
                minPrice = Double.parseDouble(minPriceParam);
        } catch (NumberFormatException ignored) {
        }

        try {
            if (maxPriceParam != null && !maxPriceParam.isEmpty())
                maxPrice = Double.parseDouble(maxPriceParam);
        } catch (NumberFormatException ignored) {
        }

        try {
            if (minRatingParam != null && !minRatingParam.isEmpty())
                minRating = Double.parseDouble(minRatingParam);
        } catch (NumberFormatException ignored) {
        }

        try {
            if (pageParam != null && !pageParam.isEmpty())
                page = Math.max(1, Integer.parseInt(pageParam));
        } catch (NumberFormatException ignored) {
        }

        // Fetch filtered products
        List<Product> products = productDAO.getFilteredProducts(
                search, categoryId, minPrice, maxPrice, size, minRating, sortBy, page, pageSize);

        // Fetch total count for pagination
        int totalCount = productDAO.getFilteredProductCount(
                search, categoryId, minPrice, maxPrice, size, minRating);
        int totalPages = (int) Math.ceil((double) totalCount / pageSize);

        // Fetch categories for filter sidebar
        List<Category> categories = categoryDAO.getAll();

        // Set attributes
        request.setAttribute("products", products);
        request.setAttribute("categories", categories);
        request.setAttribute("currentPage", page);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("totalCount", totalCount);

        // Preserve filter state
        request.setAttribute("searchQuery", search);
        request.setAttribute("selectedCategory", categoryId);
        request.setAttribute("minPrice", minPrice > 0 ? minPrice : "");
        request.setAttribute("maxPrice", maxPrice > 0 ? maxPrice : "");
        request.setAttribute("selectedSize", size);
        request.setAttribute("selectedRating", minRating);
        request.setAttribute("selectedSort", sortBy != null ? sortBy : "newest");

        request.getRequestDispatcher("/products.jsp").forward(request, response);
    }
}
