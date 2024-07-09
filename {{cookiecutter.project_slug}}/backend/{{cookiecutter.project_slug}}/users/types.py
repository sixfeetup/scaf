import strawberry
import strawberry_django
from django.contrib.auth import get_user_model

User = get_user_model()


@strawberry_django.type(User)
class UserType:
    """
    User type
    """

    id: strawberry.auto
    username: strawberry.auto
    name: strawberry.auto
    email: strawberry.auto
    is_staff: strawberry.auto
    is_active: strawberry.auto
