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
                <link href="https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;500;600;700&family=DM+Sans:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css?v=4.1">
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
                        <a href="${pageContext.request.contextPath}/home" class="nav-brand">FRK Collectives</a>
                        <div class="nav-center">
                            <!-- Centered content removed in favor of minimalist icon-only navigation -->
                        </div>
                        <div class="nav-right">
                            <a href="${pageContext.request.contextPath}/products" class="nav-icon-link" aria-label="Shop">
                                <i data-feather="grid" style="width: 20px; height: 20px;"></i>
                            </a>
                            
                            <c:if test="${empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/login" class="nav-icon-link" aria-label="Login">
                                    <i data-feather="user" style="width: 20px; height: 20px;"></i>
                                </a>
                            </c:if>

                            <c:if test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/dashboard" class="nav-icon-link" aria-label="Account">
                                    <i data-feather="user" style="width: 20px; height: 20px;"></i>
                                </a>
                                <a href="${pageContext.request.contextPath}/wishlist" class="nav-icon-link" aria-label="Wishlist">
                                    <i data-feather="heart" style="width: 20px; height: 20px;"></i>
                                </a>
                            </c:if>

                            <c:if test="${not empty sessionScope.user && sessionScope.user.admin}">
                                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-icon-link" aria-label="Admin">
                                    <i data-feather="shield" style="width: 20px; height: 20px;"></i>
                                </a>
                            </c:if>

                            <a href="${pageContext.request.contextPath}/cart" class="nav-icon-link cart-link" aria-label="Cart">
                                <i data-feather="shopping-bag" style="width: 20px; height: 20px;"></i>
                                <c:if test="${not empty sessionScope.cart}">
                                    <span class="cart-count">${sessionScope.cart.size()}</span>
                                </c:if>
                            </a>

                            <c:if test="${not empty sessionScope.user}">
                                <a href="${pageContext.request.contextPath}/logout" class="nav-icon-link" aria-label="Logout">
                                    <i data-feather="log-out" style="width: 20px; height: 20px;"></i>
                                </a>
                            </c:if>
                        </div>
                        <button class="nav-toggle" onclick="document.querySelector('.nav-overlay').classList.add('active')" aria-label="Menu">
                            <span></span><span></span>
                        </button>
                    </div>
                </nav>

                <!-- Mobile Overlay -->
                <div class="nav-overlay">
                    <button class="nav-overlay-close" onclick="this.parentElement.classList.remove('active')">&times;</button>
                    <div class="nav-overlay-links">
                        <a href="${pageContext.request.contextPath}/products">Shop</a>
                        <c:if test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
                            <a href="${pageContext.request.contextPath}/dashboard">Account</a>
                            <a href="${pageContext.request.contextPath}/cart">Bag</a>
                            <a href="${pageContext.request.contextPath}/logout">Logout</a>
                        </c:if>
                        <c:if test="${empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/login">Login</a>
                        </c:if>
                    </div>
                </div>

                <!-- React Hero Section -->
                <div id="react-hero-root"></div>

                <script type="text/babel">

                    // --- Character Split Utility ---
                    function SplitText({ text, className, id }) {
                        const words = text.split(' ');
                        return (
                            <h1 className={className} id={id} style={{ marginBottom: '32px' }}>
                                {words.map((word, wi) => (
                                    <span className="hero-word" key={wi}>
                                        {word.split('').map((char, ci) => (
                                            <span className="hero-char" key={ci} style={{ opacity: 0, transform: 'translateY(100%)' }}>{char}</span>
                                        ))}
                                        {wi < words.length - 1 && <span className="hero-char">&nbsp;</span>}
                                    </span>
                                ))}
                            </h1>
                        );
                    }

                    const Hero = () => {
                        const images = [
                            "${pageContext.request.contextPath}/images/banner2.png",
                            "${pageContext.request.contextPath}/images/banner3.png",
                            "${pageContext.request.contextPath}/images/banner4.png"
                        ];

                        const [index, setIndex] = React.useState(0);

                        React.useEffect(() => {
                            // Carousel auto-rotate
                            const interval = setInterval(() => {
                                setIndex(prev => (prev + 1) % images.length);
                            }, 5000);

                            // --- CINEMATIC HERO ANIMATION ---
                            const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

                            if (window.gsap && !reducedMotion) {
                                const tl = gsap.timeline({ defaults: { ease: 'expo.out' } });

                                // Character split-reveal stagger
                                tl.to('.hero-char', {
                                    opacity: 1,
                                    y: 0,
                                    duration: 0.8,
                                    stagger: 0.035,
                                    delay: 0.3
                                });

                                // CTA buttons fade up
                                tl.fromTo('#heroCta',
                                    { opacity: 0, y: 30 },
                                    { opacity: 1, y: 0, duration: 0.8 },
                                    '-=0.3'
                                );

                                // Dots fade in
                                tl.fromTo('.hero-dots',
                                    { opacity: 0 },
                                    { opacity: 1, duration: 0.6 },
                                    '-=0.4'
                                );
                            } else {
                                // Instant reveal for reduced-motion
                                document.querySelectorAll('.hero-char').forEach(function(c) {
                                    c.style.opacity = '1';
                                    c.style.transform = 'none';
                                });
                            }

                            if (window.feather) {
                                feather.replace({ strokeWidth: 1.5 });
                            }

                            return () => clearInterval(interval);
                        }, []);

                        return (
                            <section className="hero-section">
                                <div className="hero-slider-container">
                                    <div
                                        className="hero-slider"
                                        style={{
                                            transform: "translateX(-" + (index * 100) + "%)",
                                            transition: "transform 1s cubic-bezier(0.16, 1, 0.3, 1)"
                                        }}
                                    >
                                        {images.map((img, i) => (
                                            <div className="hero-slide" key={i}>
                                                <img src={img} className="hero-image" alt={"FRK Collection " + (i + 1)} />
                                                <div className="hero-overlay"></div>
                                            </div>
                                        ))}
                                    </div>
                                </div>

                                {/* Carousel Dots */}
                                <div className="hero-dots" style={{ opacity: 0 }}>
                                    {images.map((_, i) => (
                                        <button
                                            key={i}
                                            className={"hero-dot " + (i === index ? "active" : "")}
                                            onClick={() => setIndex(i)}
                                            aria-label={"Slide " + (i + 1)}
                                        />
                                    ))}
                                </div>

                                <div className="hero-content">
                                    <SplitText text="WEAR THE VISION" className="hero-title hero-title-split" id="heroTitle" />

                                    <div className="hero-cta" id="heroCta" style={{ opacity: 0 }}>
                                        <a href="${pageContext.request.contextPath}/products"
                                            className="btn btn-primary btn-lg hero-btn" style={{ gap: '10px' }}>
                                            <i data-feather="shopping-bag" style={{ width: '18px', height: '18px' }}></i>
                                            Shop Now
                                        </a>

                                        <a href="${pageContext.request.contextPath}/products"
                                            className="btn btn-secondary btn-lg hero-btn" style={{ gap: '10px' }}>
                                            Explore Collection
                                            <i data-feather="arrow-right" style={{ width: '18px', height: '18px' }}></i>
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
                <section class="section">
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

                <!-- New Arrivals — Horizontal Scroll Strip -->
                <c:if test="${not empty requestScope.featuredProducts}">
                    <section class="horizontal-scroll-section" id="newArrivalsSection">
                        <div class="section-header">
                            <p class="section-overline">Just Dropped</p>
                            <h2 class="section-title">New Arrivals</h2>
                            <p class="section-subtitle">Scroll to explore the latest additions to the collection.</p>
                        </div>
                        <div class="scroll-strip-wrapper">
                            <div class="scroll-strip" id="scrollStrip">
                                <c:forEach var="product" items="${requestScope.featuredProducts}">
                                    <a href="${pageContext.request.contextPath}/product?id=${product.id}"
                                        class="product-card" style="text-decoration:none; color:inherit;">
                                        <div class="product-image-container">
                                            <img src="${product.primaryImageUrl}" alt="${product.name}"
                                                class="product-image" loading="lazy">
                                            <c:if test="${product.featured}">
                                                <span class="product-badge">New</span>
                                            </c:if>
                                        </div>
                                        <div class="product-info">
                                            <span class="product-category">${product.categoryName}</span>
                                            <h3 class="product-name">${product.name}</h3>
                                            <div class="product-footer">
                                                <span class="product-price">
                                                    <frk:formatCurrency value="${product.price}" />
                                                </span>
                                            </div>
                                        </div>
                                    </a>
                                </c:forEach>
                            </div>
                        </div>
                    </section>
                </c:if>

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
                    <section class="section">
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

                    <!-- GSAP Cinematic Animation Engine -->
                    <script src="${pageContext.request.contextPath}/js/cursor.js"></script>
                    <script src="${pageContext.request.contextPath}/js/transitions.js"></script>
                    <script>
                        (function() {
                            'use strict';
                            var reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
                            if (reducedMotion) return;

                            gsap.registerPlugin(ScrollTrigger);

                            // ========== NAVBAR HIDE/SHOW ON SCROLL ==========
                            (function() {
                                var nav = document.getElementById('mainNav');
                                if (!nav) return;
                                var lastScroll = 0;
                                var threshold = 80;

                                window.addEventListener('scroll', function() {
                                    var currentScroll = window.scrollY;

                                    // Always add scrolled class past threshold
                                    if (currentScroll > 50) {
                                        nav.classList.add('navbar-scrolled');
                                    } else {
                                        nav.classList.remove('navbar-scrolled');
                                    }

                                    // Hide on scroll down, show on scroll up
                                    if (currentScroll > threshold) {
                                        if (currentScroll > lastScroll + 5) {
                                            // Scrolling down
                                            gsap.to(nav, { y: '-100%', duration: 0.35, ease: 'power2.inOut' });
                                        } else if (currentScroll < lastScroll - 5) {
                                            // Scrolling up
                                            gsap.to(nav, { y: '0%', duration: 0.35, ease: 'power2.out' });
                                        }
                                    } else {
                                        gsap.to(nav, { y: '0%', duration: 0.2, ease: 'power2.out' });
                                    }

                                    lastScroll = currentScroll;
                                }, { passive: true });
                            })();

                            // ========== SCROLL-TRIGGERED REVEALS (Intersection Observer) ==========
                            var reveals = document.querySelectorAll('.reveal');
                            if ('IntersectionObserver' in window) {
                                var observer = new IntersectionObserver(function(entries) {
                                    entries.forEach(function(entry) {
                                        if (entry.isIntersecting) {
                                            entry.target.classList.add('visible');
                                            // Optional: Stop observing once revealed
                                            // observer.unobserve(entry.target);
                                        }
                                    });
                                }, { threshold: 0.1, rootMargin: '0px 0px -50px 0px' });

                                reveals.forEach(function(el) {
                                    observer.observe(el);
                                });
                            } else {
                                // Fallback for older browsers
                                reveals.forEach(function(el) {
                                    el.classList.add('visible');
                                });
                            }

                            // ========== HORIZONTAL SCROLL STRIP (New Arrivals) ==========
                            var strip = document.getElementById('scrollStrip');
                            var section = document.getElementById('newArrivalsSection');
                            if (strip && section) {
                                var totalWidth = strip.scrollWidth - window.innerWidth;

                                if (totalWidth > 0) {
                                    gsap.to(strip, {
                                        x: function() { return -totalWidth; },
                                        ease: 'none',
                                        scrollTrigger: {
                                            trigger: section,
                                            start: 'top top',
                                            end: function() { return '+=' + totalWidth; },
                                            pin: true,
                                            scrub: 1,
                                            invalidateOnRefresh: true,
                                            anticipatePin: 1
                                        }
                                    });
                                } else {
                                    // If items fit on screen, center them to avoid awkward gaps
                                    strip.style.justifyContent = 'center';
                                }
                            }

                        })();
                    </script>

            </body>

            </html>