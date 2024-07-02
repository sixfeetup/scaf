import strawberry
from .types import UserType
from .models import User

@strawberry.type
class UserMutation:
    @strawberry.mutation
    def updateUser(self, id: int, first_name: str, last_name: str ) -> UserType:
        user = User.objects.filter(id=id).first()
        if user:
            user.first_name = first_name
            user.last_name = last_name
            user.save
            return user
        else:
            return f"User Not found for id: {id}" 

    @strawberry.mutation
    def deleteUser(self, id: int) -> str:
        user = User.objects.filter(id=id).first()
        if user:
            user.delete()
            return f"User with id: {id} has been deleted."
        else:
            return f"User Not found for id: {id}"
