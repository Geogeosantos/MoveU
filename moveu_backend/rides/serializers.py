from rest_framework import serializers
from .models import RideRequest
from users.serializers import UserSerializer
from users.models import User

class RideRequestSerializer(serializers.ModelSerializer):
    passenger = UserSerializer(read_only=True)
    driver = serializers.PrimaryKeyRelatedField(queryset=User.objects.filter(is_driver=True))

    class Meta:
        model = RideRequest
        fields = "__all__"
        read_only_fields = ["status"]