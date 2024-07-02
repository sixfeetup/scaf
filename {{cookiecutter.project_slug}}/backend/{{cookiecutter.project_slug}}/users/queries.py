import strawberry
from strawberry.types import Info

from django.contrib.auth import get_user_model

from .resolver import UserType

User = get_user_model()


@strawberry.type
class UserQuery:
    user: UserType

    @strawberry.field
    def me(self, info: Info) -> UserType:
        user = info.context.request.user
        if user.is_anonymous:
            raise Exception("Not authenticated")
        return UserType(id=user.id, email=user.email)
    
    @strawberry.field
    def getUser(self, id: int) -> UserType:
        user = User.objects.get(id=id)
        return user
