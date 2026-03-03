<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>${not empty editProduct ? 'Edit' : 'Add'} Product | FRK Admin</title>
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
                        <h1>${not empty editProduct ? 'Edit Product' : 'Add New Product'}</h1>
                    </div>

                    <div class="dashboard-section">
                        <form
                            action="${pageContext.request.contextPath}/admin/product/${not empty editProduct ? 'edit' : 'add'}"
                            method="post">
                            <c:if test="${not empty editProduct}">
                                <input type="hidden" name="id" value="${editProduct.id}">
                            </c:if>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Product Name</label>
                                    <input type="text" name="name" class="form-control" value="${editProduct.name}"
                                        required>
                                </div>
                                <div class="form-group">
                                    <label>Brand</label>
                                    <input type="text" name="brand" class="form-control"
                                        value="${editProduct != null ? editProduct.brand : 'FRK'}">
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Category</label>
                                    <select name="categoryId" class="form-control" required>
                                        <c:forEach var="cat" items="${requestScope.categories}">
                                            <option value="${cat.id}" ${editProduct !=null &&
                                                editProduct.categoryId==cat.id ? 'selected' : '' }>${cat.name}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Price (₹)</label>
                                    <input type="number" name="price" class="form-control" step="0.01"
                                        value="${editProduct.price}" required>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group">
                                    <label>Stock Quantity</label>
                                    <input type="number" name="stock" class="form-control"
                                        value="${editProduct != null ? editProduct.stock : 50}" required>
                                </div>
                                <div class="form-group">
                                    <label>Size Options (comma-separated)</label>
                                    <input type="text" name="sizeOptions" class="form-control"
                                        value="${editProduct != null ? editProduct.sizeOptions : 'S,M,L,XL'}">
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Short Description</label>
                                <input type="text" name="shortDescription" class="form-control"
                                    value="${editProduct.shortDescription}">
                            </div>

                            <div class="form-group">
                                <label>Detailed Description</label>
                                <textarea name="detailedDescription" class="form-control"
                                    rows="4">${editProduct.detailedDescription}</textarea>
                            </div>

                            <c:if test="${empty editProduct}">
                                <div class="form-group">
                                    <label>Image URL</label>
                                    <input type="text" name="imageUrl" class="form-control"
                                        placeholder="https://images.unsplash.com/...">
                                </div>
                            </c:if>

                            <div class="form-group">
                                <label class="form-check">
                                    <input type="checkbox" name="isFeatured" ${editProduct !=null &&
                                        editProduct.featured ? 'checked' : '' }> Featured Product
                                </label>
                            </div>

                            <div style="display:flex; gap:12px;">
                                <button type="submit" class="btn btn-primary">${not empty editProduct ? 'Update Product'
                                    : 'Add Product'}</button>
                                <a href="${pageContext.request.contextPath}/admin/products"
                                    class="btn btn-ghost">Cancel</a>
                            </div>
                        </form>
                    </div>
                </main>
            </div>

        </body>

        </html>