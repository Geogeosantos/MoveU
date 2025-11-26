from rest_framework import generics, permissions, status, serializers
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework_simplejwt.tokens import RefreshToken
from rest_framework_simplejwt.views import TokenObtainPairView
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import User, UserSchedule, City, Neighborhood, DriverProfile, University
from .serializers import UserSerializer, RegisterSerializer, DriverProfileSerializer, UserScheduleSerializer, CitySerializer, NeighborhoodSerializer, UniversitySerializer


class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    serializer_class = RegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        
        refresh = RefreshToken.for_user(user)

        data = {
            "user_id": user.id,
            "username": user.username,
            "access": str(refresh.access_token),
            "refresh": str(refresh),
        }

        headers = self.get_success_headers(serializer.data)
        return Response(data, status=status.HTTP_201_CREATED, headers=headers)


# Login with JWT
class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    @classmethod
    def get_token(cls, user):
        token = super().get_token(user)
        token["username"] = user.username 
        return token


class LoginView(TokenObtainPairView):
    serializer_class = CustomTokenObtainPairSerializer


class SetUserTypeView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user = request.user
        user_type = request.data.get("type") 

        if user_type == "driver":
            user.is_driver = True
        else:
            user.is_driver = False
        user.save()
        return Response({"status": "success", "is_driver": user.is_driver})



class RegisterDriverProfileView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        user = request.user
        if not user.is_driver:
            return Response({"error": "Usuário não é motorista"}, status=status.HTTP_400_BAD_REQUEST)
        
        if hasattr(user, "driver_profile"):
            return Response({"error": "Perfil de motorista já registrado."}, status=status.HTTP_400_BAD_REQUEST)

        serializer = DriverProfileSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=user)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProfileView(generics.RetrieveUpdateAPIView):
    queryset = User.objects.all()
    serializer_class = UserSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user


class LogoutView(APIView):
    permission_classes = [permissions.IsAuthenticated]

    def post(self, request):
        try:
            refresh_token = request.data["refresh"]
            token = RefreshToken(refresh_token)
            token.blacklist()  # invalida o refresh token
            return Response({"message": "Logout realizado com sucesso."}, status=status.HTTP_205_RESET_CONTENT)
        except Exception as e:
            return Response({"error": "Token inválido ou já expirado."}, status=status.HTTP_400_BAD_REQUEST)


class UserScheduleListCreateView(generics.ListCreateAPIView):
    serializer_class = UserScheduleSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserSchedule.objects.filter(user=self.request.user)

    def perform_create(self, serializer):
        day = serializer.validated_data["day"]
        if UserSchedule.objects.filter(user=self.request.user, day=day).exists():
            raise serializers.ValidationError({"day": "Horário para este dia já existe."})
        serializer.save(user=self.request.user)

class CityListView(generics.ListAPIView):
    queryset = City.objects.all()
    serializer_class = CitySerializer

class NeighborhoodByCityView(generics.ListAPIView):
    serializer_class = NeighborhoodSerializer

    def get_queryset(self):
        city_id = self.kwargs.get("city_id")
        return Neighborhood.objects.filter(city_id=city_id)

class UniversityListView(generics.ListAPIView):
    queryset = University.objects.all()
    serializer_class = UniversitySerializer