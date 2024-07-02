import strawberry
from .queries import UserQuery


schema = strawberry.Schema(query=UserQuery)
