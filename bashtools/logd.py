"""
Project-level logging module

"""
import inspect
import logging
import logging.handlers

from bashtools.statics import local_config

syslog = logging.getLogger()
syslog.setLevel(logging.DEBUG)


def mode_assignment(arg):
    """
    Translates arg to enforce proper assignment
    """
    arg = arg.upper()
    stream_args = ('STREAM', 'CONSOLE', 'STDOUT')
    try:
        if arg in stream_args:
            return 'STREAM'
        else:
            return arg
    except Exception:
        return None


def getLogger(*args, **kwargs):
    """
    Summary:
        custom format logger

    Args:
        mode (str):  The Logger module supprts the following log modes:

            - log to console / stdout. Log_mode = 'stream'
            - log to file
            - log to system logger (syslog)

    Returns:
        logger object | TYPE: logging
    """

    log_mode = local_config['LOGGING']['LOG_MODE']

    # log format - file
    file_format = '%(asctime)s - %(pathname)s - %(name)s - [%(levelname)s]: %(message)s'

    # log format - stream
    stream_format = '%(pathname)s - %(name)s - [%(levelname)s]: %(message)s'

    # log format - syslog
    syslog_format = '- %(pathname)s - %(name)s - [%(levelname)s]: %(message)s'
    # set facility for syslog:
    if local_config['LOGGING']['SYSLOG_FILE']:
        syslog_facility = 'local7'
    else:
        syslog_facility = 'user'


    # all formats
    asctime_format = "%Y-%m-%d %H:%M:%S"

    # objects
    logger = logging.getLogger(*args, **kwargs)
    logger.propagate = False


    try:
        if not logger.handlers:
            # branch on output format, default to stream
            if mode_assignment(log_mode) == 'FILE':
                # file handler
                f_handler = logging.FileHandler(local_config['LOGGING']['LOG_PATH'])
                f_formatter = logging.Formatter(file_format, asctime_format)
                #f_formatter = logging.Formatter('%(asctime)s %(processName)s %(name)s [%(levelname)-5s]: %(message)s', asctime_format)
                f_handler.setFormatter(f_formatter)
                logger.addHandler(f_handler)
                logger.setLevel(logging.DEBUG)

            elif mode_assignment(log_mode) == 'STREAM':
                # stream handlers
                s_handler = logging.StreamHandler()
                s_formatter = logging.Formatter(stream_format)
                s_handler.setFormatter(s_formatter)
                logger.addHandler(s_handler)
                logger.setLevel(logging.DEBUG)

            elif mode_assignment(log_mode) == 'SYSLOG':
                sys_handler = logging.handlers.SysLogHandler(address='/dev/log', facility=syslog_facility)
                sys_formatter = logging.Formatter(syslog_format)
                sys_handler.setFormatter(sys_formatter)
                logger.addHandler(sys_handler)
                logger.setLevel(logging.DEBUG)

            else:
                syslog.warning(
                    '%s: [WARNING]: log_mode value of (%s) unrecognized - not supported' %
                    (inspect.stack()[0][3], str(log_mode))
                    )
                ex = Exception(
                    '%s: Unsupported mode indicated by log_mode value: %s' %
                    (inspect.stack()[0][3], str(log_mode))
                    )
                raise ex
    except OSError as e:
        raise e
    return logger
