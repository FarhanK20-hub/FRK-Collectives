<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Manage Products | FRK Admin</title>
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
                            <a href="${pageContext.request.contextPath}/admin/products" class="active">Products</a>
                            <a href="${pageContext.request.contextPath}/admin/orders">Orders</a>
                            <a href="${pageContext.request.contextPath}/admin/users">Users</a>
                            <a href="${pageContext.request.contextPath}/home">← Back to Store</a>
                        </nav>
                    </aside>

                    <main class="admin-main">
                        <div class="admin-header">
                            <h1>Products</h1>
                            <a href="${pageContext.request.contextPath}/admin/product/add"
                                class="btn btn-primary btn-sm">+ Add Product</a>
                        </div>

                        <table class="admin-table">
                            <thead>
                                <tr>
                                    <th>Image</th>
                                    <th>Name</th>
                                    <th>Category</th>
                                    <th>Price</th>
                                    <th>Stock</th>
                                    <th>Featured</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="product" items="${requestScope.products}">
                                    <tr>
                                        <td><img src="${product.primaryImageUrl}" alt="" class="product-thumb"></td>
                                        <td><strong>${product.name}</strong></td>
                                        <td>${product.categoryName}</td>
                                        <td>
                                            <frk:formatCurrency value="${product.price}" />
                                        </td>
                                        <td>
                                            <c:choose>
                                                <c:when test="${product.stock > 0}">${product.stock}</c:when>
                                                <c:otherwise><span class="text-danger">Out</span></c:otherwise>
                                            </c:choose>
                                        </td>
                                        <td>${product.featured ? '★' : '—'}</td>
                                        <td>
                                            <div class="table-actions">
                                                <a href="${pageContext.request.contextPath}/admin/product/edit?id=${product.id}"
                                                    class="btn btn-ghost btn-sm">Edit</a>
                                                <form action="${pageContext.request.contextPath}/admin/product/delete"
                                                    method="post" onsubmit="return confirm('Delete this product?');">
                                                    <input type="hidden" name="id" value="${product.id}">
                                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                                </form>
                                            </div>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </main>
                </div>

            </body>

            </html>