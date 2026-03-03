package com.frk.controller;

import com.frk.dao.*;
import com.frk.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AdminServlet — Handles the admin panel.
 * Protected by AdminFilter (ADMIN role required).
 */
@WebServlet(urlPatterns = { "/admin/dashboard", "/admin/products", "/admin/product/add",
        "/admin/product/edit", "/admin/product/delete",
        "/admin/orders", "/admin/order/status",
        "/admin/users" })
public class AdminServlet extends HttpServlet {

    private ProductDAO productDAO;
    private OrderDAO orderDAO;
    private UserDAO userDAO;
    private CategoryDAO categoryDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
        orderDAO = new OrderDAO();
        userDAO = new UserDAO();
        categoryDAO = new CategoryDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/dashboard":
                // Dashboard stats
                request.setAttribute("productCount", productDAO.getProductCount());
                request.setAttribute("orderCount", orderDAO.getOrderCount());
                request.setAttribute("userCount", userDAO.getUserCount());
                request.setAttribute("totalRevenue", orderDAO.getTotalRevenue());
                request.setAttribute("recentOrders", orderDAO.getAllOrders());
                request.setAttribute("adminPage", "dashboard");
                request.getRequestDispatcher("/admin/dashboard.jsp").forward(request, response);
                break;

            case "/admin/products":
                List<Product> products = productDAO.getAllProducts();
                List<Category> categories = categoryDAO.getAll();
                request.setAttribute("products", products);
                request.setAttribute("categories", categories);
                request.setAttribute("adminPage", "products");
                request.getRequestDispatcher("/admin/products.jsp").forward(request, response);
                break;

            case "/admin/product/edit":
                String editId = request.getParameter("id");
                if (editId != null) {
                    Product product = productDAO.getProductById(Integer.parseInt(editId));
                    request.setAttribute("editProduct", product);
                }
                request.setAttribute("categories", categoryDAO.getAll());
                request.setAttribute("adminPage", "products");
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                break;

            case "/admin/product/add":
                request.setAttribute("categories", categoryDAO.getAll());
                request.setAttribute("adminPage", "products");
                request.getRequestDispatcher("/admin/product-form.jsp").forward(request, response);
                break;

            case "/admin/orders":
                List<Order> orders = orderDAO.getAllOrders();
                request.setAttribute("orders", orders);
                request.setAttribute("adminPage", "orders");
                request.getRequestDispatcher("/admin/orders.jsp").forward(request, response);
                break;

            case "/admin/users":
                List<User> users = userDAO.getAllUsers();
                request.setAttribute("users", users);
                request.setAttribute("adminPage", "users");
                request.getRequestDispatcher("/admin/users.jsp").forward(request, response);
                break;

            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String path = request.getServletPath();

        switch (path) {
            case "/admin/product/add":
                handleProductAdd(request, response);
                break;
            case "/admin/product/edit":
                handleProductEdit(request, response);
                break;
            case "/admin/product/delete":
                handleProductDelete(request, response);
                break;
            case "/admin/order/status":
                handleOrderStatus(request, response);
                break;
            default:
                response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        }
    }

    private void handleProductAdd(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Product product = extractProductFromForm(request);
        int productId = productDAO.addProduct(product);

        // Add image if provided
        String imageUrl = request.getParameter("imageUrl");
        if (productId > 0 && imageUrl != null && !imageUrl.trim().isEmpty()) {
            productDAO.addProductImage(productId, imageUrl.trim(), true);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleProductEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Product product = extractProductFromForm(request);
        String idParam = request.getParameter("id");
        if (idParam != null) {
            product.setId(Integer.parseInt(idParam));
            productDAO.updateProduct(product);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleProductDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            productDAO.deleteProduct(Integer.parseInt(idParam));
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        String orderIdParam = request.getParameter("orderId");
        String status = request.getParameter("status");

        if (orderIdParam != null && status != null) {
            orderDAO.updateStatus(Integer.parseInt(orderIdParam), status);
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private Product extractProductFromForm(HttpServletRequest request) {
        Product product = new Product();
        product.setName(request.getParameter("name"));

        String catId = request.getParameter("categoryId");
        if (catId != null)
            product.setCategoryId(Integer.parseInt(catId));

        String price = request.getParameter("price");
        if (price != null)
            product.setPrice(Double.parseDouble(price));

        String stock = request.getParameter("stock");
        if (stock != null)
            product.setStock(Integer.parseInt(stock));

        product.setBrand(request.getParameter("brand") != null ? request.getParameter("brand") : "FRK");
        product.setShortDescription(request.getParameter("shortDescription"));
        product.setDetailedDescription(request.getParameter("detailedDescription"));
        product.setSizeOptions(request.getParameter("sizeOptions"));
        product.setFeatured("on".equals(request.getParameter("isFeatured")));

        return product;
    }
}
