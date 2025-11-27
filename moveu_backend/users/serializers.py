from rest_framework import serializers
from .models import User, DriverProfile, UserSchedule, City, Neighborhood, University
from django.conf import settings
import requests

class UserSerializer(serializers.ModelSerializer):
    city = serializers.StringRelatedField()
    neighborhood = serializers.StringRelatedField()

    class Meta:
        model = User
        fields = [
            "id", "username", "email", "phone_number", 
            "is_driver", "city", "neighborhood", "university", "gender", "photo", "schedules"]


class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "id", "username", "email", "phone_number",
            "password", "city", "neighborhood", "university", 
            "gender",  "photo"
        ]
    

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
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
    

