from rest_framework import generics, permissions
from users.models import User
from django.db import models
from rides.models import RideRequest
from rides.serializers import RideRequestSerializer, UserSerializer
from django.utils.dateparse import parse_time


class AvailableDriversView(generics.ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        day = self.request.query_params.get("day")
        time = self.request.query_params.get("time")
        city_id = self.request.query_params.get("city_id")
        neighborhood_id = self.request.query_params.get("neighborhood_id")
        university_id = self.request.query_params.get("university_id")

        if not all([day, time, city_id, neighborhood_id, university_id]):
            return User.objects.none()

        time_obj = parse_time(time)

        drivers = User.objects.filter(
            is_driver=True,
            city_id=city_id,
            neighborhood_id=neighborhood_id,
            university_id=university_id
        ).filter(
            schedules__day=day,
            schedules__start_time__lte=time_obj,
            schedules__end_time__gte=time_obj
        ).distinct()

        return drivers


class RideRequestCreateView(generics.CreateAPIView):
    serializer_class = RideRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def perform_create(self, serializer):
        if self.request.user.is_driver:
            raise serializers.ValidationError("Motoristas não podem criar ride requests como passageiros.")
        serializer.save(passenger=self.request.user)


class RideRequestReceivedView(generics.ListAPIView):
    serializer_class = RideRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if not user.is_driver:
            return RideRequest.objects.none()

        return RideRequest.objects.filter(
            driver__isnull=True,
            passenger__city=user.city,
            passenger__neighborhood=user.neighborhood
        )


class RideHistoryView(generics.ListAPIView):
    serializer_class = RideRequestSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        return RideRequest.objects.filter(
            models.Q(driver=user) | models.Q(passenger=user),
            status="completed"
        ).order_by("-created_at")
