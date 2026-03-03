<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://frkcollectives.com/tags" prefix="frk" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <meta name="description"
                    content="FRK Collectives — Premium minimalist apparel and accessories. Wear the Vision.">
                <title>FRK Collectives | Wear the Vision</title>
                <link rel="icon" href="${pageContext.request.contextPath}/images/logo.png" type="image/png">
                <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
                <script src="https://unpkg.com/react@18/umd/react.production.min.js" crossorigin></script>
                <script src="https://unpkg.com/react-dom@18/umd/react-dom.production.min.js" crossorigin></script>
                <script src="https://unpkg.com/babel-standalone@6/babel.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
            </head>

            <body>

                <!-- Transparent Navbar for Hero -->
                <nav class="navbar navbar-hero" id="mainNav">
                    <div class="nav-container">
                        <a href="${pageContext.request.contextPath}/home" class="nav-brand">FRK COLLECTIVES</a>
                        <div class="nav-toggle"
                            onclick="document.querySelector('.nav-links').classList.toggle('active')">
                            <span></span><span></span><span></span>
                        </div>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/products">Shop</a>
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
                                    <a href="${pageContext.request.contextPath}/dashboard">Account</a>
                                    <c:if test="${sessionScope.user.admin}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard">Admin</a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/logout">Logout</a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login">Login</a>
                                </c:otherwise>
                            </c:choose>
                            <a href="${pageContext.request.contextPath}/cart" class="cart-link">
                                Bag
                                <c:if test="${not empty sessionScope.cart}">
                                    <span class="cart-count">${sessionScope.cart.size()}</span>
                                </c:if>
                            </a>
                        </div>
                    </div>
                </nav>

                <!-- React Hero Section -->
                <div id="react-hero-root"></div>

                <script type="text/babel">

                    const Hero = () => {
                        const images = [
                            // "${pageContext.request.contextPath}/images/banner1.png",
                            // "${pageContext.request.contextPath}/images/banner2.png",
                            "${pageContext.request.contextPath}/images/banner3.png",
                            // "${pageContext.request.contextPath}/images/banner4.png"
                        ];

                        const [index, setIndex] = React.useState(0);

                        React.useEffect(() => {
                            const interval = setInterval(() => {
                                setIndex(prev => {
                                    if (prev === images.length - 1) return 0;
                                    return prev + 1;
                                });
                            }, 1000);

                            return () => clearInterval(interval);
                        }, []);

                        return (
                            <section className="hero-section">
                                <div className="hero-slider-container">
                                    <div
                                        className="hero-slider"
                                        style={{
                                            transform: `translateX(-${index * 100}%)`,
                                            transition: "transform 0.8s var(--ease-out-expo)"
                                        }}
                                    >
                                        {images.map((img, i) => (
                                            <div className="hero-slide" key={i}>
                                                <img src={img} className="hero-image" alt="banner" />
                                                <div className="hero-overlay"></div>
                                            </div>
                                        ))}
                                    </div>
                                </div>

                                <div className="hero-content">
                                    <p className="hero-overline" id="heroOverline">
                                        FRK PRODUCTIONS
                                    </p>

                                    <h1 className="hero-title" id="heroTitle">
                                        WEAR THE<br />VISION
                                    </h1>

                                    <p className="hero-subtitle" id="heroSubtitle">
                                        Premium minimalist apparel and accessories crafted for the modern metropolitan.
                                    </p>

                                    <div className="hero-cta" id="heroCta">
                                        <a href="${pageContext.request.contextPath}/products"
                                            className="btn btn-primary btn-lg hero-btn">
                                            Shop Now
                                        </a>

                                        <a href="${pageContext.request.contextPath}/products"
                                            className="btn btn-secondary btn-lg hero-btn">
                                            Explore Collection
                                        </a>
                                    </div>
                                </div>
                            </section>
                        );
                    };

                    const root = ReactDOM.createRoot(
                        document.getElementById('react-hero-root')
                    );

                    root.render(<Hero />);

                </script>

                <!-- Featured Products Section -->
                <section class="section" style="background: var(--off-white);">
                    <div class="container">
                        <div class="section-header reveal">
                            <p class="section-overline">Curated Selection</p>
                            <h2 class="section-title">Featured Collection</h2>
                            <p class="section-subtitle">Handpicked pieces that define the FRK aesthetic.</p>
                        </div>
                        <div class="product-grid">
                            <c:forEach var="product" items="${requestScope.featuredProducts}" varStatus="status">
                                <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                    class="product-card reveal stagger-${(status.index % 4) + 1}"
                                    style="text-decoration:none; color:inherit;">
                                    <div class="product-image-container">
                                        <img src="${product.primaryImageUrl}" alt="${product.name}"
                                            class="product-image" loading="lazy">
                                        <c:if test="${product.featured}">
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
                                                    '&#9734;'}${product.rating >= 5 ? '&#9733;' : '&#9734;'}</span>
                                                (${product.reviewCount})
                                            </span>
                                        </div>
                                    </div>
                                </a>
                            </c:forEach>
                        </div>

                        <div class="text-center mt-8">
                            <a href="${pageContext.request.contextPath}/products" class="btn btn-secondary">View All
                                Products</a>
                        </div>
                    </div>
                </section>

                <!-- Categories Section -->
                <section class="section">
                    <div class="container">
                        <div class="section-header reveal">
                            <p class="section-overline">Browse By</p>
                            <h2 class="section-title">Categories</h2>
                        </div>
                        <div class="category-grid">
                            <c:forEach var="category" items="${requestScope.categories}">
                                <a href="${pageContext.request.contextPath}/products?category=${category.id}"
                                    class="category-card reveal" style="text-decoration:none; color:inherit;">
                                    <h3>${category.name}</h3>
                                    <p>${category.description}</p>
                                </a>
                            </c:forEach>
                        </div>
                    </div>
                </section>

                <!-- Best Sellers Section -->
                <c:if test="${not empty requestScope.bestSellers}">
                    <section class="section" style="background: var(--off-white);">
                        <div class="container">
                            <div class="section-header reveal">
                                <p class="section-overline">Most Popular</p>
                                <h2 class="section-title">Best Sellers</h2>
                            </div>
                            <div class="product-grid">
                                <c:forEach var="product" items="${requestScope.bestSellers}">
                                    <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                        class="product-card reveal" style="text-decoration:none; color:inherit;">
                                        <div class="product-image-container">
                                            <img src="${product.primaryImageUrl}" alt="${product.name}"
                                                class="product-image" loading="lazy">
                                        </div>
                                        <div class="product-info">
                                            <span class="product-category">${product.categoryName}</span>
                                            <h3 class="product-name">${product.name}</h3>
                                            <div class="product-footer">
                                                <span class="product-price">
                                                    <frk:formatCurrency value="${product.price}" />
                                                </span>
                                                <span class="product-rating">
                                                    <span class="stars">${product.rating >= 1 ? '&#9733;' :
                                                        '&#9734;'}${product.rating >= 2 ? '&#9733;' :
                                                        '&#9734;'}${product.rating >= 3 ? '&#9733;' :
                                                        '&#9734;'}${product.rating >= 4 ? '&#9733;' :
                                                        '&#9734;'}${product.rating >= 5 ? '&#9733;' : '&#9734;'}</span>
                                                    (${product.reviewCount})
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

                    <!-- GSAP Animations -->
                    <script>
                        // Navbar scroll effect
                        window.addEventListener('scroll', () => {
                            const nav = document.getElementById('mainNav');
                            if (window.scrollY > 50) {
                                nav.classList.add('navbar-scrolled');
                            } else {
                                nav.classList.remove('navbar-scrolled');
                            }
                        });

                        // GSAP Hero Animation
                        gsap.registerPlugin(ScrollTrigger);

                        gsap.fromTo('#heroOverline', { opacity: 0, y: 30 }, { opacity: 1, y: 0, duration: 1, delay: 0.5, ease: 'expo.out' });
                        gsap.fromTo('#heroTitle', { opacity: 0, y: 50 }, { opacity: 1, y: 0, duration: 1.2, delay: 0.7, ease: 'expo.out' });
                        gsap.fromTo('#heroSubtitle', { opacity: 0, y: 30 }, { opacity: 1, y: 0, duration: 1, delay: 1, ease: 'expo.out' });
                        gsap.fromTo('#heroCta', { opacity: 0, y: 20 }, { opacity: 1, y: 0, duration: 1, delay: 1.2, ease: 'expo.out' });

                        // Scroll Reveal
                        const reveals = document.querySelectorAll('.reveal');
                        const observer = new IntersectionObserver((entries) => {
                            entries.forEach(entry => {
                                if (entry.isIntersecting) {
                                    entry.target.classList.add('visible');
                                }
                            });
                        }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

                        reveals.forEach(el => observer.observe(el));
                    </script>

            </body>

            </html>