## Detailed steps for creating and configuring a project in Sentry

### Create the Project in Sentry

1. Log in to sentry.io and click the Create Project button
2. Choose Django for Django projects or Python for Plone projects
3. Name the Project with client-environment naming convention (ex. {{cookiecutter.project_dash}}-sandbox)
4. Assign a team (create a team, if needed, with the plus icon next to the team dropdown). Teams should be based around the people involved in a project or projects that need to know about errors, not just the client. (Hence, `rtns-plone` for those related sites, instead of just `retrans`.)
5. Click the Create Project button

### Configure Slack Notifications

1. Click on Setting on the sidebar
2. Click on Projects on the secondary sidebar that is revealed
3. Click on the Project created in the previous section
4. Click on Alerts on the new secondary sidebar
6. Edit the existing rule or Add a new rule if there is not one already
7. Use “Send a notification for new issues” for the Rule Name
8. Choose “An issue is first seen” for the Conditions
9. Leave “All Environments”
10. Delete the “Send a notification (for all legacy integrations)” Action, if it exists, to disable sending emails
11. Add an Action and choose “Send a notification to the Slack workspace” option from the menu and fill in the appropriate `#channel` name

### Add Team Members
1. Click Settings on the sidebar
2. Click Teams on the secondary sidebar that is revealed
3. Click on the Team assigned to the Project you just created
4. Click Add Member to add additional team members as needed for the project

### Add code to Django

1. Install the latest version of `sentry-sdk` using the project’s install tool (likely pipenv or pip using Pipfile or requirements.txt)
2. Make sure the following is present in all logical locations in the `backend/config/settings/{environment}.py` files that you set up as Project’s in Sentry:
```
    import sentry_sdk
    from sentry_sdk.integrations.django import DjangoIntegration
    ...
    sentry_sdk.init(
        dsn=env('SENTRY_DSN', ''),
        integrations=[DjangoIntegration()]
    )
```
3. Make sure you have set the `SENTRY_DSN` environment value in `k8s/{environment}/django.configmap.yaml` with the DSN provided in the Sentry project for this environment:
```
  # sentry monitoring
  SENTRY_DSN: "XXX"
```

You can find it by clicking Settings on the sidebar, then Projects on the secondary sidebar, then the project, then Client Keys (DSN)
