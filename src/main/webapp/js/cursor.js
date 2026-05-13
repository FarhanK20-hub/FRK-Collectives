/**
 * FRK Collectives — Custom Cursor System
 * Dark ring cursor + Gold trailing dot
 * GPU-accelerated, touch-device aware, reduced-motion safe
 */
(function () {
    'use strict';

    // Bail on touch devices or reduced-motion preference
    if ('ontouchstart' in window || navigator.maxTouchPoints > 0) return;
    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

    // Create cursor elements
    const ring = document.createElement('div');
    ring.className = 'custom-cursor';
    ring.setAttribute('aria-hidden', 'true');

    const dot = document.createElement('div');
    dot.className = 'cursor-dot';
    dot.setAttribute('aria-hidden', 'true');

    document.body.appendChild(ring);
    document.body.appendChild(dot);

    let mouseX = -100, mouseY = -100;
    let ringX = -100, ringY = -100;
    let dotX = -100, dotY = -100;
    let isHovering = false;
    let isVisible = false;

    // Lerp for smooth trailing
    function lerp(a, b, t) {
        return a + (b - a) * t;
    }

    // Animation loop
    function tick() {
        // Ring follows with slight delay
        ringX = lerp(ringX, mouseX, 0.18);
        ringY = lerp(ringY, mouseY, 0.18);

        // Dot follows with more delay for trailing effect
        dotX = lerp(dotX, mouseX, 0.12);
        dotY = lerp(dotY, mouseY, 0.12);

        ring.style.transform = 'translate(' + ringX + 'px, ' + ringY + 'px) translate(-50%, -50%)' + (isHovering ? ' scale(1.6)' : ' scale(1)');
        dot.style.transform = 'translate(' + dotX + 'px, ' + dotY + 'px) translate(-50%, -50%)' + (isHovering ? ' scale(1.8)' : ' scale(1)');

        requestAnimationFrame(tick);
    }

    // Track mouse
    document.addEventListener('mousemove', function (e) {
        mouseX = e.clientX;
        mouseY = e.clientY;

        if (!isVisible) {
            isVisible = true;
            ring.style.opacity = '1';
            dot.style.opacity = '1';
        }
    });

    // Hide when mouse leaves window
    document.addEventListener('mouseleave', function () {
        isVisible = false;
        ring.style.opacity = '0';
        dot.style.opacity = '0';
    });

    document.addEventListener('mouseenter', function () {
        isVisible = true;
        ring.style.opacity = '1';
        dot.style.opacity = '1';
    });

    // Detect hoverable elements
    function addHoverListeners() {
        var interactives = document.querySelectorAll('a, button, input, select, textarea, .product-card, .category-card, .btn, [role="button"]');
        interactives.forEach(function (el) {
            if (el.dataset.cursorBound) return;
            el.dataset.cursorBound = '1';
            el.addEventListener('mouseenter', function () { isHovering = true; });
            el.addEventListener('mouseleave', function () { isHovering = false; });
        });
    }

    // Initial bind + periodic re-bind for dynamic content
    addHoverListeners();
    setInterval(addHoverListeners, 2000);

    // Start animation loop
    requestAnimationFrame(tick);
})();
