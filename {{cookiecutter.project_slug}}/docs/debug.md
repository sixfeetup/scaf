# :bug: How to debug the application

The steps below describe how to set up interactive debugging with PyCharm.

## PyCharm Debugging Setup
Update `k8s/base/app.configmap.yaml` with `data` field `DEBUGGER_IDE: "pycharm"`

In PyCharm:

1. Go to 'Run' in the toolbar
2. Click on 'Edit Configurations'
3. Click on '+' in the top left of the dialog
4. Select 'Python Debug Server'
5. Set the host to 0.0.0.0 and the port to 6400, and the name as you see fit.
6. Click 'Ok'

## Debugging in development
Before the code you want to debug, add the following lines:

```python
from {{ cookiecutter.project_slug }}.utils.debugger import connect_debugger
connect_debugger()
```

You can then set break points in your IDE and call the code as usual to hit them.

When the debugger is first connected, you will see a screen pop up about mapping - Click 'auto-detect' path mapping settings and choose the file that matches [backend/{{ cookiecutter.project_slug }}/utils/debugger.py](/backend/{{ cookiecutter.project_slug }}/utils/debugger.py)

## Troubleshooting
If the debugger is connected early on, such as in `manage.py`, standard django functionality such the admin interface may break. For that reason connecting in proximity to the code you want to test is recommended.
