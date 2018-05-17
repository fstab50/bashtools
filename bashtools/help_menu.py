"""

Help Menu
    Help menu object containing body of help content.
    For printing with formatting

"""

from keyup.statics import PACKAGE, CONFIG_SCRIPT
from keyup.colors import Colors


PKG_ACCENT = Colors.ORANGE
PARAM_ACCENT = Colors.WHITE


synopsis_cmd = (
    Colors.RESET + PKG_ACCENT + PACKAGE +
    PARAM_ACCENT + ' --profile ' + Colors.RESET + ' [PROFILE] ' +
    PARAM_ACCENT + '--operation ' + Colors.RESET + '[OPERATION]'
    )

url_doc = Colors.URL + 'http://keyup.readthedocs.io' + Colors.RESET
url_sc = Colors.URL + 'https://bitbucket.org/blakeca00/keyup' + Colors.RESET

menu_body = Colors.BOLD + """
  DESCRIPTION""" + Colors.RESET + """
            Automated Access Key Rotation for Amazon Web Services

            Documentation:  """ + url_doc + """
            Source Code:  """ + url_sc + """
    """ + Colors.BOLD + """
  SYNOPSIS""" + Colors.RESET + """
                """ + synopsis_cmd + """

                    -p, --profile    <value>
                    -o, --operation  <value>
                   [-u, --user-name  <value> ]
                   [-a, --auto     ]
                   [-c, --configure]
                   [-V, --version  ]
                   [-d, --debug    ]
                   [-h, --help     ]
    """ + Colors.BOLD + """
  OPTIONS
        -p, --profile""" + Colors.RESET + """ (string) : Profile name of an IAM user from the local
            awscli config for which you want to rotate access keys
    """ + Colors.BOLD + """
        -o, --operation""" + Colors.RESET + """ (string) : Operation to be conducted on the access key
            of the IAM user noted by the PROFILE value. There are 2 operations:

                Valid Operations: {list, update}

                    - list       : List keys and key metadata
                    - up         : Rotate keys by creating new keys, install
                                   keys, then delete deprecated keyset

                    Default: """ + Colors.BOLD + 'list' + Colors.RESET + """
    """ + Colors.BOLD + """
        -u, --user-name""" + Colors.RESET + """ (string) : IAM username for which you want conduct key
            operations using the permissions of profile username provided with
            the --profile option
    """ + Colors.BOLD + """
        -a, --auto""" + Colors.RESET + """ : Suppress output to stdout when """ + PACKAGE + """ triggered via a sched-
            uler such as cron or by some other automated means to rotate keys
            on a periodic schedule.
    """ + Colors.BOLD + """
        -c, --configure""" + Colors.RESET + """ :  Configure parameters to custom values. If the local
            config file does not exist, option writes a new local configuration
            file to disk.  If file exists, overwrites existing config with up-
            dated values.

               Configure runtime options:   |   Display local config file:
                                            |
                  $ """ + PKG_ACCENT + PACKAGE + PARAM_ACCENT + ' --configure' + Colors.RESET + """       |       $ """ + PKG_ACCENT + CONFIG_SCRIPT + PARAM_ACCENT + """
    """ + Colors.BOLD + """
        -d, --debug""" + Colors.RESET + """ : when True, do not write to the local awscli configuration
            file(s). Instead, write to a temporary location for testing the int-
            grity of the credentials file format that is written to disk.
    """ + Colors.BOLD + """
        -V, --version""" + Colors.RESET + """ : Print package version
    """ + Colors.BOLD + """
        -h, --help""" + Colors.RESET + """ : Show this help message and exit

    """
