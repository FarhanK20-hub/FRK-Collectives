<!-- Minimal Premium Footer -->
<footer class="footer">
    <div class="container">
        <div class="footer-grid">
            <div class="footer-brand-col">
                <div class="footer-brand">FRK</div>
                <p class="footer-description">
                    Premium minimalist apparel crafted for the modern metropolitan. Wear the Vision.
                </p>
            </div>
            <div class="footer-links-col">
                <a href="${pageContext.request.contextPath}/products">Shop All</a>
                <a href="${pageContext.request.contextPath}/products?category=1">Hoodies</a>
                <a href="${pageContext.request.contextPath}/products?category=2">Shoes</a>
                <a href="${pageContext.request.contextPath}/products?category=3">Bags</a>
            </div>
            <div class="footer-links-col">
                <a href="${pageContext.request.contextPath}/login">Account</a>
                <a href="#">About</a>
                <a href="#">Contact</a>
                <a href="#">Privacy</a>
            </div>
            <div class="footer-social-col">
                <a href="#" aria-label="Instagram">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><rect x="2" y="2" width="20" height="20" rx="5"/><circle cx="12" cy="12" r="5"/><circle cx="17.5" cy="6.5" r="1.5" fill="currentColor" stroke="none"/></svg>
                </a>
                <a href="#" aria-label="Twitter">
                    <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5"><path d="M23 3a10.9 10.9 0 0 1-3.14 1.53 4.48 4.48 0 0 0-7.86 3v1A10.66 10.66 0 0 1 3 4s-4 9 5 13a11.64 11.64 0 0 1-7 2c9 5 20 0 20-11.5a4.5 4.5 0 0 0-.08-.83A7.72 7.72 0 0 0 23 3z"/></svg>
                </a>
            </div>
        </div>
        <div class="footer-bottom">
            <span>&copy; 2026 FRK Collectives</span>
            <span>Designed in India</span>
        </div>
    </div>
</footer>
<script src="https://unpkg.com/feather-icons"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/gsap.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/gsap/3.12.5/ScrollTrigger.min.js"></script>
<script>
    if (typeof feather !== 'undefined') {
        feather.replace({ strokeWidth: 1.5 });
    }
</script>
<script src="${pageContext.request.contextPath}/js/cursor.js"></script>
<script src="${pageContext.request.contextPath}/js/transitions.js"></script>
<script>
    // Global navbar hide/show on scroll (for non-index pages)
    (function() {
        if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
        if (!window.gsap) return;

        var nav = document.getElementById('mainNav');
        if (!nav || nav.classList.contains('navbar-hero')) return; // Skip index.jsp hero nav

        var lastScroll = 0;
        window.addEventListener('scroll', function() {
            var s = window.scrollY;
            if (s > 80) {
                if (s > lastScroll + 5) {
                    gsap.to(nav, { y: '-100%', duration: 0.35, ease: 'power2.inOut' });
                } else if (s < lastScroll - 5) {
                    gsap.to(nav, { y: '0%', duration: 0.35, ease: 'power2.out' });
                }
            } else {
                gsap.to(nav, { y: '0%', duration: 0.2, ease: 'power2.out' });
            }
            lastScroll = s;
        }, { passive: true });
    })();
</script>