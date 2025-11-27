from django.urls import path
from .views import (
    RegisterView,
    LoginView,
    ProfileView,
    LogoutView,
    SetUserTypeView,
    RegisterDriverProfileView,
    UserScheduleListCreateView,
    CityListView,
    NeighborhoodByCityView,
    UniversityListView
)

urlpatterns = [
    # Usuário
    path("register/", RegisterView.as_view(), name="register"),
    path("login/", LoginView.as_view(), name="login"),
    path("profile/", ProfileView.as_view(), name="profile"),
    path("logout/", LogoutView.as_view(), name="logout"),

    # Motorista / Passageiro
    path("set_user_type/", SetUserTypeView.as_view(), name="set_user_type"),
    path("register_driver_profile/", RegisterDriverProfileView.as_view(), name="register_driver_profile"),
    path('set_user_schedule/', UserScheduleListCreateView.as_view(), name='user_schedule'),

    # Cidades /  Bairros
    path("cities/", CityListView.as_view(), name="cities"),
    path("cities/<int:city_id>/neighborhoods/", NeighborhoodByCityView.as_view(), name="neighborhoods_by_city"),

    # Faculdades
    path("universities/", UniversityListView.as_view(), name="universities"),

]
