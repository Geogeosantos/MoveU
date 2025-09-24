from django.urls import path
from .views import (
    RegisterView,
    LoginView,
    ProfileView,
    LogoutView,
    SetUserTypeView,
    RegisterDriverProfileView,
    UserScheduleListCreateView
)

urlpatterns = [
    # Usuário
    path("register/", RegisterView.as_view(), name="register"),
    path("login/", LoginView.as_view(), name="login"),
    path("profile/", ProfileView.as_view(), name="profile"),
    path("logout/", LogoutView.as_view(), name="logout"),

    # Motorista / Passageiro
    path("set_user_type/", SetUserTypeView.as_view(), name="set_user_type"),  # define se é motorista ou passageiro
    path("register_driver_profile/", RegisterDriverProfileView.as_view(), name="register_driver_profile"),  # completa registro motorista
    path('set_user_schedule/', UserScheduleListCreateView.as_view(), name='user_schedule'),

]
