/**
 * Sawtak - API Module
 * Handles all fetch() API calls and data communication
 */

const API = (function() {
  'use strict';

  // Base URL for the API
  const BASE_URL = 'https://api.sawtak.gov.ye';
  
  // Mock data for development/demo purposes
  const mockData = {
    stats: {
      newReports: 24,
      inProgress: 18,
      resolved: 156,
      thisMonth: 89,
      changes: {
        newReports: '+12%',
        inProgress: '-5%',
        resolved: '+23%',
        thisMonth: '+8%'
      }
    },
    reports: [
      {
        id: 'R-2024-001',
        title: 'إنارة معطلة في شارع الملك فهد',
        category: 'إنارة',
        location: 'شارع الملك فهد، الرياض',
        status: 'new',
        priority: 'medium',
        date: '2024-01-15',
        reporter: 'أحمد محمد',
        phone: '0501234567',
        description: 'أعمدة إنارة معطلة في الجزء الشمالي من الشارع',
        image: 'https://via.placeholder.com/400x300/1A3A5A/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-002',
        title: 'حفرة في الطريق الرئيسي',
        category: 'طرق',
        location: 'طريق العليا، الرياض',
        status: 'acknowledged',
        priority: 'high',
        date: '2024-01-14',
        reporter: 'خالد عبدالله',
        phone: '0559876543',
        description: 'حفرة كبيرة تسبب خطراً على السائقين',
        image: 'https://via.placeholder.com/400x300/F39C12/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-003',
        title: 'تراكم نفايات في الحي',
        category: 'نظافة',
        location: 'حي النزهة، الرياض',
        status: 'in-progress',
        priority: 'medium',
        date: '2024-01-13',
        reporter: 'فاطمة علي',
        phone: '0561122334',
        description: 'تراكم النفايات لأكثر من أسبوع',
        image: 'https://via.placeholder.com/400x300/27AE60/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-004',
        title: 'إشارة مرور معطلة',
        category: 'مرور',
        location: 'تقاطع الملك فهد مع العليا',
        status: 'resolved',
        priority: 'high',
        date: '2024-01-12',
        reporter: 'محمد سعد',
        phone: '0575566778',
        description: 'إشارة المرور لا تعمل بشكل صحيح',
        image: 'https://via.placeholder.com/400x300/3498DB/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-005',
        title: 'تسرب مياه في الشارع',
        category: 'مياه',
        location: 'شارع الأمير سلطان، الرياض',
        status: 'closed',
        priority: 'high',
        date: '2024-01-10',
        reporter: 'نورة أحمد',
        phone: '0588899001',
        description: 'تسرب مياه كبير منذ ثلاثة أيام',
        image: 'https://via.placeholder.com/400x300/9B59B6/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-006',
        title: 'أرصفة مهترئة',
        category: 'أرصفة',
        location: 'شارع التحلية، الرياض',
        status: 'new',
        priority: 'low',
        date: '2024-01-15',
        reporter: 'سعد خالد',
        phone: '0592233445',
        description: 'أرصفة مهترئة تحتاج إلى صيانة',
        image: 'https://via.placeholder.com/400x300/1A3A5A/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-007',
        title: 'لافتات إعلانية مخالفة',
        category: 'إعلانات',
        location: 'حي الورود، الرياض',
        status: 'acknowledged',
        priority: 'low',
        date: '2024-01-14',
        reporter: 'ليلى محمد',
        phone: '0506677889',
        description: 'لافتات إعلانية بدون ترخيص',
        image: 'https://via.placeholder.com/400x300/F39C12/FFFFFF?text=Report+Image'
      },
      {
        id: 'R-2024-008',
        title: 'حديقة مهملة',
        category: 'حدائق',
        location: 'حديقة الملك عبدالله',
        status: 'in-progress',
        priority: 'medium',
        date: '2024-01-13',
        reporter: 'عبدالرحمن فهد',
        phone: '0554433221',
        description: 'الحديقة بحاجة إلى صيانة وتنظيف',
        image: 'https://via.placeholder.com/400x300/27AE60/FFFFFF?text=Report+Image'
      }
    ]
  };

  /**
   * Generic fetch wrapper with error handling
   * @param {string} endpoint - API endpoint
   * @param {Object} options - Fetch options
   * @returns {Promise} - Response data
   */
  async function fetchData(endpoint, options = {}) {
    // For demo purposes, return mock data
    // In production, uncomment the fetch code below
    
    /*
    const url = `${BASE_URL}${endpoint}`;
    const defaultOptions = {
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    };
    
    const response = await fetch(url, { ...defaultOptions, ...options });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    return await response.json();
    */
    
    // Return mock data for demo
    return new Promise((resolve) => {
      setTimeout(() => {
        resolve({ success: true, data: getMockDataForEndpoint(endpoint, options) });
      }, 300);
    });
  }

  /**
   * Get mock data based on endpoint
   */
  function getMockDataForEndpoint(endpoint, options) {
    if (endpoint === '/stats') {
      return mockData.stats;
    }
    if (endpoint.startsWith('/reports')) {
      const urlParams = new URLSearchParams(endpoint.split('?')[1]);
      const status = urlParams.get('status');
      
      if (status && status !== 'all') {
        return mockData.reports.filter(r => r.status === status);
      }
      return mockData.reports;
    }
    if (endpoint.startsWith('/report/')) {
      const id = endpoint.split('/')[2];
      return mockData.reports.find(r => r.id === id);
    }
    return null;
  }

  // Public API methods
  return {
    /**
     * Get dashboard statistics
     * @returns {Promise<Object>} - Stats data
     */
    async getStats() {
      const response = await fetchData('/stats');
      return response.data;
    },

    /**
     * Get reports list with optional filters
     * @param {Object} filters - Filter options (status, category, etc.)
     * @returns {Promise<Array>} - Reports array
     */
    async getReports(filters = {}) {
      const queryString = new URLSearchParams(filters).toString();
      const endpoint = `/reports${queryString ? '?' + queryString : ''}`;
      const response = await fetchData(endpoint);
      return response.data;
    },

    /**
     * Get a single report by ID
     * @param {string} reportId - Report ID
     * @returns {Promise<Object>} - Report data
     */
    async getReportById(reportId) {
      const response = await fetchData(`/report/${reportId}`);
      return response.data;
    },

    /**
     * Update a report
     * @param {string} reportId - Report ID
     * @param {Object} updates - Fields to update
     * @returns {Promise<Object>} - Updated report
     */
    async updateReport(reportId, updates) {
      // Mock update - in production, this would be a PUT/PATCH request
      return new Promise((resolve) => {
        setTimeout(() => {
          const report = mockData.reports.find(r => r.id === reportId);
          if (report) {
            Object.assign(report, updates);
          }
          resolve({ success: true, data: report });
        }, 200);
      });
    },

    /**
     * Acknowledge a report
     * @param {string} reportId - Report ID
     * @returns {Promise<Object>} - Updated report
     */
    async acknowledgeReport(reportId) {
      return this.updateReport(reportId, { status: 'acknowledged' });
    },

    /**
     * Assign report to team
     * @param {string} reportId - Report ID
     * @param {string} teamId - Team ID
     * @returns {Promise<Object>} - Updated report
     */
    async assignReport(reportId, teamId) {
      return this.updateReport(reportId, { 
        status: 'in-progress',
        assignedTeam: teamId 
      });
    },

    /**
     * Mark report as resolved
     * @param {string} reportId - Report ID
     * @returns {Promise<Object>} - Updated report
     */
    async resolveReport(reportId) {
      return this.updateReport(reportId, { status: 'resolved' });
    },

    /**
     * Close a report
     * @param {string} reportId - Report ID
     * @returns {Promise<Object>} - Updated report
     */
    async closeReport(reportId) {
      return this.updateReport(reportId, { status: 'closed' });
    }
  };
})();

// Export for use in other modules
if (typeof module !== 'undefined' && module.exports) {
  module.exports = API;
}
