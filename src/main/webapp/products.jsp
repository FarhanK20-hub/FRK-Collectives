<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Shop | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container main-content">

                        <!-- Search Bar -->
                        <form action="${pageContext.request.contextPath}/products" method="get" class="search-bar">
                            <input type="text" name="search" value="${requestScope.searchQuery}"
                                placeholder="Search products..." class="search-input" id="searchInput">
                            <!-- Preserve other filters -->
                            <c:if test="${requestScope.selectedCategory > 0}">
                                <input type="hidden" name="category" value="${requestScope.selectedCategory}">
                            </c:if>
                            <button type="submit" class="btn btn-primary">Search</button>
                        </form>

                        <div class="shop-layout">
                            <!-- Filter Sidebar -->
                            <aside class="filter-sidebar">

                                <!-- Category Filter -->
                                <div class="filter-section">
                                    <h4 class="filter-title">Category</h4>
                                    <div class="filter-options">
                                        <a href="${pageContext.request.contextPath}/products?sort=${requestScope.selectedSort}"
                                            class="filter-option ${requestScope.selectedCategory == 0 ? 'active' : ''}">All</a>
                                        <c:forEach var="cat" items="${requestScope.categories}">
                                            <a href="${pageContext.request.contextPath}/products?category=${cat.id}&sort=${requestScope.selectedSort}"
                                                class="filter-option ${requestScope.selectedCategory == cat.id ? 'active' : ''}">${cat.name}</a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Price Range -->
                                <div class="filter-section">
                                    <h4 class="filter-title">Price Range</h4>
                                    <form action="${pageContext.request.contextPath}/products" method="get">
                                        <c:if test="${requestScope.selectedCategory > 0}">
                                            <input type="hidden" name="category"
                                                value="${requestScope.selectedCategory}">
                                        </c:if>
                                        <input type="hidden" name="sort" value="${requestScope.selectedSort}">
                                        <div class="price-range">
                                            <input type="number" name="minPrice" placeholder="Min ₹"
                                                value="${requestScope.minPrice}" class="price-input">
                                            <span>—</span>
                                            <input type="number" name="maxPrice" placeholder="Max ₹"
                                                value="${requestScope.maxPrice}" class="price-input">
                                        </div>
                                        <button type="submit" class="btn btn-ghost btn-sm mt-4"
                                            style="width:100%">Apply</button>
                                    </form>
                                </div>

                                <!-- Size Filter -->
                                <div class="filter-section">
                                    <h4 class="filter-title">Size</h4>
                                    <div class="size-filter-chips">
                                        <c:forEach var="s" items="${['S','M','L','XL','XXL']}">
                                            <a href="${pageContext.request.contextPath}/products?category=${requestScope.selectedCategory}&size=${s}&sort=${requestScope.selectedSort}"
                                                class="size-chip ${s eq requestScope.selectedSize ? 'active' : ''}">${s}</a>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Rating Filter -->
                                <div class="filter-section">
                                    <h4 class="filter-title">Rating</h4>
                                    <div class="filter-options">
                                        <a href="${pageContext.request.contextPath}/products?category=${requestScope.selectedCategory}&minRating=4&sort=${requestScope.selectedSort}"
                                            class="filter-option">&#9733;&#9733;&#9733;&#9733; & up</a>
                                        <a href="${pageContext.request.contextPath}/products?category=${requestScope.selectedCategory}&minRating=3&sort=${requestScope.selectedSort}"
                                            class="filter-option">&#9733;&#9733;&#9733; & up</a>
                                    </div>
                                </div>

                                <!-- Clear Filters -->
                                <a href="${pageContext.request.contextPath}/products" class="btn btn-ghost btn-sm"
                                    style="width:100%">Clear All Filters</a>
                            </aside>

                            <!-- Product Grid -->
                            <div>
                                <!-- Sort Bar -->
                                <div class="sort-bar">
                                    <span class="result-count">${requestScope.totalCount} products found</span>
                                    <form action="${pageContext.request.contextPath}/products" method="get"
                                        id="sortForm">
                                        <c:if test="${requestScope.selectedCategory > 0}">
                                            <input type="hidden" name="category"
                                                value="${requestScope.selectedCategory}">
                                        </c:if>
                                        <c:if test="${not empty requestScope.searchQuery}">
                                            <input type="hidden" name="search" value="${requestScope.searchQuery}">
                                        </c:if>
                                        <select name="sort" class="sort-select" onchange="this.form.submit()">
                                            <option value="newest" ${requestScope.selectedSort=='newest' ? 'selected'
                                                : '' }>Newest</option>
                                            <option value="price_asc" ${requestScope.selectedSort=='price_asc'
                                                ? 'selected' : '' }>Price: Low to High</option>
                                            <option value="price_desc" ${requestScope.selectedSort=='price_desc'
                                                ? 'selected' : '' }>Price: High to Low</option>
                                            <option value="popular" ${requestScope.selectedSort=='popular' ? 'selected'
                                                : '' }>Most Popular</option>
                                            <option value="rating" ${requestScope.selectedSort=='rating' ? 'selected'
                                                : '' }>Top Rated</option>
                                        </select>
                                    </form>
                                </div>

                                <div class="product-grid">
                                    <c:choose>
                                        <c:when test="${empty requestScope.products}">
                                            <div class="empty-state" style="grid-column: 1 / -1;">
                                                <p>No products match your criteria.</p>
                                                <a href="${pageContext.request.contextPath}/products"
                                                    class="btn btn-primary mt-4">View All Products</a>
                                            </div>
                                        </c:when>
                                        <c:otherwise>
                                            <c:forEach var="product" items="${requestScope.products}">
                                                <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                                    class="product-card" style="text-decoration:none; color:inherit;">
                                                    <div class="product-image-container">
                                                        <img src="${product.primaryImageUrl}" alt="${product.name}"
                                                            class="product-image" loading="lazy">
                                                        <c:if test="${product.stock <= 0}">
                                                            <span class="product-badge"
                                                                style="background:var(--danger)">Sold Out</span>
                                                        </c:if>
                                                        <c:if test="${product.featured && product.stock > 0}">
                                                            <span class="product-badge">Featured</span>
                                                        </c:if>
                                                    </div>
                                                    <div class="product-info">
                                                        <span class="product-category">${product.categoryName}</span>
                                                        <h3 class="product-name">${product.name}</h3>
                                                        <p class="product-description">${product.shortDescription}</p>
                                                        <div class="product-footer">
                                                            <span class="product-price">
                                                                <frk:formatCurrency value="${product.price}" />
                                                            </span>
                                                            <span class="product-rating">
                                                                <span class="stars">${product.rating >= 1 ? '&#9733;' :
                                                                    '&#9734;'}${product.rating >= 2 ? '&#9733;' :
                                                                    '&#9734;'}${product.rating >= 3 ? '&#9733;' :
                                                                    '&#9734;'}${product.rating >= 4 ? '&#9733;' :
                                                                    '&#9734;'}${product.rating >= 5 ? '&#9733;' :
                                                                    '&#9734;'}</span>
                                                            </span>
                                                        </div>
                                                    </div>
                                                </a>
                                            </c:forEach>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Pagination -->
                                <c:if test="${requestScope.totalPages > 1}">
                                    <div class="pagination">
                                        <c:if test="${requestScope.currentPage > 1}">
                                            <a
                                                href="${pageContext.request.contextPath}/products?page=${requestScope.currentPage - 1}&category=${requestScope.selectedCategory}&sort=${requestScope.selectedSort}">&laquo;</a>
                                        </c:if>
                                        <c:forEach begin="1" end="${requestScope.totalPages}" var="i">
                                            <c:choose>
                                                <c:when test="${i == requestScope.currentPage}">
                                                    <span class="active">${i}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <a
                                                        href="${pageContext.request.contextPath}/products?page=${i}&category=${requestScope.selectedCategory}&sort=${requestScope.selectedSort}">${i}</a>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:forEach>
                                        <c:if test="${requestScope.currentPage < requestScope.totalPages}">
                                            <a
                                                href="${pageContext.request.contextPath}/products?page=${requestScope.currentPage + 1}&category=${requestScope.selectedCategory}&sort=${requestScope.selectedSort}">&raquo;</a>
                                        </c:if>
                                    </div>
                                </c:if>
                            </div>
                        </div>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>