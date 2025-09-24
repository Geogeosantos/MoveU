from django.contrib.auth.models import AbstractUser
from django.db import models

class User(AbstractUser):
    email = models.EmailField(unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    is_driver = models.BooleanField(default=False)  # define se é motorista

    USERNAME_FIELD = "email"
    REQUIRED_FIELDS = ["username"]

    def __str__(self):
        return self.email

# Perfil de motorista (dados extras)
class DriverProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="driver_profile")
    cnh = models.CharField(max_length=20)
    validade_cnh = models.DateField()
    categoria_cnh = models.CharField(max_length=5)
    modelo_carro = models.CharField(max_length=50)
    placa_carro = models.CharField(max_length=10)
    cor_carro = models.CharField(max_length=20)
    ano_carro = models.IntegerField()

    def __str__(self):
        return f"Motorista: {self.user.username}"
    
    
DAYS_OF_WEEK = [
    ("mon", "Segunda-feira"),
    ("tue", "Terça-feira"),
    ("wed", "Quarta-feira"),
    ("thu", "Quinta-feira"),
    ("fri", "Sexta-feira"),
]

class UserSchedule(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="schedules")
    day = models.CharField(max_length=3, choices=DAYS_OF_WEEK)
    start_time = models.TimeField()
    end_time = models.TimeField()

    class Meta:
        unique_together = ("user", "day")  # cada usuário só pode ter 1 horário por dia

    def __str__(self):
        return f"{self.user.username} - {self.day} ({self.start_time} - {self.end_time})"
