from django.db import models


class Challenge(models.Model):
    is_completed = models.BooleanField(
        verbose_name="completion status",
        help_text="Designates whether scaf challenge is completed or not.",
        default=False,
    )

    class Meta:
        verbose_name = "challenge"
        verbose_name_plural = "challenges"
