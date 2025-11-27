from rest_framework import generics, permissions, status, serializers
from rest_framework.views import APIView
from rest_framework.response import Response
from django.shortcuts import get_object_or_404
from django.utils.dateparse import parse_time
from django.db import models

from users.models import User
from rides.models import RideRequest
from rides.serializers import RideRequestSerializer, AvailableDriverSerializer, PassengerDetailSerializer


class AvailableDriversView(generics.ListAPIView):
    serializer_class = AvailableDriverSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        qs = User.objects.filter(is_driver=True)
        print("Motoristas encontrados:", qs)
        return qs


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
