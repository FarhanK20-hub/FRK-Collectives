<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Manage Orders | FRK Admin</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body>

                <div class="admin-layout">
                    <aside class="admin-sidebar">
                        <div class="admin-sidebar-brand">FRK ADMIN</div>
                        <nav class="admin-nav">
                            <a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
                            <a href="${pageContext.request.contextPath}/admin/products">Products</a>
                            <a href="${pageContext.request.contextPath}/admin/orders" class="active">Orders</a>
                            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                            <a href="${pageContext.request.contextPath}/home">← Back to Store</a>
                        </nav>
                    </aside>

                    <main class="admin-main">
                        <div class="admin-header">
                            <h1>Orders</h1>
                        </div>

                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Customer</th>
                                    <th>Total</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="order" items="${requestScope.orders}">
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
                                        <td>
                                            <form action="${pageContext.request.contextPath}/admin/order/status"
                                                method="post" style="display:flex; gap:8px; align-items:center;">
                                                <input type="hidden" name="orderId" value="${order.id}">
                                                <select name="status" class="sort-select" style="min-width:140px;">
                                                    <option value="PENDING" ${order.status=='PENDING' ? 'selected' : ''
                                                        }>Pending</option>
                                                    <option value="CONFIRMED" ${order.status=='CONFIRMED' ? 'selected'
                                                        : '' }>Confirmed</option>
                                                    <option value="SHIPPED" ${order.status=='SHIPPED' ? 'selected' : ''
                                                        }>Shipped</option>
                                                    <option value="DELIVERED" ${order.status=='DELIVERED' ? 'selected'
                                                        : '' }>Delivered</option>
                                                    <option value="CANCELLED" ${order.status=='CANCELLED' ? 'selected'
                                                        : '' }>Cancelled</option>
                                                </select>
                                                <button type="submit" class="btn btn-ghost btn-sm">Update</button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </main>
                </div>

            </body>

            </html>