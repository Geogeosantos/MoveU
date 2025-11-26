from django.contrib import admin
from .models import RideRequest

@admin.register(RideRequest)
class RideRequestAdmin(admin.ModelAdmin):
    list_display = ("id", "passenger", "driver", "day", "status", "created_at")
    list_filter = ("day", "status")
    search_fields = ("passenger__username", "driver__username")
    
