from rest_framework import serializers
from .models import User, DriverProfile, UserSchedule

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ["id", "username", "email", "phone_number", "is_driver"]

class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = ["id", "username", "email", "phone_number", "password"]

    def create(self, validated_data):
        user = User(
            username=validated_data["username"],
            email=validated_data["email"],
            phone_number=validated_data.get("phone_number", "")
        )
        user.set_password(validated_data["password"])
        user.save()
        return user

# Serializer para dados do motorista
class DriverProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = DriverProfile
        fields = "__all__"
        read_only_fields = ["user"]
        

class UserScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSchedule
        fields = ["id", "day", "start_time", "end_time"]

