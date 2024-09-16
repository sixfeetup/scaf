# {{cookiecutter.project_slug}}/challenge/apps.py
from django.apps import AppConfig


class ChallengeConfig(AppConfig):
    name = "{{cookiecutter.project_slug}}.challenge"

    def ready(self):
        from django.db.models.signals import post_migrate
        # Connect post-migrate signal to make sure that this comes
        # after migrations are done.
        post_migrate.connect(self.report_readiness, sender=self)

    def report_readiness(self, **kwargs):
        from .utils import report_readiness
        report_readiness()
