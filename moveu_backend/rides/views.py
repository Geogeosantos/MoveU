from rest_framework import generics, permissions, status, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.utils.dateparse import parse_time
from django.db import models

from users.models import User
from rides.models import RideRequest
from rides.serializers import RideRequestSerializer, UserSerializer


class AvailableDriversView(generics.ListAPIView):
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user

        if user.is_driver:
            return User.objects.none()

        # Passageiro precisa informar dia e horário desejados
        day = self.request.query_params.get("day")
        time = self.request.query_params.get("time")

        if not day or not time:
            return User.objects.none()

        time_obj = parse_time(time)

        # Filtra motoristas compatíveis com a rota e horário
        return User.objects.filter(
            is_driver=True,
            university=user.university,
            neighborhood=user.neighborhood,
            schedules__day=day,
            schedules__start_time__lte=time_obj,
            schedules__end_time__gte=time_obj
        ).distinct()


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
            driver=user,
            status="pending"
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


class RideRequestUpdateStatusView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request, ride_id):
        user = request.user
        ride = get_object_or_404(RideRequest, id=ride_id)

        if not user.is_driver:
            return Response({"error": "Somente motoristas podem responder solicitações."},
                            status=status.HTTP_403_FORBIDDEN)

        status_update = request.data.get("status")
        
        if status_update == "rejected":
            ride.reason_rejected = request.data.get("reason", "Sem justificativa do motorista.")

        if status_update not in ["accepted", "rejected"]:
            return Response({"error": "Status inválido."}, status=status.HTTP_400_BAD_REQUEST)

        ride.status = status_update
        ride.driver = user 
        ride.save()

        return Response({"status": f"Solicitação {status_update}."})
