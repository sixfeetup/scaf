import strawberry

from {{ cookiecutter.project_slug }}.users.queries import UserQuery
from {{ cookiecutter.project_slug }}.users.mutations import UserMutation

schema = strawberry.Schema(query=UserQuery, mutation=UserMutation)
