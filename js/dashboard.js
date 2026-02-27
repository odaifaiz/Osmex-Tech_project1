/**
 * Sawtak - Dashboard JavaScript Module
 * Handles dashboard SPA functionality
 */

// Dashboard namespace
const Dashboard = (function() {
  'use strict';

  // ============================================
  // DOM Elements
  // ============================================
  let sidebar;
  let sidebarToggle;
  let mainContent;
  let kpiContainer;
  let tableContainer;
  let statusFilter;
  let searchInput;
  let mobileMenuToggle;

  // State
  let currentFilters = {
    status: 'all',
    search: ''
  };
  let currentReports = [];

  // ============================================
  // Initialization
  // ============================================
  function init() {
    // Cache DOM elements
    sidebar = document.querySelector('.dashboard__sidebar');
    sidebarToggle = document.querySelector('.dashboard__sidebar-toggle');
    mainContent = document.querySelector('.dashboard__main');
    kpiContainer = document.getElementById('kpi-container');
    tableContainer = document.getElementById('data-table-container');
    statusFilter = document.getElementById('status-filter');
    searchInput = document.getElementById('search-input');
    mobileMenuToggle = document.querySelector('.dashboard__sidebar-toggle--mobile');

    // Initialize dashboard
    initDashboard();
    
    // Setup event listeners
    setupEventListeners();
    
    // Initialize Lucide icons
    if (typeof lucide !== 'undefined') {
      lucide.createIcons();
    }
  }

  // ============================================
  // Initialize Dashboard
  // ============================================
  async function initDashboard() {
    try {
      // Show loading states
      UI.showLoading(kpiContainer);
      UI.showLoading(tableContainer);

      // Fetch initial data
      const [stats, reports] = await Promise.all([
        API.getStats(),
        API.getReports(currentFilters)
      ]);

      // Store reports
      currentReports = reports;

      // Render components
      UI.renderKpiCards(stats, kpiContainer);
      UI.renderDataTable(reports, tableContainer);

    } catch (error) {
      console.error('Error initializing dashboard:', error);
      UI.showError(kpiContainer, 'فشل تحميل البيانات. يرجى المحاولة مرة أخرى.');
      UI.showError(tableContainer, 'فشل تحميل البيانات. يرجى المحاولة مرة أخرى.');
    }
  }

  // ============================================
  // Setup Event Listeners
  // ============================================
  function setupEventListeners() {
    // Sidebar toggle (desktop)
    if (sidebarToggle) {
      sidebarToggle.addEventListener('click', toggleSidebar);
    }

    // Mobile menu toggle
    if (mobileMenuToggle) {
      mobileMenuToggle.addEventListener('click', toggleMobileSidebar);
    }

    // Status filter
    if (statusFilter) {
      statusFilter.addEventListener('change', handleStatusFilter);
    }

    // Search input
    if (searchInput) {
      searchInput.addEventListener('input', debounce(handleSearch, 300));
    }

    // Table row click (event delegation)
    if (tableContainer) {
      tableContainer.addEventListener('click', handleTableClick);
    }

    // Keyboard shortcuts
    document.addEventListener('keydown', handleKeyboard);
  }

  // ============================================
  // Sidebar Functions
  // ============================================
  function toggleSidebar() {
    sidebar.classList.toggle('dashboard__sidebar--collapsed');
    
    // Update toggle icon
    const isCollapsed = sidebar.classList.contains('dashboard__sidebar--collapsed');
    const icon = sidebarToggle.querySelector('[data-lucide]');
    if (icon) {
      icon.setAttribute('data-lucide', isCollapsed ? 'chevron-left' : 'chevron-right');
      lucide.createIcons();
    }
  }

  function toggleMobileSidebar() {
    sidebar.classList.toggle('dashboard__sidebar--open');
    
    // Add overlay
    let overlay = document.querySelector('.dashboard__sidebar-overlay');
    
    if (sidebar.classList.contains('dashboard__sidebar--open')) {
      if (!overlay) {
        overlay = document.createElement('div');
        overlay.className = 'dashboard__sidebar-overlay';
        overlay.style.cssText = `
          position: fixed;
          inset: 0;
          background: rgba(0,0,0,0.5);
          z-index: 199;
        `;
        overlay.addEventListener('click', toggleMobileSidebar);
        document.body.appendChild(overlay);
      }
    } else if (overlay) {
      overlay.remove();
    }
  }

  // ============================================
  // Filter Functions
  // ============================================
  async function handleStatusFilter(e) {
    currentFilters.status = e.target.value;
    await refreshTable();
  }

  async function handleSearch(e) {
    currentFilters.search = e.target.value;
    await refreshTable();
  }

  async function refreshTable() {
    try {
      UI.showLoading(tableContainer);
      const reports = await API.getReports(currentFilters);
      currentReports = reports;
      UI.renderDataTable(reports, tableContainer);
      
      // Re-initialize icons
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    } catch (error) {
      console.error('Error refreshing table:', error);
      UI.showError(tableContainer, 'فشل تحديث البيانات');
    }
  }

  // ============================================
  // Table Click Handler (Event Delegation)
  // ============================================
  function handleTableClick(e) {
    // Find the closest row
    const row = e.target.closest('tr[data-report-id]');
    
    if (row) {
      const reportId = row.getAttribute('data-report-id');
      openReportDetails(reportId);
    }
  }

  // ============================================
  // Report Details
  // ============================================
  async function openReportDetails(reportId) {
    try {
      const report = await API.getReportById(reportId);
      
      if (report) {
        UI.showReportDetailsPanel(report);
      } else {
        UI.showToast('البلاغ غير موجود', 'error');
      }
    } catch (error) {
      console.error('Error fetching report details:', error);
      UI.showToast('فشل تحميل تفاصيل البلاغ', 'error');
    }
  }

  // ============================================
  // Report Actions
  // ============================================
  async function acknowledgeReport(reportId) {
    try {
      await API.acknowledgeReport(reportId);
      UI.closeReportDetailsPanel();
      UI.showToast('تم استلام البلاغ بنجاح', 'success');
      await refreshTable();
      await refreshStats();
    } catch (error) {
      console.error('Error acknowledging report:', error);
      UI.showToast('فشل استلام البلاغ', 'error');
    }
  }

  async function assignReport(reportId) {
    // For demo, assign to team "Team A"
    try {
      await API.assignReport(reportId, 'team-a');
      UI.closeReportDetailsPanel();
      UI.showToast('تم إسناد البلاغ للفريق بنجاح', 'success');
      await refreshTable();
      await refreshStats();
    } catch (error) {
      console.error('Error assigning report:', error);
      UI.showToast('فشل إسناد البلاغ', 'error');
    }
  }

  async function resolveReport(reportId) {
    try {
      await API.resolveReport(reportId);
      UI.closeReportDetailsPanel();
      UI.showToast('تم تحديد البلاغ كمحلول', 'success');
      await refreshTable();
      await refreshStats();
    } catch (error) {
      console.error('Error resolving report:', error);
      UI.showToast('فشل تحديث حالة البلاغ', 'error');
    }
  }

  async function closeReport(reportId) {
    try {
      await API.closeReport(reportId);
      UI.closeReportDetailsPanel();
      UI.showToast('تم إغلاق البلاغ بنجاح', 'success');
      await refreshTable();
      await refreshStats();
    } catch (error) {
      console.error('Error closing report:', error);
      UI.showToast('فشل إغلاق البلاغ', 'error');
    }
  }

  // ============================================
  // Refresh Stats
  // ============================================
  async function refreshStats() {
    try {
      const stats = await API.getStats();
      UI.renderKpiCards(stats, kpiContainer);
      
      if (typeof lucide !== 'undefined') {
        lucide.createIcons();
      }
    } catch (error) {
      console.error('Error refreshing stats:', error);
    }
  }

  // ============================================
  // Keyboard Shortcuts
  // ============================================
  function handleKeyboard(e) {
    // Escape closes slide panel
    if (e.key === 'Escape') {
      UI.closeReportDetailsPanel();
    }
    
    // Ctrl/Cmd + K focuses search
    if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
      e.preventDefault();
      if (searchInput) {
        searchInput.focus();
      }
    }
    
    // R refreshes table
    if (e.key === 'r' && !e.ctrlKey && !e.metaKey) {
      const activeElement = document.activeElement;
      if (activeElement.tagName !== 'INPUT' && activeElement.tagName !== 'TEXTAREA') {
        refreshTable();
      }
    }
  }

  // ============================================
  // Debounce Utility
  // ============================================
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

  // ============================================
  // Public API
  // ============================================
  return {
    init,
    acknowledgeReport,
    assignReport,
    resolveReport,
    closeReport
  };
})();

// Initialize dashboard on DOM ready
document.addEventListener('DOMContentLoaded', Dashboard.init);
