/**
 * Sawtak - Main JavaScript Module
 * Handles landing page interactions and animations
 */

document.addEventListener('DOMContentLoaded', function() {
  'use strict';

  // ============================================
  // DOM Elements
  // ============================================
  const header = document.getElementById('header');
  const menuBtn = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const navLinks = document.querySelectorAll('.header__nav-link, .mobile-menu__link');
  const revealElements = document.querySelectorAll('.reveal');
  const counterElements = document.querySelectorAll('[data-count]');
  const tabTriggers = document.querySelectorAll('.tabs__trigger');
  const tabContents = document.querySelectorAll('.tabs__content');

  // ============================================
  // Header Scroll Effect
  // ============================================
  function handleHeaderScroll() {
    if (window.scrollY > 50) {
      header.classList.add('header--scrolled');
    } else {
      header.classList.remove('header--scrolled');
    }
  }

  window.addEventListener('scroll', handleHeaderScroll, { passive: true });

  // ============================================
  // Mobile Menu Toggle
  // ============================================
  function toggleMobileMenu() {
    mobileMenu.classList.toggle('mobile-menu--open');
    const isOpen = mobileMenu.classList.contains('mobile-menu--open');
    menuBtn.innerHTML = isOpen 
      ? '<i data-lucide="x"></i>' 
      : '<i data-lucide="menu"></i>';
    
    // Re-initialize icons after changing innerHTML
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  if (menuBtn) {
    menuBtn.addEventListener('click', toggleMobileMenu);
  }

  // Close mobile menu when clicking a link
  document.querySelectorAll('.mobile-menu__link').forEach(link => {
    link.addEventListener('click', () => {
      mobileMenu.classList.remove('mobile-menu--open');
      menuBtn.innerHTML = '<i data-lucide="menu"></i>';
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    });
  });

  // ============================================
  // Smooth Scroll Navigation
  // ============================================
  function smoothScroll(e) {
    e.preventDefault();
    const targetId = this.getAttribute('href');
    const targetSection = document.querySelector(targetId);
    
    if (targetSection) {
      const headerHeight = header.offsetHeight;
      const targetPosition = targetSection.offsetTop - headerHeight;
      
      window.scrollTo({
        top: targetPosition,
        behavior: 'smooth'
      });

      // Update active nav link
      navLinks.forEach(link => link.classList.remove('header__nav-link--active'));
      document.querySelectorAll(`[href="${targetId}"]`).forEach(link => {
        link.classList.add('header__nav-link--active');
      });
    }
  }

  navLinks.forEach(link => {
    link.addEventListener('click', smoothScroll);
  });

  // ============================================
  // Scroll Reveal Animation
  // ============================================
  const revealObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        entry.target.classList.add('reveal--visible');
        revealObserver.unobserve(entry.target);
      }
    });
  }, {
    threshold: 0.1,
    rootMargin: '0px 0px -50px 0px'
  });

  revealElements.forEach(el => {
    revealObserver.observe(el);
  });

  // ============================================
  // Animated Counters
  // ============================================
  function animateCounter(element) {
    const target = parseInt(element.getAttribute('data-count'), 10);
    const duration = 2000; // 2 seconds
    const startTime = performance.now();
    const startValue = 0;

    function updateCounter(currentTime) {
      const elapsed = currentTime - startTime;
      const progress = Math.min(elapsed / duration, 1);
      
      // Easing function (ease-out)
      const easeOut = 1 - Math.pow(1 - progress, 3);
      const currentValue = Math.floor(startValue + (target - startValue) * easeOut);
      
      element.textContent = currentValue.toLocaleString('ar-SA');
      
      if (progress < 1) {
        requestAnimationFrame(updateCounter);
      } else {
        element.textContent = target.toLocaleString('ar-SA') + '+';
      }
    }

    requestAnimationFrame(updateCounter);
  }

  // Observe counter elements
  const counterObserver = new IntersectionObserver((entries) => {
    entries.forEach(entry => {
      if (entry.isIntersecting) {
        animateCounter(entry.target);
        counterObserver.unobserve(entry.target);
      }
    });
  }, { threshold: 0.5 });

  counterElements.forEach(el => {
    counterObserver.observe(el);
  });

  // ============================================
  // Tabs Functionality
  // ============================================
  function switchTab(e) {
    const targetTab = e.target.getAttribute('data-tab');
    
    // Update trigger buttons
    tabTriggers.forEach(trigger => {
      trigger.classList.remove('tabs__trigger--active');
    });
    e.target.classList.add('tabs__trigger--active');
    
    // Update content
    tabContents.forEach(content => {
      content.classList.remove('tabs__content--active');
    });
    document.getElementById(`${targetTab}-tab`).classList.add('tabs__content--active');
  }

  tabTriggers.forEach(trigger => {
    trigger.addEventListener('click', switchTab);
  });

  // ============================================
  // Screenshots Carousel
  // ============================================
  const screenshotsContainer = document.getElementById('screenshotsContainer');
  const dots = document.querySelectorAll('.screenshots-carousel__dot');
  
  if (screenshotsContainer && dots.length > 0) {
    let currentIndex = 0;
    
    function updateDots(index) {
      dots.forEach((dot, i) => {
        dot.classList.toggle('screenshots-carousel__dot--active', i === index);
      });
    }
    
    function scrollToSlide(index) {
      const slides = screenshotsContainer.querySelectorAll('.screenshot-item');
      if (slides[index]) {
        slides[index].scrollIntoView({ behavior: 'smooth', inline: 'center', block: 'nearest' });
        currentIndex = index;
        updateDots(index);
      }
    }
    
    dots.forEach((dot, index) => {
      dot.addEventListener('click', () => scrollToSlide(index));
    });
    
    // Auto-scroll
    setInterval(() => {
      const slides = screenshotsContainer.querySelectorAll('.screenshot-item');
      currentIndex = (currentIndex + 1) % slides.length;
      scrollToSlide(currentIndex);
    }, 5000);
    
    // Update dots on scroll
    screenshotsContainer.addEventListener('scroll', () => {
      const slides = screenshotsContainer.querySelectorAll('.screenshot-item');
      const containerWidth = screenshotsContainer.offsetWidth;
      const scrollLeft = screenshotsContainer.scrollLeft;
      
      slides.forEach((slide, index) => {
        const slideLeft = slide.offsetLeft;
        const slideCenter = slideLeft + slide.offsetWidth / 2;
        const containerCenter = scrollLeft + containerWidth / 2;
        
        if (Math.abs(slideCenter - containerCenter) < slide.offsetWidth / 2) {
          updateDots(index);
          currentIndex = index;
        }
      });
    }, { passive: true });
  }

  // ============================================
  // Active Section Highlight on Scroll
  // ============================================
  const sections = document.querySelectorAll('section[id]');
  
  function highlightActiveSection() {
    const scrollPosition = window.scrollY + header.offsetHeight + 100;
    
    sections.forEach(section => {
      const sectionTop = section.offsetTop;
      const sectionHeight = section.offsetHeight;
      const sectionId = section.getAttribute('id');
      
      if (scrollPosition >= sectionTop && scrollPosition < sectionTop + sectionHeight) {
        navLinks.forEach(link => {
          link.classList.remove('header__nav-link--active');
          if (link.getAttribute('href') === `#${sectionId}`) {
            link.classList.add('header__nav-link--active');
          }
        });
      }
    });
  }

  window.addEventListener('scroll', highlightActiveSection, { passive: true });

  // ============================================
  // Parallax Effect for Hero
  // ============================================
  const heroPattern = document.querySelector('.hero__pattern');
  
  if (heroPattern) {
    window.addEventListener('scroll', () => {
      const scrolled = window.scrollY;
      heroPattern.style.transform = `translateY(${scrolled * 0.3}px)`;
    }, { passive: true });
  }

  // ============================================
  // Form Validation (if forms exist)
  // ============================================
  const forms = document.querySelectorAll('form');
  
  forms.forEach(form => {
    form.addEventListener('submit', function(e) {
      const requiredFields = form.querySelectorAll('[required]');
      let isValid = true;
      
      requiredFields.forEach(field => {
        if (!field.value.trim()) {
          isValid = false;
          field.classList.add('form-input--error');
        } else {
          field.classList.remove('form-input--error');
        }
      });
      
      if (!isValid) {
        e.preventDefault();
      }
    });
  });

  // ============================================
  // Lazy Loading Images
  // ============================================
  const lazyImages = document.querySelectorAll('img[data-src]');
  
  if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const img = entry.target;
          img.src = img.dataset.src;
          img.removeAttribute('data-src');
          imageObserver.unobserve(img);
        }
      });
    });
    
    lazyImages.forEach(img => imageObserver.observe(img));
  } else {
    // Fallback for browsers without IntersectionObserver
    lazyImages.forEach(img => {
      img.src = img.dataset.src;
    });
  }

  // ============================================
  // Keyboard Navigation
  // ============================================
  document.addEventListener('keydown', function(e) {
    // Escape key closes mobile menu
    if (e.key === 'Escape' && mobileMenu.classList.contains('mobile-menu--open')) {
      mobileMenu.classList.remove('mobile-menu--open');
      menuBtn.innerHTML = '<i data-lucide="menu"></i>';
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    }
  });

  // ============================================
  // Performance: Prefetch Dashboard
  // ============================================
  const dashboardLink = document.querySelector('a[href="dashboard.html"]');
  if (dashboardLink) {
    const prefetchLink = document.createElement('link');
    prefetchLink.rel = 'prefetch';
    prefetchLink.href = 'dashboard.html';
    document.head.appendChild(prefetchLink);
  }

  // ============================================
  // Console Welcome Message
  // ============================================
  console.log('%cصوتك', 'font-size: 24px; font-weight: bold; color: #1A3A5A;');
  console.log('%cنظام إدارة البلاغات المجتمعية', 'font-size: 14px; color: #1ABC9C;');
  console.log('%c© 2024 صوتك. جميع الحقوق محفوظة.', 'font-size: 12px; color: #6c757d;');

});

// ============================================
// Utility Functions (Global)
// ============================================

/**
 * Debounce function
 * @param {Function} func - Function to debounce
 * @param {number} wait - Wait time in milliseconds
 * @returns {Function} - Debounced function
 */
function debounce(func, wait) {
  let timeout;
  return function executedFunction(...args) {
    const later = () => {
      clearTimeout(timeout);
      func(...args);
    };
    clearTimeout(timeout);
    timeout = setTimeout(later, wait);
  };
}

/**
 * Throttle function
 * @param {Function} func - Function to throttle
 * @param {number} limit - Limit time in milliseconds
 * @returns {Function} - Throttled function
 */
function throttle(func, limit) {
  let inThrottle;
  return function executedFunction(...args) {
    if (!inThrottle) {
      func(...args);
      inThrottle = true;
      setTimeout(() => inThrottle = false, limit);
    }
  };
}

/**
 * Format date to Arabic locale
 * @param {string|Date} date - Date to format
 * @returns {string} - Formatted date
 */
function formatDate(date) {
  const d = new Date(date);
  return d.toLocaleDateString('ar-SA', {
    year: 'numeric',
    month: 'long',
    day: 'numeric'
  });
}

/**
 * Format number to Arabic locale
 * @param {number} num - Number to format
 * @returns {string} - Formatted number
 */
function formatNumber(num) {
  return num.toLocaleString('ar-SA');
}
