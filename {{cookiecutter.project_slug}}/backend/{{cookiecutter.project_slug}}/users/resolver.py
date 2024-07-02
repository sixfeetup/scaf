import strawberry

    
@strawberry.type
class UserType:
    id: int
    username: str 
    name: str
    email: str
    is_staff: bool
    is_active: bool
