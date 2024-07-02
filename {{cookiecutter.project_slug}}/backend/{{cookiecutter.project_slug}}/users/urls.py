from django.urls import path

from {{ cookiecutter.project_slug }}.users.views import (
    user_detail_view,
    user_redirect_view,
    user_update_view,
)
{%- if cookiecutter.use_graphql == "y" %}
from strawberry.django.views import AsyncGraphQLView
from .schema import schema
{%- endif %}

app_name = "users"
urlpatterns = [
    path("~redirect/", view=user_redirect_view, name="redirect"),
    path("~update/", view=user_update_view, name="update"),
    path("<str:username>/", view=user_detail_view, name="detail"),
    {%- if cookiecutter.use_graphql == "y" %}
    path("", view= AsyncGraphQLView.as_view(schema=schema)),
    {%- endif %}
]
