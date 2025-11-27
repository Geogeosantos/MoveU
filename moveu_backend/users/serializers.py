from rest_framework import serializers
from .models import User, DriverProfile, UserSchedule, City, Neighborhood, University
from django.conf import settings
import requests


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

class DriverProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = DriverProfile
        fields = "__all__"
        read_only_fields = ["user"]
        
class UserSerializer(serializers.ModelSerializer):
    city = CitySerializer(read_only=True)
    neighborhood = NeighborhoodSerializer(read_only=True)
    university = UniversitySerializer(read_only=True)
    schedules = UserScheduleSerializer(many=True, read_only=True)
    driver = DriverProfileSerializer(source="driver_profile", read_only=True)

    class Meta:
        model = User
        fields = [
            "id", "username", "email", "phone_number", 
            "is_driver", "city", "neighborhood", "university",
            "gender", "photo", "age", "schedules", "driver"
        ]



class RegisterSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)

    class Meta:
        model = User
        fields = [
            "id", "username", "email", "phone_number",
            "password", "city", "neighborhood", "university", 
            "gender", "age", "photo"
        ]
    

    def create(self, validated_data):
        password = validated_data.pop("password")
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user

        

    

