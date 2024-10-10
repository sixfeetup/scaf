from django.contrib import admin

from .models import Challenge


@admin.register(Challenge)
class ChallengeAdmin(admin.ModelAdmin):
    list_display = ("id", "is_completed")
