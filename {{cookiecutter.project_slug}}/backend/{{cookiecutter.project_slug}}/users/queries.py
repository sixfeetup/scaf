import strawberry
import strawberry_django

from .types import UserType


@strawberry.type
class UserQuery:
    """
    User queries
    """

    me: UserType = strawberry_django.auth.current_user()
