import pytest
from strawberry_django.test.client import TestClient

from {{ cookiecutter.project_slug }}.users.models import User

pytestmark = pytest.mark.django_db


class TestGraphQLView:
    """
    Tests for the GraphQL view.
    """

    def test_me_unauthenticated(self, graphql_client: TestClient):
        """
        Test that the `me` query does not work when the user is not logged in.
        """
        res = graphql_client.query(
            """
            query Me {
                me {
                    id
                    username
                    name
                    email
                    isStaff
                    isActive
                }
            }
            """,
            asserts_errors=False,
        )
        assert res.data == None
        assert res.errors[0]["message"] == "User is not logged in."

    def test_me_authenticated(self, user: User, graphql_client: TestClient):
        """
        Test that the `me` query returns the user information if authenticated.
        """
        with graphql_client.login(user):
            res = graphql_client.query(
                """
                query Me {
                    me {
                        email
                        id
                        isActive
                        isStaff
                        name
                        username
                    }
                }
                """
            )

        assert res.errors is None
        assert res.data == {
            "me": {
                "id": str(user.id),
                "email": user.email,
                "name": user.name,
                "username": user.username,
                "isActive": user.is_active,
                "isStaff": user.is_staff,
            },
        }

    def test_update_user_unauthenticated(self, graphql_client: TestClient):
        """
        Test that the `update_user` mutation does not allow unauthenticated users.
        """
        res = graphql_client.query(
            """
            mutation MyMutation {
                updateUser(input: {id: 1 name: "John Doe"}) {
                    ... on UserType {
                        id
                        email
                        name
                    }
                }
            }
            """
        )

        assert res.errors is None
        assert res.data == {"updateUser": {}}

    def test_update_user_authenticated(self, user: User, graphql_client: TestClient):
        """
        Test that the `update_user` mutation is updating user information.
        """
        expected_name = "John Doe"
        with graphql_client.login(user):
            res = graphql_client.query(
                """
                mutation UpdateUser($input: UserPartialUpdateInput!) {
                    updateUser(input: $input) {
                        ... on UserType {
                            id
                            email
                            name
                        }
                    }
                }
                """,
                variables={
                    "input": {
                        "id": str(user.id),
                        "name": expected_name
                    }
                },
            )

        assert res.errors is None
        assert res.data == {
            "updateUser": {
                "id": str(user.id),
                "email": user.email,
                "name": expected_name,
            }
        }
