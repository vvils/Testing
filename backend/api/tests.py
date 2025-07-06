from django.test import TestCase
from django.urls import reverse
from rest_framework.test import APITestCase
from rest_framework import status


class ApiTestCase(APITestCase):
    """Test cases for the API endpoints."""
    
    def test_test_endpoint(self):
        """Test the /api/test/ endpoint."""
        url = reverse('test_endpoint')
        response = self.client.get(url)
        
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['message'], "Hello from the back end")