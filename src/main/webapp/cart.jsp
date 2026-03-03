<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Shopping Bag | FRK Collectives</title>
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
            </head>

            <body class="bg-light">

                <%@ include file="/WEB-INF/fragments/header.jsp" %>

                    <div class="container main-content">
                        <h2 class="section-title">Shopping Bag</h2>

                        <c:choose>
                            <c:when test="${empty sessionScope.cart}">
                                <div class="empty-state">
                                    <p>Your bag is empty.</p>
                                    <a href="${pageContext.request.contextPath}/products"
                                        class="btn btn-primary mt-4">Continue Shopping</a>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div class="cart-layout">
                                    <div class="cart-items">
                                        <c:forEach var="item" items="${sessionScope.cart}">
                                            <div class="cart-item">
                                                <img src="${item.product.primaryImageUrl}" alt="${item.product.name}"
                                                    class="cart-item-image">
                                                <div class="cart-item-details">
                                                    <h4 class="cart-item-name">${item.product.name}</h4>
                                                    <p class="cart-item-category">${item.product.categoryName}</p>
                                                    <p class="cart-item-size">Size: ${item.selectedSize}</p>
                                                    <p class="cart-item-price">
                                                        <frk:formatCurrency value="${item.product.price}" />
                                                    </p>
                                                    <div class="cart-actions">
                                                        <form action="${pageContext.request.contextPath}/cart"
                                                            method="post" class="update-form">
                                                            <input type="hidden" name="action" value="update">
                                                            <input type="hidden" name="productId"
                                                                value="${item.product.id}">
                                                            <input type="hidden" name="size"
                                                                value="${item.selectedSize}">
                                                            <input type="number" name="quantity"
                                                                value="${item.quantity}" min="1" max="10"
                                                                class="qty-input">
                                                            <button type="submit" class="btn-link">Update</button>
                                                        </form>
                                                        <form action="${pageContext.request.contextPath}/cart"
                                                            method="post">
                                                            <input type="hidden" name="action" value="remove">
                                                            <input type="hidden" name="productId"
                                                                value="${item.product.id}">
                                                            <input type="hidden" name="size"
                                                                value="${item.selectedSize}">
                                                            <button type="submit"
                                                                class="btn-link text-danger">Remove</button>
                                                        </form>
                                                    </div>
                                                </div>
                                                <div class="cart-item-subtotal">
                                                    <strong>
                                                        <frk:formatCurrency value="${item.subtotal}" />
                                                    </strong>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>

                                    <div class="cart-summary">
                                        <h3>Order Summary</h3>
                                        <div class="summary-line">
                                            <span>Subtotal</span>
                                            <span>
                                                <frk:formatCurrency value="${requestScope.subtotal}" />
                                            </span>
                                        </div>
                                        <div class="summary-line">
                                            <span>GST (18%)</span>
                                            <span>
                                                <frk:formatCurrency value="${requestScope.gst}" />
                                            </span>
                                        </div>
                                        <div class="summary-line">
                                            <span>Shipping</span>
                                            <span>
                                                <c:choose>
                                                    <c:when test="${requestScope.shipping == 0}">
                                                        <span class="text-success">Free</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <frk:formatCurrency value="${requestScope.shipping}" />
                                                    </c:otherwise>
                                                </c:choose>
                                            </span>
                                        </div>
                                        <hr>
                                        <div class="summary-line total-line">
                                            <span>Grand Total</span>
                                            <span>
                                                <frk:formatCurrency value="${requestScope.grandTotal}" />
                                            </span>
                                        </div>

                                        <c:if test="${requestScope.shipping > 0}">
                                            <p class="free-shipping-note">
                                                Add
                                                <frk:formatCurrency
                                                    value="${requestScope.freeShippingThreshold - requestScope.subtotal}" />
                                                more for free shipping
                                            </p>
                                        </c:if>

                                        <a href="${pageContext.request.contextPath}/checkout"
                                            class="btn btn-primary btn-block mt-8">Proceed to Checkout</a>
                                        <a href="${pageContext.request.contextPath}/products"
                                            class="btn btn-ghost btn-block mt-2">Continue Shopping</a>
                                    </div>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <%@ include file="/WEB-INF/fragments/footer.jsp" %>

            </body>

            </html>