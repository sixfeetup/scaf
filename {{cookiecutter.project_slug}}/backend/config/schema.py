import strawberry
from strawberry_django.optimizer import DjangoOptimizerExtension

from {{ cookiecutter.project_slug }}.users.queries import UserQuery
from {{ cookiecutter.project_slug }}.users.mutations import UserMutation


schema = strawberry.Schema(query=UserQuery, mutation=UserMutation, extensions=[
    # other extensions...
    DjangoOptimizerExtension,
])
