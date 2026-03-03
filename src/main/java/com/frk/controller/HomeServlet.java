package com.frk.controller;

import com.frk.dao.CategoryDAO;
import com.frk.dao.ProductDAO;
import com.frk.model.Category;
import com.frk.model.Product;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

/**
 * HomeServlet — Handles the landing page with featured products.
 */
@WebServlet(urlPatterns = { "", "/home" })
public class HomeServlet extends HttpServlet {

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

        // Handle Welcome Cookie
        boolean isReturningUser = false;
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("frk_visitor".equals(cookie.getName())) {
                    isReturningUser = true;
                    request.setAttribute("welcomeMessage", "Welcome back to FRK Collectives.");
                    break;
                }
            }
        }

        if (!isReturningUser) {
            Cookie visitorCookie = new Cookie("frk_visitor", "true");
            visitorCookie.setMaxAge(60 * 60 * 24 * 30);
            response.addCookie(visitorCookie);
            request.setAttribute("welcomeMessage", "Welcome to FRK Collectives. Wear the Vision.");
        }

        // Load landing page data
        List<Product> featuredProducts = productDAO.getFeaturedProducts();
        List<Product> bestSellers = productDAO.getBestSellers();
        List<Category> categories = categoryDAO.getAll();

        request.setAttribute("featuredProducts", featuredProducts);
        request.setAttribute("bestSellers", bestSellers);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}
