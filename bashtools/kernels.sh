#!/usr/bin/env bash

#
#   Discover and Remove old Kernels (free up /boot)
#       - requires sudo or root
#
#

pkg=$(basename $0)                                  # pkg (script) full name
pkg_root=$(echo $pkg | awk -F '.' '{print $1}')     # pkg without file extention
pkg_path=$(cd $(dirname $0); pwd -P)                # location of pkg
OS_INFO=$(sh $pkg_path/os_distro.sh 2>/dev/null)
os_family=$(echo $OS_INFO | awk '{print $1}')
os_release=$(echo $OS_INFO | awk '{print $2}')

# source
source $pkg_path/core/std_functions.sh
source $pkg_path/core/colors.sh

REMOVE=""


function root_permissions_bool(){
    ##
    ## validates required root privileges, return bool only ##
    ##

    if [ $EUID -eq 0 ] || [ $SUDO_USER ]; then

        return 0

    fi
    return 1
    #
    # <-- end function root_permissions -->
}


function list_deprecated_kernels(){
    ##
    ##  List all Kernels installed, but no longer in use
    ##

    dpkg --list 'linux-image*'| awk '{ if ($1=="ii") print $2}'|grep -v $(uname -r)

    #
    # <-- end function -->
}


function select_kernel(){
    local choice
    declare -a kernels=("${!1}")
    std_message "Select a kernel for removal" "INFO"
    read -p "Enter number [quit]: " choice
    std_message "Kernel package ${red}${kernels[$choice]}${reset} selected for removal." "OK"
    OPTION="$choice"
}


function uninstall_kernel(){
    declare -a kernels=("${!1}")
    local option="$2"
    local choice

    kernel="${kernels[$option]}"

    std_message "You are about to uninstall ${red}$kernel${reset}" "WARN"
    read -p "Confirm? [quit]: " choice

    if [ ! $choice ] || [ "$choice" = "quit" ]; then
        std_message "Kernel ${red}$kernel${reset} will remain installed" "INFO"
        return 1
    else
        apt-get purge $kernel
        return 0
    fi
}


function finishing_actions(){
    ##
    ##  required actions if uninstall a kernel
    ##
    apt-get autoremove
    update-grub
    std_message "Completed autoremove and grub update" "INFO"
}


# -- main -----------------------------------------------------------------------------------------


if root_permissions_bool; then

    declare -a arr_kernels
    for k in $(list_deprecated_kernels); do
        arr_kernels=( "${arr_kernels[@]}" "$k" )
    done
    std_message "Installed Kernels No longer in use:" "INFO"
    i=0
    for k in "${arr_kernels[@]}"; do
        printf -- '\t(%s):  %s\n' "$i" "$k"
        i=$(( $i + 1 ))
    done
    printf -- '\n'

    select_kernel arr_kernels[@]

    if uninstall_kernel arr_kernels[@] $OPTION; then
        finishing_actions
    fi

else
    std_warn "This command requires root or sudo access to root privileges.\n
        \n\t\tRe-run as root or execute with sudo:
            \n\t\t\t$ sudo  $pkg  <parameters>"
        printf -- "\n\n"
    exit 1
fi

exit 0
