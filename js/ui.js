/**
 * Sawtak - UI Module
 * DOM manipulation and component rendering functions
 */

const UI = (function() {
  'use strict';

  // Status configuration
  const STATUS_CONFIG = {
    'new': { label: 'جديد', class: 'pill--new', icon: 'circle' },
    'acknowledged': { label: 'تم الاستلام', class: 'pill--acknowledged', icon: 'check' },
    'in-progress': { label: 'قيد المعالجة', class: 'pill--in-progress', icon: 'loader' },
    'resolved': { label: 'تم الحل', class: 'pill--resolved', icon: 'check-circle' },
    'closed': { label: 'مغلق', class: 'pill--closed', icon: 'x-circle' }
  };

  /**
   * Create a status pill element
   * @param {string} status - Report status
   * @returns {string} - HTML string
   */
  function createStatusPill(status) {
    const config = STATUS_CONFIG[status] || STATUS_CONFIG['new'];
    return `<span class="pill ${config.class}">${config.label}</span>`;
  }

  /**
   * Create a KPI card element
   * @param {Object} kpi - KPI data
   * @returns {HTMLElement} - Card element
   */
  function createKpiCard(kpi) {
    const card = document.createElement('div');
    card.className = 'kpi-card';
    
    const changeClass = kpi.change.startsWith('+') ? 'kpi-card__change--positive' : 'kpi-card__change--negative';
    const changeIcon = kpi.change.startsWith('+') ? 'trending-up' : 'trending-down';
    
    card.innerHTML = `
      <div class="kpi-card__header">
        <span class="kpi-card__title">${kpi.title}</span>
        <div class="kpi-card__icon kpi-card__icon--${kpi.color}">
          <i data-lucide="${kpi.icon}"></i>
        </div>
      </div>
      <div class="kpi-card__value">${kpi.value.toLocaleString('ar-SA')}</div>
      <div class="kpi-card__change ${changeClass}">
        <i data-lucide="${changeIcon}" style="width: 14px; height: 14px;"></i>
        <span>${kpi.change} من الشهر الماضي</span>
      </div>
    `;
    
    return card;
  }

  /**
   * Render KPI cards grid
   * @param {Object} stats - Stats data from API
   * @param {HTMLElement} container - Container element
   */
  function renderKpiCards(stats, container) {
    const kpis = [
      { title: 'البلاغات الجديدة', value: stats.newReports, change: stats.changes.newReports, icon: 'inbox', color: 'blue' },
      { title: 'قيد المعالجة', value: stats.inProgress, change: stats.changes.inProgress, icon: 'clock', color: 'yellow' },
      { title: 'تم الحل', value: stats.resolved, change: stats.changes.resolved, icon: 'check-circle', color: 'green' },
      { title: 'هذا الشهر', value: stats.thisMonth, change: stats.changes.thisMonth, icon: 'calendar', color: 'purple' }
    ];

    container.innerHTML = '';
    kpis.forEach(kpi => {
      container.appendChild(createKpiCard(kpi));
    });
    
    // Initialize icons
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  /**
   * Create a table row for a report
   * @param {Object} report - Report data
   * @returns {string} - HTML string
   */
  function createReportRow(report) {
    const date = new Date(report.date).toLocaleDateString('ar-SA');
    return `
      <tr data-report-id="${report.id}">
        <td><strong>${report.id}</strong></td>
        <td>${report.title}</td>
        <td>${report.category}</td>
        <td>${report.location}</td>
        <td>${createStatusPill(report.status)}</td>
        <td>${date}</td>
        <td>${report.reporter}</td>
      </tr>
    `;
  }

  /**
   * Render data table
   * @param {Array} reports - Reports array
   * @param {HTMLElement} container - Container element
   */
  function renderDataTable(reports, container) {
    const table = document.createElement('div');
    table.className = 'table-container';
    
    const rowsHtml = reports.map(createReportRow).join('');
    
    table.innerHTML = `
      <table class="data-table">
        <thead>
          <tr>
            <th>رقم البلاغ</th>
            <th>العنوان</th>
            <th>التصنيف</th>
            <th>الموقع</th>
            <th>الحالة</th>
            <th>التاريخ</th>
            <th>المرسل</th>
          </tr>
        </thead>
        <tbody>
          ${rowsHtml}
        </tbody>
      </table>
    `;
    
    container.innerHTML = '';
    container.appendChild(table);
  }

  /**
   * Show loading state in container
   * @param {HTMLElement} container - Container element
   */
  function showLoading(container) {
    container.innerHTML = `
      <div style="display: flex; justify-content: center; align-items: center; padding: 3rem;">
        <div style="width: 40px; height: 40px; border: 3px solid #e9ecef; border-top-color: #1A3A5A; border-radius: 50%; animation: spin 1s linear infinite;"></div>
      </div>
      <style>
        @keyframes spin { to { transform: rotate(360deg); } }
      </style>
    `;
  }

  /**
   * Show error message
   * @param {HTMLElement} container - Container element
   * @param {string} message - Error message
   */
  function showError(container, message) {
    container.innerHTML = `
      <div style="text-align: center; padding: 3rem; color: #e74c3c;">
        <i data-lucide="alert-circle" style="width: 48px; height: 48px; margin-bottom: 1rem;"></i>
        <p>${message}</p>
      </div>
    `;
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  /**
   * Show empty state
   * @param {HTMLElement} container - Container element
   * @param {string} message - Empty message
   */
  function showEmpty(container, message = 'لا توجد بيانات') {
    container.innerHTML = `
      <div style="text-align: center; padding: 3rem; color: #6c757d;">
        <i data-lucide="inbox" style="width: 48px; height: 48px; margin-bottom: 1rem;"></i>
        <p>${message}</p>
      </div>
    `;
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  /**
   * Create and show report details panel
   * @param {Object} report - Report data
   */
  function showReportDetailsPanel(report) {
    // Remove existing panel if any
    const existingPanel = document.querySelector('.slide-panel');
    const existingOverlay = document.querySelector('.slide-panel__overlay');
    if (existingPanel) existingPanel.remove();
    if (existingOverlay) existingOverlay.remove();

    // Create overlay
    const overlay = document.createElement('div');
    overlay.className = 'slide-panel__overlay';
    document.body.appendChild(overlay);

    // Create panel
    const panel = document.createElement('div');
    panel.className = 'slide-panel';
    
    const statusConfig = STATUS_CONFIG[report.status] || STATUS_CONFIG['new'];
    
    panel.innerHTML = `
      <div class="slide-panel__header">
        <h3 class="slide-panel__title">تفاصيل البلاغ ${report.id}</h3>
        <button class="slide-panel__close" onclick="UI.closeReportDetailsPanel()">
          <i data-lucide="x"></i>
        </button>
      </div>
      <div class="slide-panel__content">
        ${report.image ? `<img src="${report.image}" alt="صورة البلاغ" class="report-detail__image">` : ''}
        
        <div class="slide-panel__section">
          <h4 class="slide-panel__section-title">معلومات البلاغ</h4>
          <div class="report-detail__info">
            <div class="report-detail__row">
              <span class="report-detail__label">العنوان</span>
              <span class="report-detail__value">${report.title}</span>
            </div>
            <div class="report-detail__row">
              <span class="report-detail__label">التصنيف</span>
              <span class="report-detail__value">${report.category}</span>
            </div>
            <div class="report-detail__row">
              <span class="report-detail__label">الحالة</span>
              <span class="report-detail__value">${createStatusPill(report.status)}</span>
            </div>
            <div class="report-detail__row">
              <span class="report-detail__label">الأولوية</span>
              <span class="report-detail__value">${report.priority === 'high' ? 'عالية' : report.priority === 'medium' ? 'متوسطة' : 'منخفضة'}</span>
            </div>
            <div class="report-detail__row">
              <span class="report-detail__label">التاريخ</span>
              <span class="report-detail__value">${new Date(report.date).toLocaleDateString('ar-SA')}</span>
            </div>
          </div>
        </div>
        
        <div class="slide-panel__section">
          <h4 class="slide-panel__section-title">الموقع</h4>
          <div class="report-detail__row">
            <span class="report-detail__value">${report.location}</span>
          </div>
        </div>
        
        <div class="slide-panel__section">
          <h4 class="slide-panel__section-title">الوصف</h4>
          <p style="color: #495057; line-height: 1.6;">${report.description}</p>
        </div>
        
        <div class="slide-panel__section">
          <h4 class="slide-panel__section-title">معلومات المرسل</h4>
          <div class="report-detail__info">
            <div class="report-detail__row">
              <span class="report-detail__label">الاسم</span>
              <span class="report-detail__value">${report.reporter}</span>
            </div>
            <div class="report-detail__row">
              <span class="report-detail__label">رقم الهاتف</span>
              <span class="report-detail__value">${report.phone}</span>
            </div>
          </div>
        </div>
      </div>
      
      <div class="report-detail__actions">
        ${getActionButtons(report.status, report.id)}
      </div>
    `;
    
    document.body.appendChild(panel);
    
    // Trigger animation
    requestAnimationFrame(() => {
      overlay.classList.add('slide-panel__overlay--visible');
      panel.classList.add('slide-panel--open');
    });
    
    // Close on overlay click
    overlay.addEventListener('click', closeReportDetailsPanel);
    
    // Initialize icons
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  /**
   * Get action buttons based on status
   */
  function getActionButtons(status, reportId) {
    const buttons = [];
    
    switch (status) {
      case 'new':
        buttons.push(`<button class="report-detail__btn report-detail__btn--primary" onclick="Dashboard.acknowledgeReport('${reportId}')">استلام البلاغ</button>`);
        break;
      case 'acknowledged':
        buttons.push(`<button class="report-detail__btn report-detail__btn--primary" onclick="Dashboard.assignReport('${reportId}')">إسناد للفريق</button>`);
        break;
      case 'in-progress':
        buttons.push(`<button class="report-detail__btn report-detail__btn--primary" onclick="Dashboard.resolveReport('${reportId}')">تحديد كمحلول</button>`);
        break;
      case 'resolved':
        buttons.push(`<button class="report-detail__btn report-detail__btn--primary" onclick="Dashboard.closeReport('${reportId}')">إغلاق البلاغ</button>`);
        break;
    }
    
    buttons.push(`<button class="report-detail__btn report-detail__btn--secondary" onclick="UI.closeReportDetailsPanel()">إغلاق</button>`);
    
    return buttons.join('');
  }

  /**
   * Close report details panel
   */
  function closeReportDetailsPanel() {
    const panel = document.querySelector('.slide-panel');
    const overlay = document.querySelector('.slide-panel__overlay');
    
    if (panel) {
      panel.classList.remove('slide-panel--open');
    }
    if (overlay) {
      overlay.classList.remove('slide-panel__overlay--visible');
    }
    
    setTimeout(() => {
      if (panel) panel.remove();
      if (overlay) overlay.remove();
    }, 300);
  }

  /**
   * Show toast notification
   * @param {string} message - Toast message
   * @param {string} type - Toast type (success, error, warning, info)
   */
  function showToast(message, type = 'info') {
    const toast = document.createElement('div');
    toast.style.cssText = `
      position: fixed;
      top: 20px;
      left: 50%;
      transform: translateX(-50%) translateY(-100px);
      padding: 1rem 2rem;
      border-radius: 8px;
      color: white;
      font-weight: 500;
      z-index: 1000;
      transition: transform 0.3s ease;
      box-shadow: 0 4px 12px rgba(0,0,0,0.15);
    `;
    
    const colors = {
      success: '#27ae60',
      error: '#e74c3c',
      warning: '#f39c12',
      info: '#3498db'
    };
    
    toast.style.backgroundColor = colors[type] || colors.info;
    toast.textContent = message;
    
    document.body.appendChild(toast);
    
    requestAnimationFrame(() => {
      toast.style.transform = 'translateX(-50%) translateY(0)';
    });
    
    setTimeout(() => {
      toast.style.transform = 'translateX(-50%) translateY(-100px)';
      setTimeout(() => toast.remove(), 300);
    }, 3000);
  }

  // Public API
  return {
    createStatusPill,
    createKpiCard,
    renderKpiCards,
    createReportRow,
    renderDataTable,
    showLoading,
    showError,
    showEmpty,
    showReportDetailsPanel,
    closeReportDetailsPanel,
    showToast
  };
})();

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = UI;
}
