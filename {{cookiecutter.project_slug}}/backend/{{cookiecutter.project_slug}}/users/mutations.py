import strawberry
from .types import UserType
from .models import User

@strawberry.type
class UserMutation:
    @strawberry.mutation
    def updateUser(self, id: int, first_name: str, last_name: str ) -> UserType:
        user = User.objects.get(id=input.id)
        if user:
            user.first_name = first_name
            user.last_name = last_name
        user.save
        return user

    @strawberry.mutation
    def deleteUser(self, id: int) -> str:
        user = User.objects.get(id=id)
        user.delete()
        return f"User with id {id} has been deleted."
