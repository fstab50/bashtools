"""
Summary:
    bashtools Project-level Defaults and Settings

    - **Local Default Settings**: Local defaults for your specific installation are derived from settings found in:

    .. code-block:: bash

        ~/.config/bashtools/config.json

Module Attributes:
    - user_home (TYPE str):
        $HOME environment variable, present for most Unix and Unix-like POSIX systems
    - config_dir (TYPE str):
        directory name default for stsaval config files (.stsaval)
    - config_path (TYPE str):
        default for stsaval config files, includes config_dir (~/.stsaval)
"""

import os
import inspect
import logging
from bashtools.script_utils import read_local_config
from bashtools import __version__

logger = logging.getLogger(__version__)
logger.setLevel(logging.INFO)


# --  project-level DEFAULTS  ------------------------------------------------


try:

    user_home = os.environ['HOME']

except KeyError as e:
    logger.critical(
        '%s: %s variable is required and not found in the environment' %
        (inspect.stack()[0][3], str(e)))
    raise e
else:
    # local vars -- this section executes as default; if windows, execute diff
    # section with appropriate pathnames

    # project
    PACKAGE = 'bashtools'
    LICENSE = 'MIT'
    LICENSE_DESC = 'MIT License'
    version = __version__

    # config parameters
    CONFIG_SCRIPT = 'toolconfig'         # console script to access config file
    config_dir = '.config'
    config_subdir = PACKAGE
    config_filename = 'config.json'
    config_path = user_home + '/' + config_dir + '/' + config_subdir + '/' + config_filename

    # logging parameters
    enable_logging = False
    log_mode = 'FILE'
    log_filename = 'bashtools.log'
    log_dir = user_home + '/' + 'logs'
    log_path = log_dir + '/' + log_filename

    seed_config = {
        "PROJECT": {
            "PACKAGE": PACKAGE,
            "CONFIG_VERSION": version,
            "CONFIG_DATE": "",
            "HOME": user_home,
            "CONFIG_FILENAME": config_filename,
            "CONFIG_DIR": config_dir,
            "CONFIG_SUBDIR": config_subdir,
            "CONFIG_PATH": config_path
        },
        "LOGGING": {
            "ENABLE_LOGGING": enable_logging,
            "LOG_FILENAME": log_filename,
            "LOG_PATH": log_path,
            "LOG_MODE": log_mode,
            "SYSLOG_FILE": False
        }
    }

try:
    if not os.path.exists(log_dir):
        os.mkdir(log_dir)
        os.chmod(log_dir, 0o755)
    if os.path.exists(config_path):
        # parse config file
        local_config = read_local_config(cfg=config_path)
        # fail to read, set to default config
        if not local_config:
            local_config = seed_config
    else:
        local_config = seed_config

except OSError as e:
    logger.exception(
        '%s: Error when attempting to access or create local log and config %s' %
        (inspect.stack()[0][3], str(e))
    )
    raise e
