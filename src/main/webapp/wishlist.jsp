<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Wishlist | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container main-content">
                        <h2 class="section-title">My Wishlist</h2>

                        <c:choose>
                            <c:when test="${empty requestScope.wishlistItems}">
                                <div class="empty-state">
                                    <p>Your wishlist is empty. Start adding items you love.</p>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="btn btn-primary mt-4">Browse Products</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="wishlist-grid">
                                    <c:forEach var="item" items="${requestScope.wishlistItems}">
                                        <div class="product-card">
                                            <a href="${pageContext.request.contextPath}/product?id=${item.productId}"
                                                style="text-decoration:none; color:inherit;">
                                                <div class="product-image-container">
                                                    <img src="${item.product.primaryImageUrl}"
                                                        alt="${item.product.name}" class="product-image" loading="lazy">
                                                </div>
                                                <div class="product-info">
                                                    <span class="product-category">${item.product.categoryName}</span>
                                                    <h3 class="product-name">${item.product.name}</h3>
                                                    <div class="product-footer">
                                                        <span class="product-price">
                                                            <frk:formatCurrency value="${item.product.price}" />
                                                        </span>
                                                    </div>
                                                </div>
                                            </a>
                                            <div style="padding:0 20px 20px; display:flex; gap:8px;">
                                                <form action="${pageContext.request.contextPath}/cart" method="post"
                                                    style="flex:1;">
                                                    <input type="hidden" name="action" value="add">
                                                    <input type="hidden" name="productId" value="${item.productId}">
                                                    <button type="submit" class="btn btn-primary btn-sm btn-block">Add
                                                        to Bag</button>
                                                </form>
                                                <form action="${pageContext.request.contextPath}/wishlist/remove"
                                                    method="post">
                                                    <input type="hidden" name="productId" value="${item.productId}">
                                                    <button type="submit" class="btn btn-ghost btn-sm">Remove</button>
                                                </form>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>