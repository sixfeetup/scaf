import strawberry
from strawberry.types import Info

from django.contrib.auth import get_user_model

from .types import UserType

User = get_user_model()


@strawberry.type
class UserQuery:

    @strawberry.field
    def me(self, info: Info) -> UserType:
        user = info.context.request.user
        if user.is_anonymous:
            raise Exception("Not authenticated")
        return user
    
    @strawberry.field
    def getUser(self, id: int) -> UserType:
        user = User.objects.get(id=id)
        return user
