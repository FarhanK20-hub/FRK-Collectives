<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Users | FRK Admin</title>
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
                        <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
                        <a href="${pageContext.request.contextPath}/admin/users" class="active">Users</a>
                        <a href="${pageContext.request.contextPath}/home">← Back to Store</a>
                    </nav>
                </aside>

                <main class="admin-main">
                    <div class="admin-header">
                        <h1>Users</h1>
                    </div>

                    <table class="admin-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Phone</th>
                                <th>Role</th>
                                <th>Joined</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="u" items="${requestScope.users}">
                                <tr>
                                    <td>#${u.id}</td>
                                    <td><strong>${u.name}</strong></td>
                                    <td>${u.email}</td>
                                    <td>${u.phone}</td>
                                    <td>
                                        <span
                                            class="order-status ${u.role == 'ADMIN' ? 'status-confirmed' : 'status-delivered'}">${u.role}</span>
                                    </td>
                                    <td class="text-muted">${u.createdAt}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </main>
            </div>

        </body>

        </html>