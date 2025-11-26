from rest_framework import serializers
from .models import User, DriverProfile, UserSchedule, City, Neighborhood, University
from django.conf import settings
import requests

class UserSerializer(serializers.ModelSerializer):
    city = serializers.StringRelatedField()
    neighborhood = serializers.StringRelatedField()

    class Meta:
        model = User
        fields = ["id", "username", "email", "phone_number", "is_driver", "city", "neighborhood"]


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "id", "username", "email", "phone_number",
            "password", "city", "neighborhood"
        ]

    def create(self, validated_data):
        user = User(
            username=validated_data["username"],
            email=validated_data["email"],
            phone_number=validated_data.get("phone_number", ""),
            city=validated_data.get("city"),
            neighborhood=validated_data.get("neighborhood"),
        )
        user.set_password(validated_data["password"])
        user.save()
        return user

class DriverProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = DriverProfile
        fields = "__all__"
        read_only_fields = ["user"]
        

class UserScheduleSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserSchedule
        fields = ["id", "day", "start_time", "end_time"]
        
class CitySerializer(serializers.ModelSerializer):
    class Meta:
        model = City
        fields = ["id", "name"]


class NeighborhoodSerializer(serializers.ModelSerializer):
    city = CitySerializer(read_only=True)

    class Meta:
        model = Neighborhood
        fields = ["id", "name", "city"]
        

class UniversitySerializer(serializers.ModelSerializer):
    city = CitySerializer(read_only=True)

    class Meta:
        model = University
        fields = ["id", "name", "city"]
    

