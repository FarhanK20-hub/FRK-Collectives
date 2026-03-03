<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Admin Dashboard | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body>

                <div class="admin-layout">
                    <!-- Admin Sidebar -->
                    <aside class="admin-sidebar">
                        <div class="admin-sidebar-brand">FRK ADMIN</div>
                        <nav class="admin-nav">
                            <a href="${pageContext.request.contextPath}/admin/dashboard" class="active">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
                            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
                            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                            <a href="${pageContext.request.contextPath}/home">← Back to Store</a>
                        </nav>
                    </aside>

                    <!-- Main Content -->
                    <main class="admin-main">
                        <div class="admin-header">
                            <h1>Dashboard</h1>
                            <span class="text-muted">Welcome, ${sessionScope.user.name}</span>
                        </div>

                        <!-- Stats Cards -->
                        <div class="stats-grid">
                            <div class="stat-card">
                                <div class="stat-label">Total Products</div>
                                <div class="stat-value">${requestScope.productCount}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Total Orders</div>
                                <div class="stat-value">${requestScope.orderCount}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Total Users</div>
                                <div class="stat-value">${requestScope.userCount}</div>
                            </div>
                            <div class="stat-card">
                                <div class="stat-label">Revenue</div>
                                <div class="stat-value">
                                    <frk:formatCurrency value="${requestScope.totalRevenue}" />
                                </div>
                            </div>
                        </div>

                        <!-- Recent Orders -->
                        <h2 style="margin-bottom:16px;">Recent Orders</h2>
                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${requestScope.recentOrders}" end="9">
                                    <tr>
                                        <td><strong>#FRK${order.id}</strong></td>
                                        <td>${order.userName}</td>
                                        <td>
                                            <frk:formatCurrency value="${order.grandTotal}" />
                                        </td>
                                        <td><span
                                                class="order-status status-${order.status.toLowerCase()}">${order.status}</span>
                                        </td>
                                        <td class="text-muted">${order.createdAt}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </main>
                </div>

            </body>

            </html>