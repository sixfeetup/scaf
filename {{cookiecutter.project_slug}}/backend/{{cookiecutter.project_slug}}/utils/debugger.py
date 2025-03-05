import logging
import os
import sys

logger = logging.getLogger(__name__)


def debugger_connect_pycharm(host_ip):
    logger.info("Pycharm pydevd connecting...")
    import pydevd_pycharm
    try:
        pydevd_pycharm.settrace(host_ip, port=6400, stdoutToServer=True, stderrToServer=True)
    except ConnectionRefusedError:
        msg = "Debugger connection failed. Check IDE debugger is running and try again. Continuing without debugger."
        logger.error(msg.upper())


def debugger_connect_vscode():
    raise NotImplementedError("VSCode debugger not implemented")


def connect_debugger():
    host_ip = "host.docker.internal"
    ide = os.getenv("DEBUGGER_IDE", None)
    if host_ip and ide:
        debuggers = {
            "pycharm": debugger_connect_pycharm,
            # "vscode": debugger_connect_vscode
        }
        try:
            debuggers[ide](host_ip)
        except KeyError:
            logger.error(f"IDE {ide} not supported, must be one of {debuggers.keys()}")
            sys.exit(1)
