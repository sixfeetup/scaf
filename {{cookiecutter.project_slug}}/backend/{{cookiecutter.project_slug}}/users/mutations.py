import strawberry
import strawberry_django
from django.contrib.auth import get_user_model
from strawberry_django import mutations

from .types import UserType

User = get_user_model()


@strawberry_django.input(User)
class UserRegistrationInput:
    username: strawberry.auto
    password: strawberry.auto


@strawberry_django.partial(User)
class UserPartialUpdateInput:
    id: strawberry.auto
    name: strawberry.auto


@strawberry.type
class UserMutation:
    """
    User mutations
    """

    # Auth mutations
    login: UserType = strawberry_django.auth.login()
    logout = strawberry_django.auth.logout()
    register: UserType = strawberry_django.auth.register(UserRegistrationInput)

    # User mutations
    update_user: UserType = mutations.update(UserPartialUpdateInput)
