<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>${product.name} | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container">
                        <div class="product-detail">
                            <!-- Image Gallery -->
                            <div class="product-gallery">
                                <img src="${product.primaryImageUrl}" alt="${product.name}" class="product-main-image"
                                    id="mainImage">
                                <c:if test="${not empty product.images && product.images.size() > 1}">
                                    <div class="product-thumbnails">
                                        <c:forEach var="img" items="${product.images}" varStatus="s">
                                            <img src="${img}" alt="${product.name} ${s.index + 1}"
                                                class="product-thumbnail ${s.index == 0 ? 'active' : ''}"
                                                onclick="document.getElementById('mainImage').src=this.src; document.querySelectorAll('.product-thumbnail').forEach(t=>t.classList.remove('active')); this.classList.add('active');">
                                        </c:forEach>
                                    </div>
                                </c:if>
                            </div>

                            <!-- Product Info -->
                            <div class="product-detail-info">
                                <p class="product-detail-brand">${product.brand}</p>
                                <h1 class="product-detail-name">${product.name}</h1>
                                <p class="product-detail-price">
                                    <frk:formatCurrency value="${product.price}" />
                                </p>

                                <div class="product-detail-rating">
                                    <span class="stars" style="letter-spacing:2px;">
                                        ${product.rating >= 1 ? '&#9733;' : '&#9734;'}${product.rating >= 2 ? '&#9733;'
                                        : '&#9734;'}${product.rating >= 3 ? '&#9733;' : '&#9734;'}${product.rating >= 4
                                        ? '&#9733;' : '&#9734;'}${product.rating >= 5 ? '&#9733;' : '&#9734;'}
                                    </span>
                                    <span class="text-muted">${product.rating} (${product.reviewCount} reviews)</span>
                                </div>

                                <p class="product-detail-description">${product.detailedDescription}</p>

                                <div class="product-detail-divider"></div>

                                <!-- Size Selector -->
                                <div class="size-selector">
                                    <p class="size-selector-title">Select Size</p>
                                    <div class="size-options" id="sizeOptions">
                                        <c:forEach var="sz" items="${product.sizeList}">
                                            <button type="button" class="size-option" data-size="${sz}"
                                                onclick="selectSize(this, '${sz}')">${sz}</button>
                                        </c:forEach>
                                    </div>
                                </div>

                                <!-- Stock Status -->
                                <div class="stock-status">
                                    <c:choose>
                                        <c:when test="${product.stock > 0}">
                                            <span class="stock-dot"></span>
                                            <span>In Stock (${product.stock} available)</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-dot out"></span>
                                            <span class="text-danger">Out of Stock</span>
                                        </c:otherwise>
                                    </c:choose>
                                </div>

                                <!-- Action Buttons -->
                                <div class="product-actions">
                                    <form action="${pageContext.request.contextPath}/cart" method="post" style="flex:1">
                                        <input type="hidden" name="action" value="add">
                                        <input type="hidden" name="productId" value="${product.id}">
                                        <input type="hidden" name="size" value="M" id="selectedSizeInput">
                                        <button type="submit" class="btn btn-primary btn-block" ${product.stock <=0
                                            ? 'disabled' : '' }>
                                            ${product.stock > 0 ? 'Add to Bag' : 'Sold Out'}
                                        </button>
                                    </form>
                                    <c:if test="${not empty sessionScope.user}">
                                        <form
                                            action="${pageContext.request.contextPath}/wishlist/${inWishlist ? 'remove' : 'add'}"
                                            method="post">
                                            <input type="hidden" name="productId" value="${product.id}">
                                            <input type="hidden" name="redirect"
                                                value="${pageContext.request.contextPath}/product?id=${product.id}">
                                            <button type="submit"
                                                class="btn ${inWishlist ? 'btn-danger' : 'btn-secondary'}">
                                                ${inWishlist ? '&#9829; Saved' : '&#9825; Wishlist'}
                                            </button>
                                        </form>
                                    </c:if>
                                </div>

                                <div class="product-detail-divider"></div>

                                <div class="product-meta">
                                    <p><strong>Category:</strong> ${product.categoryName}</p>
                                    <p><strong>Brand:</strong> ${product.brand}</p>
                                    <p><strong>SKU:</strong> FRK-${product.id}00${product.id}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Reviews Section -->
                    <section class="reviews-section" id="reviews">
                        <div class="container">
                            <h2 class="section-title">Reviews (${product.reviewCount})</h2>

                            <c:if test="${not empty requestScope.reviews}">
                                <div class="review-list">
                                    <c:forEach var="review" items="${requestScope.reviews}">
                                        <div class="review-item">
                                            <div class="review-header">
                                                <span class="review-author">${review.userName}</span>
                                                <span class="review-date">${review.createdAt}</span>
                                            </div>
                                            <div class="review-stars">
                                                ${review.rating >= 1 ? '&#9733;' : '&#9734;'}${review.rating >= 2 ?
                                                '&#9733;' : '&#9734;'}${review.rating >= 3 ? '&#9733;' :
                                                '&#9734;'}${review.rating >= 4 ? '&#9733;' : '&#9734;'}${review.rating
                                                >= 5 ? '&#9733;' : '&#9734;'}
                                            </div>
                                            <p class="review-comment">${review.comment}</p>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:if>

                            <c:if test="${not empty sessionScope.user}">
                                <form class="review-form" action="${pageContext.request.contextPath}/product"
                                    method="post">
                                    <h3 style="margin-bottom:16px;">Write a Review</h3>
                                    <input type="hidden" name="productId" value="${product.id}">
                                    <div class="form-group">
                                        <label>Rating</label>
                                        <select name="rating" class="form-control" required style="max-width:200px">
                                            <option value="5">★★★★★ (5)</option>
                                            <option value="4">★★★★☆ (4)</option>
                                            <option value="3">★★★☆☆ (3)</option>
                                            <option value="2">★★☆☆☆ (2)</option>
                                            <option value="1">★☆☆☆☆ (1)</option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label>Your Review</label>
                                        <textarea name="comment" class="form-control"
                                            placeholder="Share your experience..." required></textarea>
                                    </div>
                                    <button type="submit" class="btn btn-primary">Submit Review</button>
                                </form>
                            </c:if>
                        </div>
                    </section>

                    <!-- Related Products -->
                    <c:if test="${not empty requestScope.relatedProducts}">
                        <section class="section">
                            <div class="container">
                                <h2 class="section-title">You May Also Like</h2>
                                <div class="product-grid">
                                    <c:forEach var="rp" items="${requestScope.relatedProducts}">
                                        <a href="${pageContext.request.contextPath}/product?id=${rp.id}"
                                            class="product-card" style="text-decoration:none; color:inherit;">
                                            <div class="product-image-container">
                                                <img src="${rp.primaryImageUrl}" alt="${rp.name}" class="product-image"
                                                    loading="lazy">
                                            </div>
                                            <div class="product-info">
                                                <span class="product-category">${rp.categoryName}</span>
                                                <h3 class="product-name">${rp.name}</h3>
                                                <div class="product-footer">
                                                    <span class="product-price">
                                                        <frk:formatCurrency value="${rp.price}" />
                                                    </span>
                                                </div>
                                            </div>
                                        </a>
                                    </c:forEach>
                                </div>
                            </div>
                        </section>
                    </c:if>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

                        <script>
                            function selectSize(btn, size) {
                                document.querySelectorAll('.size-option').forEach(b => b.classList.remove('selected'));
                                btn.classList.add('selected');
                                document.getElementById('selectedSizeInput').value = size;
                            }
                            // Auto-select first size
                            const firstSize = document.querySelector('.size-option');
                            if (firstSize) firstSize.click();
                        </script>

            </body>

            </html>