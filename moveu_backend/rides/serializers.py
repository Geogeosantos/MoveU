from rest_framework import serializers
from .models import RideRequest
from users.serializers import UserSerializer

class RideRequestSerializer(serializers.ModelSerializer):
    passenger = UserSerializer(read_only=True)
    driver = UserSerializer(read_only=True)

    class Meta:
        model = RideRequest
        fields = ["id", "passenger", "driver", "day", "time", "status", "created_at"]

class RideRequestSerializer(serializers.ModelSerializer):
    driver = serializers.StringRelatedField()
    passenger = serializers.StringRelatedField()

    class Meta:
        model = RideRequest
        fields = "__all__"
