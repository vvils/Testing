from rest_framework.decorators import api_view
from rest_framework.response import Response
from rest_framework import status


@api_view(['GET'])
def test_endpoint(request):
    """
    Simple test endpoint that returns a greeting message.
    """
    return Response(
        {"message": "Hello from the back end"}, 
        status=status.HTTP_200_OK
    )