from django.contrib import admin
from .models import City, Neighborhood, User, DriverProfile, UserSchedule, University

admin.site.site_header = "MoveU Admin"

admin.site.register(City)
admin.site.register(Neighborhood)
admin.site.register(User)
admin.site.register(DriverProfile)
admin.site.register(UserSchedule)
admin.site.register(University)