from django.urls import path
from .views import AvailableDriversView, RideRequestCreateView, RideRequestReceivedView, RideRequestUpdateStatusView

urlpatterns = [
    path("available_drivers/", AvailableDriversView.as_view(), name="available_drivers"),
    path("request_ride/", RideRequestCreateView.as_view(), name="request_ride"),
    path("received_rides/", RideRequestReceivedView.as_view(), name="received_rides"),
    path("ride_status/<int:ride_id>/", RideRequestUpdateStatusView.as_view()),

]
