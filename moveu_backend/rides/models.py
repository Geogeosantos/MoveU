from django.db import models
from django.conf import settings

STATUS_CHOICES = [
    ("pending", "Pendente"),
    ("accepted", "Aceito"),
    ("rejected", "Rejeitado"),
    ("completed", "Concluído"),
]

class RideRequest(models.Model):
    driver = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="rides_given", null=True, blank=True)
    passenger = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name="rides_taken", null=True, blank=True)
    university = models.ForeignKey("users.University", on_delete=models.CASCADE)
    neighborhood = models.ForeignKey("users.Neighborhood", on_delete=models.CASCADE)
    day = models.CharField(max_length=3, choices=[
        ("mon","Segunda"),
        ("tue","Terça"),
        ("wed","Quarta"),
        ("thu","Quinta"),
        ("fri","Sexta"),
    ])
    start_time = models.TimeField()
    end_time = models.TimeField()
    status = models.CharField(max_length=20, choices=STATUS_CHOICES, default="pending")
    created_at = models.DateTimeField(auto_now_add=True)
    reason_rejected = models.CharField(max_length=255, null=True, blank=True)

    def __str__(self):
        return f"{self.driver.username} -> {self.passenger.username if self.passenger else 'Aguardando'} ({self.day})"
