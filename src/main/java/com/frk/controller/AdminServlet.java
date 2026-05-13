package com.frk.controller;

import com.frk.dao.*;
import com.frk.model.*;
import com.frk.util.Constants;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * AdminServlet — Handles the admin panel.
 * Protected by AdminFilter (ADMIN role required).
 *
 * SECURITY FIXES:
 * - All parseInt/parseDouble wrapped in try-catch (was crashing with 500)
 * - Uses Constants.safeParseInt/safeParseDouble for safe parsing
 * - Input validation on product form extraction
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
                int editId = Constants.safeParseInt(request.getParameter("id"), -1);
                if (editId > 0) {
                    Product product = productDAO.getProductById(editId);
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
        if (product == null) {
            response.sendRedirect(request.getContextPath() + "/admin/products");
            return;
        }
        int productId = productDAO.addProduct(product);

        // Add image if provided
        String imageUrl = request.getParameter("imageUrl");
        if (productId > 0 && !Constants.isBlank(imageUrl)) {
            productDAO.addProductImage(productId, imageUrl.trim(), true);
        }

        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleProductEdit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Product product = extractProductFromForm(request);
        int id = Constants.safeParseInt(request.getParameter("id"), -1);
        if (product != null && id > 0) {
            product.setId(id);
            productDAO.updateProduct(product);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleProductDelete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int id = Constants.safeParseInt(request.getParameter("id"), -1);
        if (id > 0) {
            productDAO.deleteProduct(id);
        }
        response.sendRedirect(request.getContextPath() + "/admin/products");
    }

    private void handleOrderStatus(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        int orderId = Constants.safeParseInt(request.getParameter("orderId"), -1);
        String status = request.getParameter("status");

        if (orderId > 0 && status != null && Constants.VALID_ORDER_STATUSES.contains(status.trim().toUpperCase())) {
            orderDAO.updateStatus(orderId, status.trim().toUpperCase());
        }
        response.sendRedirect(request.getContextPath() + "/admin/orders");
    }

    private Product extractProductFromForm(HttpServletRequest request) {
        String name = request.getParameter("name");
        if (Constants.isBlank(name)) return null;

        Product product = new Product();
        product.setName(name.trim());
        product.setCategoryId(Constants.safeParseInt(request.getParameter("categoryId"), 1));
        product.setPrice(Constants.safeParseDouble(request.getParameter("price"), 0.0));
        product.setStock(Constants.safeParseInt(request.getParameter("stock"), 0));
        product.setBrand(!Constants.isBlank(request.getParameter("brand")) ? request.getParameter("brand").trim() : "FRK");
        product.setShortDescription(request.getParameter("shortDescription"));
        product.setDetailedDescription(request.getParameter("detailedDescription"));
        product.setSizeOptions(request.getParameter("sizeOptions"));
        product.setFeatured("on".equals(request.getParameter("isFeatured")));

        return product;
    }
}
