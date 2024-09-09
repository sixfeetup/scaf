## Detailed steps for creating and configuring a project in Sentry

### Create the Project in Sentry

1. Log in to sentry.io and click the Create Project button
2. Choose Django
3. Name the Project with client-backend naming convention (ex. {{ cookiecutter.project_dash }}-backend)
4. Assign a team (create a team, if needed, with the plus icon next to the team dropdown). Teams should be based around the people involved in a project or projects that need to know about errors, not just the client.
5. Click the Create Project button
6. Repeat the above steps with the following changes:
7. Choose Next.js
8. Name the Project with client-frontend naming convention (ex. {{ cookiecutter.project_dash }}-frontend)
9. Assign a team (create a team, if needed, with the plus icon next to the team dropdown). Teams should be based around the people involved in a project or projects that need to know about errors, not just the client.
10. Click the Create Project button

### Configure Slack Notifications

1. Click on Setting on the sidebar
2. Click on Projects on the secondary sidebar that is revealed
3. Click on the Project created in the previous section
4. Click on Alerts on the new secondary sidebar
5. Edit the existing rule or Add a new rule if there is not one already
6. Use “Send a notification for new issues” for the Rule Name
7. Choose “An issue is first seen” for the Conditions
8. Leave “All Environments”
9. Delete the “Send a notification (for all legacy integrations)” Action, if it exists, to disable sending emails
10. Add an Action and choose “Send a notification to the Slack workspace” option from the menu and fill in the appropriate `#channel` name

### Add Team Members
1. Click Settings on the sidebar
2. Click Teams on the secondary sidebar that is revealed
3. Click on the Team assigned to the Project you just created
4. Click Add Member to add additional team members as needed for the project

### Add code to Django

By default this is in the base config. Make sure the following is to your preferences in all logical locations in the `backend/config/settings/{environment}.py` files:

```
    import sentry_sdk
    ...
    sentry_sdk.init(
        dsn=env.str("SENTRY_DSN_BACKEND", default=""),
        environment=env.str("ENVIRONMENT", default="production"),
        release=env.str("RELEASE", default="dev"),
    )
```

Update `k8s/base/app.configmap.yaml` `SENTRY_DSN_BACKEND`, `VITE_SENTRY_DSN_FRONTEND` with the DSNs provided for the relevant Sentry projects. 

You can find them in Sentry by clicking Settings on the sidebar, then Projects on the secondary sidebar, then the project, then Client Keys (DSN)
