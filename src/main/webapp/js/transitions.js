/**
 * FRK Collectives — Page Transition System
 * Dark circle-wipe overlay between internal pages
 * Respects prefers-reduced-motion
 */
(function () {
    'use strict';

    if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
    if (!window.gsap) return;

    // Create overlay element
    var overlay = document.createElement('div');
    overlay.className = 'page-transition-overlay';
    overlay.setAttribute('aria-hidden', 'true');
    document.body.appendChild(overlay);

    // Intercept internal link clicks
    document.addEventListener('click', function (e) {
        var link = e.target.closest('a[href]');
        if (!link) return;

        var href = link.getAttribute('href');

        // Skip external links, anchors, form actions, new tabs
        if (!href) return;
        if (href.startsWith('#') || href.startsWith('javascript:')) return;
        if (href.startsWith('http') && !href.includes(window.location.hostname)) return;
        if (link.target === '_blank') return;
        if (e.ctrlKey || e.metaKey || e.shiftKey) return;

        e.preventDefault();

        // Animate overlay in, then navigate
        gsap.set(overlay, { display: 'block', opacity: 0 });
        gsap.to(overlay, {
            opacity: 1,
            duration: 0.35,
            ease: 'power2.inOut',
            onComplete: function () {
                window.location.href = href;
            }
        });
    });
})();
