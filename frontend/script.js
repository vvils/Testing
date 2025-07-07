// Immediate console log to verify script loading
console.log('🚀 Script loaded! Timestamp:', new Date().toISOString());

// API configuration - using relative URLs (same origin)
const API_BASE_URL = '';

// Function to fetch message from backend API
async function fetchApiMessage() {
  const apiUrl = `${API_BASE_URL}/api/test/`;
  console.log('🔌 Attempting to fetch from:', apiUrl);
  
  try {
    document.getElementById('apiMessage').textContent = 'Connecting to backend...';
    
    const response = await fetch(apiUrl);
    console.log('📡 Response received:', response.status, response.statusText);
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status} ${response.statusText}`);
    }
    
    const data = await response.json();
    console.log('📦 Data received:', data);
    
    document.getElementById('apiMessage').textContent = data.message;
    console.log('✅ API call successful!');
    
  } catch (error) {
    console.error('❌ Error fetching API message:', error);
    console.error('❌ Error details:', {
      name: error.name,
      message: error.message,
      stack: error.stack
    });
    document.getElementById('apiMessage').textContent = `Error: ${error.message}`;
  }
}

// Auto-load API message when page loads
console.log('📝 Setting up DOMContentLoaded listener...');

document.addEventListener('DOMContentLoaded', function() {
  console.log('🌐 DOM loaded! Document ready state:', document.readyState);
  console.log('🎯 Looking for apiMessage element:', document.getElementById('apiMessage'));
  fetchApiMessage();
});

// Fallback in case DOM is already loaded
if (document.readyState === 'loading') {
  console.log('⏳ Document still loading, waiting for DOMContentLoaded...');
} else {
  console.log('⚡ DOM already loaded, calling fetchApiMessage immediately...');
  fetchApiMessage();
}

// Original button functionality
document.getElementById("myButton").addEventListener("click", function () {
  alert("You clicked the button!");
});
