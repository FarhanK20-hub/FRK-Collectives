package com.frk.controller;

import com.frk.dao.ProductDAO;
import com.frk.dao.ReviewDAO;
import com.frk.dao.WishlistDAO;
import com.frk.model.Product;
import com.frk.model.Review;
import com.frk.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * ProductDetailServlet — Handles the individual product detail page.
 */
@WebServlet("/product")
public class ProductDetailServlet extends HttpServlet {

    private ProductDAO productDAO;
    private ReviewDAO reviewDAO;
    private WishlistDAO wishlistDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        reviewDAO = new ReviewDAO();
        wishlistDAO = new WishlistDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/products");
            return;
        }

        try {
            int productId = Integer.parseInt(idParam);
            Product product = productDAO.getProductById(productId);

            if (product == null) {
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Product not found");
                return;
            }

            // Load reviews
            List<Review> reviews = reviewDAO.getByProduct(productId);

            // Check wishlist status if logged in
            HttpSession session = request.getSession(false);
            if (session != null && session.getAttribute("user") != null) {
                User user = (User) session.getAttribute("user");
                boolean inWishlist = wishlistDAO.isInWishlist(user.getId(), productId);
                request.setAttribute("inWishlist", inWishlist);
            }

            // Set recently viewed cookie
            Cookie viewedCookie = new Cookie("recently_viewed_" + productId, String.valueOf(productId));
            viewedCookie.setMaxAge(60 * 60 * 24 * 7); // 7 days
            viewedCookie.setPath("/");
            response.addCookie(viewedCookie);

            // Load related products (same category, exclude current)
            List<Product> relatedProducts = productDAO.getFilteredProducts(
                    null, product.getCategoryId(), 0, 0, null, 0, "popular", 1, 4);
            relatedProducts.removeIf(p -> p.getId() == productId);

            request.setAttribute("product", product);
            request.setAttribute("reviews", reviews);
            request.setAttribute("relatedProducts", relatedProducts);

            request.getRequestDispatcher("/product-detail.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid product ID");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Handle review submission
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("user");
        String productIdParam = request.getParameter("productId");
        String ratingParam = request.getParameter("rating");
        String comment = request.getParameter("comment");

        try {
            int productId = Integer.parseInt(productIdParam);
            int rating = Integer.parseInt(ratingParam);

            Review review = new Review();
            review.setProductId(productId);
            review.setUserId(user.getId());
            review.setRating(rating);
            review.setComment(comment);

            reviewDAO.addReview(review);

            response.sendRedirect(request.getContextPath() + "/product?id=" + productId + "#reviews");
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/products");
        }
    }
}
