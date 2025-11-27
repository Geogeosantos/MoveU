from rest_framework import serializers
from .models import RideRequest
from users.models import User, University, Neighborhood
from users.serializers import UserScheduleSerializer

DAYS_DICT = {
    "mon": "Segunda-feira",
    "tue": "Terça-feira",
    "wed": "Quarta-feira",
    "thu": "Quinta-feira",
    "fri": "Sexta-feira",
}

class PassengerDetailSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    neighborhood_name = serializers.CharField(source='neighborhood.name', read_only=True)
    schedules = serializers.SerializerMethodField()


    class Meta:
        model = User
        fields = [
            "id",
            "username",
            "email",
            "photo",
            "university_name",
            "neighborhood_name",
            "gender",
            "phone_number",
            "schedules",
        ]
        
    def get_schedules(self, obj):
        schedules = obj.schedules.all().order_by("day")
        return [
            {
                "day": DAYS_DICT.get(s.day, s.day),
                "start_time": s.start_time.strftime("%H:%M"),
                "end_time": s.end_time.strftime("%H:%M"),
            }
            for s in schedules
        ]
        
class DriverDetailSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    neighborhood_name = serializers.CharField(source='neighborhood.name', read_only=True)

    class Meta:
        model = User
        fields = ['id', 'username', 'photo', 'university_name', 'neighborhood_name']

        
    

class RideRequestSerializer(serializers.ModelSerializer):
    passenger = PassengerDetailSerializer(read_only=True)
    driver = DriverDetailSerializer(read_only=True)

    class Meta:
        model = RideRequest
        fields = [
            "id",
            "passenger",
            "driver",
            "university",
            "neighborhood",
            "day",
            "start_time",
            "end_time",
            "status",
            "created_at",
            "reason_rejected",
        ]
        read_only_fields = ["status"]


class AvailableDriverSerializer(serializers.ModelSerializer):
    university_name = serializers.CharField(source='university.name', read_only=True)
    neighborhood_name = serializers.CharField(source='neighborhood.name', read_only=True)
    
    class Meta:
        model = User
        fields = [
            'id',
            'username',
            'university_name',
            'neighborhood_name',
            'photo',
        ]

    def get_schedules(self, obj):
        return [s.start_time.strftime("%H:%M") + " - " + s.end_time.strftime("%H:%M") 
                for s in obj.schedules.all()]
        
        
