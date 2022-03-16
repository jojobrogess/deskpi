#!/bin/bash
####init library should be installed first prior to anything####
################################################################
daemonname="deskpi"
installationfolder=$HOME/$daemonname-Test
userlibrary=/storage/user/
initfunctions=/storage/user/lib/init-functions
initfunctionsd=storage/user/lib/init-functionsd/
initfunctionsd1=/storage/user/lib/init-functionsd
initfunctionsd2=/storage/user/lib/init-functionsd
initfunctionsd3=/storage/user/lib/init-functionsd
################################################################

############################
#### Create User Lib/Bin Directory
############################

if [ ! -d "/storage/user" ] ; then
	mkdir -p $userlibrary
	mkdir -p $userlibrary/lib
	mkdir -p $userlibrary/bin
fi

############################
#### Create initunctions####
############################

if [ ! -d "/storage/user/lib/lsb" ] ; then
	mkdir -p $userlibrary/lib/lsb
fi

if [ -e "/storage/user/lib/lsb/init-functions" ] ; then
	rm -r /storage/user/lib/lsb/init-functions
	touch $initfunctions
	chmod +x $installationfolder/lib/lsb/init-functions
fi

echo '# /lib/lsb/init-functions for Debian -*- shell-script -*-' >> $initfunctions
echo '#' >> $initfunctions
echo '#Copyright (c) 2002-08 Chris Lawrence' >> $initfunctions
echo '#All rights reserved.' >> $initfunctions
echo '#' >> $initfunctions
echo '#Redistribution and use in source and binary forms, with or without' >> $initfunctions
echo '#modification, are permitted provided that the following conditions' >> $initfunctions
echo '#are met:' >> $initfunctions
echo '#1. Redistributions of source code must retain the above copyright' >> $initfunctions
echo '#   notice, this list of conditions and the following disclaimer.' >> $initfunctions
echo '#2. Redistributions in binary form must reproduce the above copyright' >> $initfunctions
echo '#   notice, this list of conditions and the following disclaimer in the' >> $initfunctions
echo '#   documentation and/or other materials provided with the distribution.' >> $initfunctions
echo '#3. Neither the name of the author nor the names of other contributors' >> $initfunctions
echo '#   may be used to endorse or promote products derived from this software' >> $initfunctions
echo '#   without specific prior written permission.' >> $initfunctions
echo '#' >> $initfunctions
echo '#THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR' >> $initfunctions
echo '#IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED' >> $initfunctions
echo '#WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE' >> $initfunctions
echo '#ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE' >> $initfunctions
echo '#LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR' >> $initfunctions
echo '#CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF' >> $initfunctions
echo '#SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR' >> $initfunctions
echo '#BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,' >> $initfunctions
echo '#WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE' >> $initfunctions
echo '#OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE,' >> $initfunctions
echo '#EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.' >> $initfunctions
echo '' >> $initfunctions
echo 'start_daemon () {' >> $initfunctions
echo '    local force nice pidfile exec args OPTIND' >> $initfunctions
echo '    force=""' >> $initfunctions
echo '    nice=0' >> $initfunctions
echo '    pidfile=/dev/null' >> $initfunctions
echo '' >> $initfunctions
echo '    OPTIND=1' >> $initfunctions
echo '    while getopts fn:p: opt ; do' >> $initfunctions
echo '        case "$opt" in' >> $initfunctions
echo '            f)  force="force";;' >> $initfunctions
echo '            n)  nice="$OPTARG";;' >> $initfunctions
echo '            p)  pidfile="$OPTARG";;' >> $initfunctions
echo '        esac' >> $initfunctions
echo '    done' >> $initfunctions
echo '    ' >> $initfunctions
echo '    shift $(($OPTIND - 1))' >> $initfunctions
echo '    if [ "$1" = '--' ]; then' >> $initfunctions
echo '        shift' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    exec="$1"; shift' >> $initfunctions
echo '' >> $initfunctions
echo '    args="--start --nicelevel $nice --quiet --oknodo"' >> $initfunctions
echo '    if [ "$force" ]; then' >> $initfunctions
echo '        /sbin/start-stop-daemon $args \' >> $initfunctions
echo '	    --chdir "$PWD" --startas $exec --pidfile /dev/null -- "$@"' >> $initfunctions
echo '    elif [ $pidfile ]; then' >> $initfunctions
echo '        /sbin/start-stop-daemon $args \' >> $initfunctions
echo '	    --chdir "$PWD" --exec $exec --oknodo --pidfile "$pidfile" -- "$@"' >> $initfunctions
echo '    else' >> $initfunctions
echo '        /sbin/start-stop-daemon $args --chdir "$PWD" --exec $exec -- "$@"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'pidofproc () {' >> $initfunctions
echo '    local pidfile base status specified pid OPTIND' >> $initfunctions
echo '    pidfile=' >> $initfunctions
echo '    specified=' >> $initfunctions
echo '    ' >> $initfunctions
echo '    OPTIND=1' >> $initfunctions
echo '    while getopts p: opt ; do' >> $initfunctions
echo '        case "$opt" in' >> $initfunctions
echo '            p)  pidfile="$OPTARG"' >> $initfunctions
echo '                specified="specified"' >> $initfunctions
echo '		;;' >> $initfunctions
echo '        esac' >> $initfunctions
echo '    done' >> $initfunctions
echo '    shift $(($OPTIND - 1))' >> $initfunctions
echo '    if [ $# -ne 1 ]; then' >> $initfunctions
echo '        echo "$0: invalid arguments" >&2' >> $initfunctions
echo '        return 4' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    base=${1##*/}' >> $initfunctions
echo '    if [ ! "$specified" ]; then' >> $initfunctions
echo '        pidfile="/var/run/$base.pid"' >> $initfunctions
echo '    fiecho ' >> $initfunctions
echo ''>> $initfunctions
echo '    if [ -n "${pidfile:-}" ]; then' >> $initfunctions
echo '     if [ -e "$pidfile" ]; then' >> $initfunctions
echo '      if [ -r "$pidfile" ]; then' >> $initfunctions
echo '        read pid < "$pidfile"' >> $initfunctions
echo '        if [ -n "${pid:-}" ]; then' >> $initfunctions
echo '            if $(kill -0 "${pid:-}" 2> /dev/null); then' >> $initfunctions
echo '                echo "$pid" || true' >> $initfunctions
echo '                return 0' >> $initfunctions
echo '            elif ps "${pid:-}" >/dev/null 2>&1; then' >> $initfunctions
echo '                echo "$pid" || true' >> $initfunctions
echo '                return 0 # program is running, but not owned by this user' >> $initfunctions
echo '            else' >> $initfunctions
echo '                return 1 # program is dead and /var/run pid file exists' >> $initfunctions
echo '            fi' >> $initfunctions
echo '        fi' >> $initfunctions
echo '      else' >> $initfunctions
echo '        return 4 # pid file not readable, hence status is unknown.' >> $initfunctions
echo '      fi' >> $initfunctions
echo '     else' >> $initfunctions
echo '       # pid file doesnt exist, try to find the pid nevertheless' >> $initfunctions
echo '       if [ -x /bin/pidof ] && [ ! "$specified" ]; then' >> $initfunctions
echo '         status="0"' >> $initfunctions
echo '         /bin/pidof -c -o %PPID -x $1 || status="$?"' >> $initfunctions
echo '         if [ "$status" = 1 ]; then' >> $initfunctions
echo '             return 3 # program is not running' >> $initfunctions
echo '         fi' >> $initfunctions
echo '         return 0' >> $initfunctions
echo '       fi' >> $initfunctions
echo '       return 3 # specified pid file doesnt exist, program probably stopped' >> $initfunctions
echo '     fi' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    if [ "$specified" ]; then' >> $initfunctions
echo '        return 3 # almost certain its not running' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    return 4 # Unable to determine status' >> $initfunctions
echo '}' >>$initfunctions
echo '' >> $initfunctions
echo '# start-stop-daemon uses the same algorithm as "pidofproc" above.' >> $initfunctions
echo 'killproc () {' >> $initfunctions
echo '    local pidfile sig status base name_param is_term_sig OPTIND' >> $initfunctions
echo '    pidfile=' >> $initfunctions
echo '    name_param=' >> $initfunctions
echo '    is_term_sig=echo ' >> $initfunctions
echo '' >> $initfunctions
echo '    OPTIND=1' >> $initfunctions
echo '    while getopts p: opt ; do' >> $initfunctions
echo '        case "$opt" in' >> $initfunctions
echo '            p)  pidfile="$OPTARG";;' >> $initfunctions
echo '        esac' >> $initfunctions
echo '    done' >> $initfunctions
echo '    shift $(($OPTIND - 1))' >> $initfunctions
echo '' >> $initfunctions
echo '    base=${1##*/}' >> $initfunctions
echo '    if [ ! $pidfile ]; then' >> $initfunctions
echo '        name_param="--name $base --pidfile /var/run/$base.pid"' >> $initfunctions
echo '    else' >> $initfunctions
echo '        name_param="--name $base --pidfile $pidfile"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    sig=$(echo ${2:-} | sed -e 's/^-\(.*\)/\1/')' >> $initfunctions
echo '    sig=$(echo $sig | sed -e 's/^SIG\(.*\)/\1/')' >> $initfunctions
echo '    if [ "$sig" = 15 ] || [ "$sig" = TERM ]; then' >> $initfunctions
echo '        is_term_sig="terminate_signal"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    status=0' >> $initfunctions
echo '    if [ ! "$is_term_sig" ]; then' >> $initfunctions
echo '        if [ -n "$sig" ]; then' >> $initfunctions
echo '            /sbin/start-stop-daemon --stop --signal "$sig" \' >> $initfunctions
echo '		--quiet $name_param || status="$?"' >> $initfunctions
echo '        else' >> $initfunctions
echo '            /sbin/start-stop-daemon --stop \' >> $initfunctions
echo '		--retry 5 \' >> $initfunctions
echo '		--quiet $name_param || status="$?"' >> $initfunctions
echo '        fi' >> $initfunctions
echo '    else' >> $initfunctions
echo '        /sbin/start-stop-daemon --stop --quiet \' >> $initfunctions
echo '	    --oknodo $name_param || status="$?"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    if [ "$status" = 1 ]; then' >> $initfunctions
echo '        if [ -z "$sig" ]; then' >> $initfunctions
echo '            return 0' >> $initfunctions
echo '        fi' >> $initfunctions
echo '        return 3 # program is not running' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    if [ "$status" = 0 ] && [ "$is_term_sig" ] && [ "$pidfile" ]; then' >> $initfunctions
echo '        pidofproc -p "$pidfile" "$1" >/dev/null || rm -f "$pidfile"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    return 0' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# Return LSB status' >> $initfunctions
echo 'status_of_proc () {' >> $initfunctions
echo '    local pidfile daemon name status OPTIND' >> $initfunctions
echo '' >> $initfunctions
echo '    pidfile=' >> $initfunctions
echo '    OPTIND=1' >> $initfunctions
echo '    while getopts p: opt ; do' >> $initfunctions
echo '        case "$opt" in' >> $initfunctions
echo '            p)  pidfile="$OPTARG";;' >> $initfunctions
echo '        esac' >> $initfunctions
echo '    done' >> $initfunctions
echo '    shift $(($OPTIND - 1))' >> $initfunctions
echo '' >> $initfunctions
echo '    if [ -n "$pidfile" ]; then' >> $initfunctions
echo '        pidfile="-p $pidfile"' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    daemon="$1"' >> $initfunctions
echo '    name="$2"' >> $initfunctions
echo '' >> $initfunctions
echo '    status="0"' >> $initfunctions
echo '    pidofproc $pidfile $daemon >/dev/null || status="$?"' >> $initfunctions
echo '    if [ "$status" = 0 ]; then' >> $initfunctions
echo '        log_success_msg "$name is running"' >> $initfunctions
echo '        return 0' >> $initfunctions
echo '    elif [ "$status" = 4 ]; then' >> $initfunctions
echo '        log_failure_msg "could not access PID file for $name"' >> $initfunctions
echo '        return $status' >> $initfunctions
echo '    else' >> $initfunctions
echo '        log_failure_msg "$name is not running"' >> $initfunctions
echo '        return $status' >> $initfunctions
echo '    fi' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_use_fancy_output () {' >> $initfunctions
echo '    TPUT=/usr/bin/tput' >> $initfunctions
echo '    EXPR=/usr/bin/expr' >> $initfunctions
echo '    if  [ -t 1 ] &&' >> $initfunctions
echo '	[ "x${TERM:-}" != "x" ] &&' >> $initfunctions
echo '	[ "x${TERM:-}" != "xdumb" ] &&' >> $initfunctions
echo '	[ -x $TPUT ] && [ -x $EXPR ] &&' >> $initfunctions
echo '	$TPUT hpa 60 >/dev/null 2>&1 &&' >> $initfunctions
echo '	$TPUT setaf 1 >/dev/null 2>&1' >> $initfunctions
echo '    then' >> $initfunctions
echo '        [ -z $FANCYTTY ] && FANCYTTY=1 || true' >> $initfunctions
echo '    else' >> $initfunctions
echo '        FANCYTTY=0' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    case "$FANCYTTY" in' >> $initfunctions
echo '        1|Y|yes|true)   true;;' >> $initfunctions
echo '        *)              false;;' >> $initfunctions
echo '    esac' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_success_msg () {' >> $initfunctions
echo '    if [ -n "${1:-}" ]; then' >> $initfunctions
echo '        log_begin_msg $@' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_end_msg 0' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_failure_msg () {' >> $initfunctions
echo '    if [ -n "${1:-}" ]; then' >> $initfunctions
echo '        log_begin_msg $@ "..."' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_end_msg 1 || true' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_warning_msg () {' >> $initfunctions
echo '    if [ -n "${1:-}" ]; then' >> $initfunctions
echo '        log_begin_msg $@ "..."' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_end_msg 255 || true' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '#' >> $initfunctions
echo '# NON-LSB HELPER FUNCTIONS' >> $initfunctions
echo '#' >> $initfunctions
echo '# int get_lsb_header_val (char *scriptpathname, char *key)' >> $initfunctions
echo 'get_lsb_header_val () {' >> $initfunctions
echo '        if [ ! -f "$1" ] || [ -z "${2:-}" ]; then' >> $initfunctions
echo '                return 1' >> $initfunctions
echo '        fi' >> $initfunctions
echo '        LSB_S="### BEGIN INIT INFO"' >> $initfunctions
echo '        LSB_E="### END INIT INFO"' >> $initfunctions
echo '        sed -n "/$LSB_S/,/$LSB_E/ s/# $2: \+\(.*\)/\1/p" "$1"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# If the currently running init daemon is upstart, return zero; if the' >> $initfunctions
echo '# calling init script belongs to a package which also provides a native' >> $initfunctions
echo '# upstart job, it should generally exit non-zero in this case.' >> $initfunctions
echo 'init_is_upstart()' >> $initfunctions
echo '{' >> $initfunctions
echo '   if [ -x /sbin/initctl ] && /sbin/initctl version 2>/dev/null | /bin/grep -q upstart; then' >> $initfunctions
echo '       return 0' >> $initfunctions
echo '   fi' >> $initfunctions
echo '   return 1' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# int log_begin_message (char *message)' >> $initfunctions
echo 'log_begin_msg () {' >> $initfunctions
echo '    log_begin_msg_pre "$@"' >> $initfunctions
echo '    if [ -z "${1:-}" ]; then' >> $initfunctions
echo '        return 1' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    echo -n "$@" || true' >> $initfunctions
echo '    log_begin_msg_post "$@"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# Sample usage:' >> $initfunctions
echo '# log_daemon_msg "Starting GNOME Login Manager" "gdm"' >> $initfunctions
echo '#' >> $initfunctions
echo '# On Debian, would output "Starting GNOME Login Manager: gdm"' >> $initfunctions
echo '# On Ubuntu, would output " * Starting GNOME Login Manager..."' >> $initfunctions
echo '#' >> $initfunctions
echo '# If the second argument is omitted, logging suitable for use with' >> $initfunctions
echo '# log_progress_msg() is used:' >> $initfunctions
echo '#' >> $initfunctions
echo '# log_daemon_msg "Starting remote filesystem services"' >> $initfunctions
echo '#' >> $initfunctions
echo '# On Debian, would output "Starting remote filesystem services:"' >> $initfunctions
echo '# On Ubuntu, would output " * Starting remote filesystem services..."' >> $initfunctions
echo '' >> $initfunctions
echo 'log_daemon_msg () {' >> $initfunctions
echo '    if [ -z "${1:-}" ]; then' >> $initfunctions
echo '        return 1' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_daemon_msg_pre "$@"' >> $initfunctions
echo '' >> $initfunctions
echo '    if [ -z "${2:-}" ]; then' >> $initfunctions
echo '        echo -n "$1:" || true' >> $initfunctions
echo '        return' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    ' >> $initfunctions
echo '    echo -n "$1: $2" || true' >> $initfunctions
echo '    log_daemon_msg_post "$@"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# #319739' >> $initfunctions
echo '#' >> $initfunctions
echo '# Per policy docs:' >> $initfunctions
echo '#' >> $initfunctions
echo '#     log_daemon_msg "Starting remote file system services"' >> $initfunctions
echo '#     log_progress_msg "nfsd"; start-stop-daemon --start --quiet nfsd' >> $initfunctions
echo '#     log_progress_msg "mountd"; start-stop-daemon --start --quiet mountd' >> $initfunctions
echo '#     log_progress_msg "ugidd"; start-stop-daemon --start --quiet ugidd' >> $initfunctions
echo '#     log_end_msg 0' >> $initfunctions
echo '#' >> $initfunctions
echo '# You could also do something fancy with log_end_msg here based on the' >> $initfunctions
echo '# return values of start-stop-daemon; this is left as an exercise for' >> $initfunctions
echo '# the reader...' >> $initfunctions
echo '#' >> $initfunctions
echo '# On Ubuntu, one would expect log_progress_msg to be a no-op.' >> $initfunctions
echo 'log_progress_msg () {' >> $initfunctions
echo '    if [ -z "${1:-}" ]; then' >> $initfunctions
echo '        return 1' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    echo -n " $@" || true' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '' >> $initfunctions
echo '# int log_end_message (int exitstatus)' >> $initfunctions
echo 'log_end_msg () {' >> $initfunctions
echo '    # If no arguments were passed, return' >> $initfunctions
echo '    if [ -z "${1:-}" ]; then' >> $initfunctions
echo '        return 1' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    local retval' >> $initfunctions
echo '    retval=$1' >> $initfunctions
echo '' >> $initfunctions
echo '    log_end_msg_pre "$@"' >> $initfunctions
echo '' >> $initfunctions
echo '    # Only do the fancy stuff if we have an appropriate terminal' >> $initfunctions
echo '    # and if /usr is already mounted' >> $initfunctions
echo '    if log_use_fancy_output; then' >> $initfunctions
echo '        RED=$( $TPUT setaf 1)' >> $initfunctions
echo '        YELLOW=$( $TPUT setaf 3)' >> $initfunctions
echo '        NORMAL=$( $TPUT op)' >> $initfunctions
echo '    else' >> $initfunctions
echo '        RED=''' >> $initfunctions
echo '        YELLOW=''' >> $initfunctions
echo '        NORMAL=''' >> $initfunctions
echo '    fiecho ' >> $initfunctions
echo '' >> $initfunctions
echo '    if [ $1 -eq 0 ]; then' >> $initfunctions
echo '        echo "." || true' >> $initfunctions
echo '    elif [ $1 -eq 255 ]; then' >> $initfunctions
echo '        /bin/echo -e " ${YELLOW}(warning).${NORMAL}" || true' >> $initfunctions
echo '    else' >> $initfunctions
echo '        /bin/echo -e " ${RED}failed!${NORMAL}" || true' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_end_msg_post "$@"' >> $initfunctions
echo '    return $retval' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_action_msg () {' >> $initfunctions
echo '    log_action_msg_pre "$@"' >> $initfunctions
echo '    echo "$@." || true' >> $initfunctions
echo '    log_action_msg_post "$@"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_action_begin_msg () {' >> $initfunctions
echo '    log_action_begin_msg_pre "$@"' >> $initfunctions
echo '    echo -n "$@..." || true' >> $initfunctions
echo '    log_action_begin_msg_post "$@"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_action_cont_msg () {' >> $initfunctions
echo '    echo -n "$@..." || true' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo 'log_action_end_msg () {' >> $initfunctions
echo '    local end' >> $initfunctions
echo '    log_action_end_msg_pre "$@"' >> $initfunctions
echo '    if [ -z "${2:-}" ]; then' >> $initfunctions
echo '        end="."' >> $initfunctions
echo '    else' >> $initfunctions
echo '        end=" ($2)."' >> $initfunctions
echo '    fi' >> $initfunctions
echo '' >> $initfunctions
echo '    if [ $1 -eq 0 ]; then' >> $initfunctions
echo '        echo "done${end}" || true' >> $initfunctions
echo '    else' >> $initfunctions
echo '        if log_use_fancy_output; then' >> $initfunctions
echo '            RED=$( $TPUT setaf 1)' >> $initfunctions
echo '            NORMAL=$( $TPUT op)' >> $initfunctions
echo '            /bin/echo -e "${RED}failed${end}${NORMAL}" || true' >> $initfunctions
echo '        else' >> $initfunctions
echo '            echo "failed${end}" || true' >> $initfunctions
echo '        fi' >> $initfunctions
echo '    fi' >> $initfunctions
echo '    log_action_end_msg_post "$@"' >> $initfunctions
echo '}' >> $initfunctions
echo '' >> $initfunctions
echo '# Pre&Post empty function declaration, to be overriden from /lib/lsb/init-functions.d/*' >> $initfunctions
echo 'log_daemon_msg_pre () { :; }' >> $initfunctions
echo 'log_daemon_msg_post () { :; }' >> $initfunctions
echo 'log_begin_msg_pre () { :; }' >> $initfunctions
echo 'log_begin_msg_post () { :; }' >> $initfunctions
echo 'log_end_msg_pre () { :; }' >> $initfunctions
echo 'log_end_msg_post () { :; }' >> $initfunctions
echo 'log_action_msg_pre () { :; }' >> $initfunctions
echo 'log_action_msg_post () { :; }' >> $initfunctions
echo 'log_action_begin_msg_pre () { :; }' >> $initfunctions
echo 'log_action_begin_msg_post () { :; }' >> $initfunctions
echo 'log_action_end_msg_pre () { :; }' >> $initfunctions
echo 'log_action_end_msg_post () { :; }' >> $initfunctions
echo '' >> $initfunctions
echo '# Include hooks from other packages in /lib/lsb/init-functions.d' >> $initfunctions
echo 'for hook in $(run-parts --lsbsysinit --list /lib/lsb/init-functions.d 2>/dev/null); do' >> $initfunctions
echo '    [ -r $hook ] && . $hook || true' >> $initfunctions
echo 'done' >> $initfunctions
echo '' >> $initfunctions
echo 'FANCYTTY=' >> $initfunctions
echo '[ -e /etc/lsb-base-logging.sh ] && . /etc/lsb-base-logging.sh || true' >> $initfunctions
echo '' >> $initfunctions

############################
#Create init-functions.d Directory
############################

if [ ! -d "$initfunctionsd" ] ; then
	mkdir -p $userlibrary/lib/lsb
fi

############################
#Create init-functions.d 20-left-info-blocks
############################

if [ -e "$initfunctionsd1" ] ; then
	rm -r $initfunctionsd1
	touch $initfunctionsd1
fi

echo '# Default info blocks put to the left of the screen' >> $initfunctionsd1
echo 'log_daemon_msg_pre () {' >> $initfunctionsd1
echo '    if log_use_fancy_output; then' >> $initfunctionsd1
echo '        echo -n "[....] " || true' >> $initfunctionsd1
echo '    fi' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo 'log_begin_msg_pre () {' >> $initfunctionsd1
echo '    log_daemon_msg_pre "$@"' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo 'log_end_msg_pre () {' >> $initfunctionsd1
echo '    if log_use_fancy_output; then' >> $initfunctionsd1
echo '        RED=$( $TPUT setaf 1)' >> $initfunctionsd1
echo '        GREEN=$( $TPUT setaf 2)' >> $initfunctionsd1
echo '        YELLOW=$( $TPUT setaf 3)' >> $initfunctionsd1
echo '        NORMAL=$( $TPUT op)' >> $initfunctionsd1
echo '' >> $initfunctionsd1
echo '        $TPUT civis || true' >> $initfunctionsd1
echo '        $TPUT sc && \' >> $initfunctionsd1
echo '        $TPUT hpa 0 && \' >> $initfunctionsd1
echo '        if [ $1 -eq 0 ]; then' >> $initfunctionsd1
echo '            /bin/echo -ne "[${GREEN} ok ${NORMAL}" || true' >> $initfunctionsd1
echo '        elif [ $1 -eq 255 ]; then' >> $initfunctionsd1
echo '            /bin/echo -ne "[${YELLOW}warn${NORMAL}" || true' >> $initfunctionsd1
echo '        else' >> $initfunctionsd1
echo '            /bin/echo -ne "[${RED}FAIL${NORMAL}" || true' >> $initfunctionsd1
echo '        fi && \' >> $initfunctionsd1
echo '        $TPUT rc || true' >> $initfunctionsd1
echo '        $TPUT cnorm || true' >> $initfunctionsd1
echo '    fi' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo 'log_action_msg_pre () {' >> $initfunctionsd1
echo '    if log_use_fancy_output; then' >> $initfunctionsd1
echo '        CYAN=$( $TPUT setaf 6)' >> $initfunctionsd1
echo '        NORMAL=$( $TPUT op)' >> $initfunctionsd1
echo '        /bin/echo -ne "[${CYAN}info${NORMAL}] " || true' >> $initfunctionsd1
echo '    fi' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo 'log_action_begin_msg_pre () {' >> $initfunctionsd1
echo '    log_daemon_msg_pre "$@"' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo 'log_action_end_msg_pre () {' >> $initfunctionsd1
echo '    log_end_msg_pre "$@"' >> $initfunctionsd1
echo '}' >> $initfunctionsd1
echo '' >> $initfunctionsd1

############################
#Create init-functions.d 40-systemd
############################

if [ -e "$initfunctionsd2" ] ; then
	rm -r $initfunctionsd2
	touch $initfunctionsd2
fi

echo '# -*-Shell-script-*-' >> $initfunctionsd2
echo '# /lib/lsb/init-functions' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '_use_systemctl=0' >> $initfunctionsd2
echo 'if [ -d /run/systemd/system ]; then' >> $initfunctionsd2
echo  '' >>  $initfunctionsd2
echo '    if [ -n "${__init_d_script_name:-}" ]; then # scripts run with new init-d-script' >> $initfunctionsd2
echo '        executable="$__init_d_script_name"' >> $initfunctionsd2
echo '        argument="$1"' >> $initfunctionsd2
echo '    elif [ "${0##*/}" = "init-d-script" ] ||' >> $initfunctionsd2
echo '         [ "${0##*/}" = "${1:-}" ]; then # scripts run with old init-d-script' >> $initfunctionsd2
echo '        executable="$1"' >> $initfunctionsd2
echo '        argument="$2"' >> $initfunctionsd2
echo '    else # plain old scripts' >> $initfunctionsd2
echo '        executable="$0"' >> $initfunctionsd2
echo '        argument="${1:-}"' >> $initfunctionsd2
echo '    fi' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    prog=${executable##*/}' >> $initfunctionsd2
echo '    service="${prog%.sh}.service"' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    # Dont try to run masked services. systemctl <= 230 always succeeds here,' >> $initfunctionsd2
echo '    # but later systemctls fail on nonexisting units; be compatible with both' >> $initfunctionsd2
echo '    state=$(systemctl -p LoadState --value show $service 2>/dev/null) || state="not-found"' >> $initfunctionsd2
echo '    [ "$state" = "masked" ] && exit 0' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    # Redirect SysV init scripts when executed by the user' >> $initfunctionsd2
echo '    if [ $PPID -ne 1 ] && [ -z "${SYSTEMCTL_SKIP_REDIRECT:-}" ]; then' >> $initfunctionsd2
echo '        case $(readlink -f "$executable") in' >> $initfunctionsd2
echo '            /etc/init.d/*)' >> $initfunctionsd2
echo '                # If the state is not-found, this might be a newly installed SysV init' >> $initfunctionsd2
echo '                # script where systemd-sysv-generator has not been run yet.' >> $initfunctionsd2
echo '                [ "$state" != "not-found" ] || [ "$(id -u)" != 0 ] || systemctl --no-ask-password daemon-reload' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '                _use_systemctl=1' >> $initfunctionsd2
echo '                # Some services cant reload through the .service file,' >> $initfunctionsd2
echo '                # but can through the init script.' >> $initfunctionsd2
echo '                if [ "$(systemctl -p CanReload --value show $service 2>/dev/null)" = "no" ] && [ "${argument:-}" = "reload" ]; then' >> $initfunctionsd2
echo '                    _use_systemctl=0' >> $initfunctionsd2
echo '                fi' >> $initfunctionsd2
echo '                ;;' >> $initfunctionsd2
echo '        esac' >> $initfunctionsd2
echo '    fi' >> $initfunctionsd2
echo 'fi' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo 'systemctl_redirect () {' >> $initfunctionsd2
echo '    local s' >> $initfunctionsd2
echo '    local rc' >> $initfunctionsd2
echo '    local prog=${1##*/}' >> $initfunctionsd2
echo '    local command=$2' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    case "$command" in' >> $initfunctionsd2
echo '        start)' >> $initfunctionsd2
echo '            s="Starting $prog (via systemctl)"' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '        stop)' >> $initfunctionsd2
echo '            s="Stopping $prog (via systemctl)"' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '        reload|force-reload)' >> $initfunctionsd2
echo '            s="Reloading $prog configuration (via systemctl)"' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '        try-restart)' >> $initfunctionsd2
echo '            s="Restarting $prog if running (via systemctl)"' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '        restart)' >> $initfunctionsd2
echo '            s="Restarting $prog (via systemctl)"' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '    esac' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    service="${prog%.sh}.service"' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    # avoid deadlocks during bootup and shutdown from units/hooks' >> $initfunctionsd2
echo '    # which call "invoke-rc.d service reload" and similar, since' >> $initfunctionsd2
echo '    # the synchronous wait plus systemds normal behaviour of' >> $initfunctionsd2
echo '    # transactionally processing all dependencies first easily' >> $initfunctionsd2
echo '    # causes dependency loops' >> $initfunctionsd2
echo '    if ! OUT=$(systemctl is-system-running 2>/dev/null) && [ "$OUT" != "degraded" ]; then' >> $initfunctionsd2
echo '        sctl_args="--job-mode=ignore-dependencies"' >> $initfunctionsd2
echo '    fi' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    [ "$command" = status ] || log_daemon_msg "$s" "$service"' >> $initfunctionsd2
echo '    /bin/systemctl --no-pager $sctl_args $command "$service"' >> $initfunctionsd2
echo '    rc=$?' >> $initfunctionsd2
echo '    [ "$command" = status ] || log_end_msg $rc' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    return $rc' >> $initfunctionsd2
echo '}' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo 'if [ "$_use_systemctl" = "1" ]; then' >> $initfunctionsd2
echo '    # Some init scripts use "set -e" and "set -u", we dont want that' >> $initfunctionsd2
echo '    # here' >> $initfunctionsd2
echo '    set +e' >> $initfunctionsd2
echo '    set +u' >> $initfunctionsd2
echo '' >> $initfunctionsd2
echo '    case "$argument" in' >> $initfunctionsd2
echo '        start|stop|restart|reload|force-reload|try-restart|status)' >> $initfunctionsd2
echo '            systemctl_redirect $executable $argument' >> $initfunctionsd2
echo '            exit $?' >> $initfunctionsd2
echo '            ;;' >> $initfunctionsd2
echo '    esac' >> $initfunctionsd2
echo 'fi' >> $initfunctionsd2
echo '' >> $initfunctionsd2


############################
#Create init-functions.d 99-plymouth
############################

if [ -e "$initfunctionsd3" ] ; then
	rm -r $initfunctionsd3
	touch $initfunctionsd3
fi

echo '# /lib/lsb/init-functions.d/99-plymouth' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo '# Abort sourcing of this file if plymouth isnt active' >> $initfunctionsd3
echo 'if ! plymouth --ping > /dev/null 2>&1' >> $initfunctionsd3
echo 'then' >> $initfunctionsd3
echo '	return' >> $initfunctionsd3
echo 'fi' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_begin_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	/bin/plymouth update --status="${@}" || true' >> $initfunctionsd3
echo ' }' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_end_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	:' >> $initfunctionsd3
echo '}' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_action_begin_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	/bin/plymouth update --status="${@}" || true' >> $initfunctionsd3
echo '}' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_action_end_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	:' >> $initfunctionsd3
echo '}' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_action_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	/bin/plymouth update --status="${@}" || true' >> $initfunctionsd3
echo '}' >> $initfunctionsd3
echo '' >> $initfunctionsd3
echo 'log_daemon_msg_post ()' >> $initfunctionsd3
echo '{' >> $initfunctionsd3
echo '	/bin/plymouth update --status="${@}" || true' >> $initfunctionsd3
echo '}' >> $initfunctionsd3
echo '' >> $initfunctionsd3

################################################################
################## Install Daemon and Service ##################
################################################################

. /storage/user/lib/lsb/init-functions
daemonname="deskpi"
daemonconfig=/storage/user/bin/deskpi-config
shutdaemonscript=/storage/.config/$daemonname-safeshut.service
deskpidaemon=/storage/.config/$daemonname.service
pwmdriver=/storage/user/bin/pwmFanControl

################################################################

log_action_msg "DeskPi Fan control script installation Start." 
###Check for Previous install####


############################
######Check Boot Mode######
############################

log_action_msg "Check Boot Mode"

PIINFO=$(cat /flash/config.txt | grep 'otg_mode=1,dtoverlay=dwc2,dr_mode=host')
if [ -z "$PIINFO" ]
then
	mount -o remount,rw /flash
	echo "otg_mode=1,dtoverlay=dwc2,dr_mode=host" >> /flash/config.txt
	mount -o remount,ro /flash
fi

############################
####Create deskpi-config####
############################

log_action_msg "Create deskpi-config"

if [ -e $deskpidaemon ]; then
	rm -f $deskpidaemon
	touch /storage/.config/system.d/$daemonname.service
fi

echo '#!/bin/bash' >> $daemonconfig
echo '# This is a fan speed control utility tool for user to customize fan speed.' >> $daemonconfig
echo '# Priciple: send speed argument to the MCU' >> $daemonconfig
echo '# Technical Part' >> $daemonconfig
echo '# There are four arguments:' >> $daemonconfig
echo '# pwm_025 means sending 25% PWM signal to MCU. The fan will run at 25% speed level.' >> $daemonconfig
echo '# pwm_050 means sending 50% PWM signal to MCU. The fan will run at 50% speed level.' >> $daemonconfig
echo '# pwm_075 means sending 75% PWM signal to MCU. The fan will run at 75% speed level.' >> $daemonconfig
echo '# pwm_100 means sending 100% PWM signal to MCU.The fan will run at 100% speed level.' >> $daemonconfig
echo '#' >> $daemonconfig
echo '# This is the serial port that connect to deskPi mainboard and it will' >> $daemonconfig
echo '# communicate with Raspberry Pi and get the signal for fan speed adjusting.' >> $daemonconfig
echo '. /storage/user/lib/lsb/init-functions' >> $daemonconfig
echo 'sys='storage/.kodi/addons/virtual.rpi.tools/lib'' >> $daemonconfig
echo 'serial='/storage/.kodi/addons/script.module.pyserial/lib/'' >> $daemonconfig
echo 'serial_port='/dev/ttyUSB0'' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Stop deskpi.service so that user can define the speed level.' >> $daemonconfig
echo 'systemctl stop deskpi.service' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Define the function of set_config' >> $daemonconfig
echo 'function set_config() {' >> $daemonconfig
echo '	if [ -e /storage/user/bin/deskpi.conf ]; then' >> $daemonconfig
echo '		sh -c "rm -f /storage/user/bin/deskpi.conf"' >> $daemonconfig
echo '	fi' >> $daemonconfig
echo '	touch /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	chmod 777 /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	log_action_msg "Under normal circumstances, we recommend four gears. The' >> $daemonconfig
echo '	following requires you to control the fans operating status according to' >> $daemonconfig
echo '	the temperature and speed defined by yourself, and you need to input 4' >> $daemonconfig
echo '	different temperature thresholds (for example: 42, 50, 60, 70) , And 4 PWM' >> $daemonconfig
echo '	values of different speeds parameters(for example 25, 50, 75, 100, this is the default' >> $daemonconfig
echo '	value),you can define the speed level during 0-100."' >> $daemonconfig
echo '	for i in `seq 1 4`;' >> $daemonconfig
echo '	do' >> $daemonconfig
echo '	echo -e "\e[32;40mCurrent CPU Temperature:\e[0m \e[31;40m`vcgencmd measure_temp`\e[0m\n"' >> $daemonconfig
echo '	read -p  "Temperature_threshold_$i:" temp' >> $daemonconfig
echo '        read -p  "Fan_Speed level_$i:" fan_speed_level' >> $daemonconfig
echo '	sh -c "echo $temp" >> /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	sh -c "echo $fan_speed_level" >> /storage/user/bin/deskpi.conf' >> $daemonconfig
echo '	done ' >> $daemonconfig
echo '	log_action_msg "Configuration file has been created on /storage/user/bin/deskpi.conf"' >> $daemonconfig
echo '}' >> $daemonconfig
echo '' >> $daemonconfig
echo '# Greetings and information for user.' >> $daemonconfig
echo 'log_action_msg "Welcome to Use DeskPi-Teams Product"' >> $daemonconfig
echo 'log_action_msg "Please select speed level that you want: "' >> $daemonconfig
echo 'log_action_msg "It will always run at the speed level that you choosed."' >> $daemonconfig
echo 'log_action_msg "---------------------------------------------------------------"' >> $daemonconfig
echo 'log_action_msg "1 - set fan speed level to 25%"' >> $daemonconfig
echo 'log_action_msg "2 - set fan speed level to 50%"' >> $daemonconfig
echo 'log_action_msg "3 - set fan speed level to 75%"' >> $daemonconfig
echo 'log_action_msg "4 - set fan speed level to 100%"' >> $daemonconfig
echo 'log_action_msg "5 - Turn off Fan"' >> $daemonconfig
echo 'log_action_msg "6 - Adjust the start speed level according to the temperature"' >> $daemonconfig
echo 'log_action_msg "7 - Cancel manual control and enable automatical fan control"' >> $daemonconfig
echo 'log_action_msg "---------------------------------------------------------------"' >> $daemonconfig
echo 'log_action_msg "Just input the number and press enter."' >> $daemonconfig
echo 'read -p "Your choice:" levelNumber' >> $daemonconfig
echo 'case $levelNumber in' >> $daemonconfig
echo '	1) ' >> $daemonconfig
echo '	   log_action_msg "Youve select 25% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_025 > $serial_port"' >> $daemonconfig
echo '	   log_action_msg "Fan speed level has been change to 25%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	2) ' >> $daemonconfig
echo '	   log_action_msg "Youve select 50% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_050 > $serial_port"' >> $daemonconfig
echo '	   log_action_msg "Fan speed level has been change to 50%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	3) ' >> $daemonconfig
echo '	   log_action_msg "Youve select 75% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_075 > $serial_port"' >> $daemonconfig
echo '	   log_action_msg "Fan speed level has been change to 75%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	4) ' >> $daemonconfig
echo '	   log_action_msg "Youtve select 100% speed level"' >> $daemonconfig
echo '	   sh -c "echo pwm_100 > $serial_port"' >> $daemonconfig
echo '	   log_action_msg "Fan speed level has been change to 100%"' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	5) ' >> $daemonconfig
echo '	   log_action_msg "Turn off fan"' >> $daemonconfig
echo '	   sh -c "echo pwm_000 > $serial_port"' >> $daemonconfig
echo '	   log_action_msg "Fan speed level has been turned off."' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	6) ' >> $daemonconfig
echo '	   log_action_msg "Customizing the start speed level according the temperature"' >> $daemonconfig
echo '	   systemctl stop deskpi.service & ' >> $daemonconfig
echo '	   set_config' >> $daemonconfig
echo '	   systemctl start deskpi.service & ' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	7) ' >> $daemonconfig
echo '	   log_action_msg "Cancel manual control and enable automatical fan control"' >> $daemonconfig
echo '	   systemctl start deskpi.service &' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo '	*) ' >> $daemonconfig
echo '	   log_action_msg "You type the wrong selection, please try again!"' >> $daemonconfig
echo '	   . /storage/user/bin/deskpi-config' >> $daemonconfig
echo '	   ;;' >> $daemonconfig
echo 'esac' >> $daemonconfig
echo '' >> $daemonconfig

############################
####Create Driver Daemon####
############################

log_action_msg "Create Driver Daemon"

#cp -rf $installationfolder/drivers/fanStop  /storage/user/bin/
#chmod 755 /storage/user/bin/fanStop

chmod 755 /storage/user/bin/pwmFanControl
cp -rf $installationfolder/drivers/pwmFanControl /storage/user/bin/

if [ -e $pwmdriver ]; then
	rm -f $pwmdriver
	touch $/storage/user/bin/pwmFanControl
fi

echo '7f45 4c46 0101 0100 0000 0000 0000 0000' >> $pwmdriver
echo '0200 2800 0100 0000 9c06 0100 3400 0000' >> $pwmdriver
echo '281e 0000 0004 0005 3400 2000 0900 2800' >> $pwmdriver
echo '1d00 1c00 0100 0070 bc0e 0000 bc0e 0100' >> $pwmdriver
echo 'bc0e 0100 0800 0000 0800 0000 0400 0000' >> $pwmdriver
echo '0400 0000 0600 0000 3400 0000 3400 0100' >> $pwmdriver
echo '3400 0100 2001 0000 2001 0000 0400 0000' >> $pwmdriver
echo '0400 0000 0300 0000 5401 0000 5401 0100' >> $pwmdriver
echo '5401 0100 1900 0000 1900 0000 0400 0000' >> $pwmdriver
echo '0100 0000 0100 0000 0000 0000 0000 0100' >> $pwmdriver
echo '0000 0100 c80e 0000 c80e 0000 0500 0000' >> $pwmdriver
echo '0000 0100 0100 0000 100f 0000 100f 0200' >> $pwmdriver
echo '100f 0200 5c01 0000 6401 0000 0600 0000' >> $pwmdriver
echo '0000 0100 0200 0000 180f 0000 180f 0200' >> $pwmdriver
echo '180f 0200 e800 0000 e800 0000 0600 0000' >> $pwmdriver
echo '0400 0000 0400 0000 7001 0000 7001 0100' >> $pwmdriver
echo '7001 0100 4400 0000 4400 0000 0400 0000' >> $pwmdriver
echo '0400 0000 51e5 7464 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0600 0000' >> $pwmdriver
echo '1000 0000 52e5 7464 100f 0000 100f 0200' >> $pwmdriver
echo '100f 0200 f000 0000 f000 0000 0400 0000' >> $pwmdriver
echo '0100 0000 2f6c 6962 2f6c 642d 6c69 6e75' >> $pwmdriver
echo '782d 6172 6d68 662e 736f 2e33 0000 0000' >> $pwmdriver
echo '0400 0000 1000 0000 0100 0000 474e 5500' >> $pwmdriver
echo '0000 0000 0300 0000 0200 0000 0000 0000' >> $pwmdriver
echo '0400 0000 1400 0000 0300 0000 474e 5500' >> $pwmdriver
echo 'c185 55c1 b7f4 d4e3 ba6d 4ee3 0a4b 2e2f' >> $pwmdriver
echo '0dda b133 1100 0000 0200 0000 0400 0000' >> $pwmdriver
echo '0700 0000 4319 c245 0240 8151 4004 9109' >> $pwmdriver
echo '0840 c425 0000 0000 0200 0000 0000 0000' >> $pwmdriver
echo '0500 0000 0800 0000 0000 0000 0a00 0000' >> $pwmdriver
echo '0b00 0000 0000 0000 0d00 0000 0f00 0000' >> $pwmdriver
echo '1000 0000 1100 0000 1200 0000 0000 0000' >> $pwmdriver
echo '1300 0000 0000 0000 62ac 61a0 76d7 9b7c' >> $pwmdriver
echo '31b8 820d 7c8b 730f 50b5 a810 7ded 110f' >> $pwmdriver
echo '54cc 0a83 733c 947c 2f4e 3df6 9efb 6e0f' >> $pwmdriver
echo '0123 f9a4 20cf 09fd 57d3 a604 1ff6 5c10' >> $pwmdriver
echo '09ac f98f 117b 9c7c 5b9a 3b0f b82b 6b15' >> $pwmdriver
echo '1ac0 0991 0b0f b5a5 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 ab00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 2000 0000 4e00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 1400 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 3600 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 1300 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 9b00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 1e00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 2400 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 5f00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 8900 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 3000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 3d00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 5800 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 6400 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 6e00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 8000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 1900 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 5900 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 0c00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 7400 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 0b00 0000 0000 0000' >> $pwmdriver
echo '0000 0000 1200 0000 006c 6962 632e 736f' >> $pwmdriver
echo '2e36 0073 7072 696e 7466 0066 6f70 656e' >> $pwmdriver
echo '0070 7574 7300 6162 6f72 7400 6366 7365' >> $pwmdriver
echo '7469 7370 6565 6400 6667 6574 7300 6d65' >> $pwmdriver
echo '6d73 6574 005f 5f65 7272 6e6f 5f6c 6f63' >> $pwmdriver
echo '6174 696f 6e00 7463 7365 7461 7474 7200' >> $pwmdriver
echo '6663 6c6f 7365 0061 746f 6900 7463 6765' >> $pwmdriver
echo '7461 7474 7200 736c 6565 7000 6366 7365' >> $pwmdriver
echo '746f 7370 6565 6400 7374 7265 7272 6f72' >> $pwmdriver
echo '005f 5f6c 6962 635f 7374 6172 745f 6d61' >> $pwmdriver
echo '696e 0077 7269 7465 0047 4c49 4243 5f32' >> $pwmdriver
echo '2e34 005f 5f67 6d6f 6e5f 7374 6172 745f' >> $pwmdriver
echo '5f00 0000 0000 0200 0200 0200 0200 0200' >> $pwmdriver
echo '0200 0200 0200 0200 0200 0200 0200 0200' >> $pwmdriver
echo '0200 0200 0200 0200 0200 0200 0200 0000' >> $pwmdriver
echo '0100 0100 0100 0000 1000 0000 0000 0000' >> $pwmdriver
echo '1469 690d 0000 0200 a100 0000 0000 0000' >> $pwmdriver
echo '6010 0200 1501 0000 0c10 0200 1613 0000' >> $pwmdriver
echo '1010 0200 1605 0000 1410 0200 160b 0000' >> $pwmdriver
echo '1810 0200 160f 0000 1c10 0200 1614 0000' >> $pwmdriver
echo '2010 0200 1602 0000 2410 0200 1611 0000' >> $pwmdriver
echo '2810 0200 160a 0000 2c10 0200 1610 0000' >> $pwmdriver
echo '3010 0200 1601 0000 3410 0200 1603 0000' >> $pwmdriver
echo '3810 0200 1608 0000 3c10 0200 160c 0000' >> $pwmdriver
echo '4010 0200 1604 0000 4410 0200 1606 0000' >> $pwmdriver
echo '4810 0200 160d 0000 4c10 0200 1615 0000' >> $pwmdriver
echo '5010 0200 1609 0000 5410 0200 1607 0000' >> $pwmdriver
echo '5810 0200 1612 0000 5c10 0200 160e 0000' >> $pwmdriver
echo '0840 2de9 5300 00eb 0880 bde8 04e0 2de5' >> $pwmdriver
echo '04e0 9fe5 0ee0 8fe0 08f0 bee5 640a 0100' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 64fa bce5 00c6 8fe2' >> $pwmdriver
echo '10ca 8ce2 5cfa bce5 00c6 8fe2 10ca 8ce2' >> $pwmdriver
echo '54fa bce5 00c6 8fe2 10ca 8ce2 4cfa bce5' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 44fa bce5 00c6 8fe2' >> $pwmdriver
echo '10ca 8ce2 3cfa bce5 00c6 8fe2 10ca 8ce2' >> $pwmdriver
echo '34fa bce5 00c6 8fe2 10ca 8ce2 2cfa bce5' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 24fa bce5 00c6 8fe2' >> $pwmdriver
echo '10ca 8ce2 1cfa bce5 00c6 8fe2 10ca 8ce2' >> $pwmdriver
echo '14fa bce5 00c6 8fe2 10ca 8ce2 0cfa bce5' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 04fa bce5 00c6 8fe2' >> $pwmdriver
echo '10ca 8ce2 fcf9 bce5 00c6 8fe2 10ca 8ce2' >> $pwmdriver
echo 'f4f9 bce5 00c6 8fe2 10ca 8ce2 ecf9 bce5' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 e4f9 bce5 00c6 8fe2' >> $pwmdriver
echo '10ca 8ce2 dcf9 bce5 00c6 8fe2 10ca 8ce2' >> $pwmdriver
echo 'd4f9 bce5 00c6 8fe2 10ca 8ce2 ccf9 bce5' >> $pwmdriver
echo '00c6 8fe2 10ca 8ce2 c4f9 bce5 00b0 a0e3' >> $pwmdriver
echo '00e0 a0e3 0410 9de4 0d20 a0e1 0420 2de5' >> $pwmdriver
echo '0400 2de5 10c0 9fe5 04c0 2de5 0c00 9fe5' >> $pwmdriver
echo '0c30 9fe5 caff ffeb eaff ffeb 6c0d 0100' >> $pwmdriver
echo 'b00a 0100 0c0d 0100 1430 9fe5 1420 9fe5' >> $pwmdriver
echo '0330 8fe0 0220 93e7 0000 52e3 1eff 2f01' >> $pwmdriver
echo 'c5ff ffea 1809 0100 6000 0000 1800 9fe5' >> $pwmdriver
echo '1830 9fe5 0000 53e1 1eff 2f01 1030 9fe5' >> $pwmdriver
echo '0000 53e3 1eff 2f01 13ff 2fe1 6c10 0200' >> $pwmdriver
echo '6c10 0200 0000 0000 2400 9fe5 2410 9fe5' >> $pwmdriver
echo '0010 41e0 4111 a0e1 a11f 81e0 c110 b0e1' >> $pwmdriver
echo '1eff 2f01 1030 9fe5 0000 53e3 1eff 2f01' >> $pwmdriver
echo '13ff 2fe1 6c10 0200 6c10 0200 0000 0000' >> $pwmdriver
echo '1040 2de9 1840 9fe5 0030 d4e5 0000 53e3' >> $pwmdriver
echo '1080 bd18 e0ff ffeb 0130 a0e3 0030 c4e5' >> $pwmdriver
echo '1080 bde8 6c10 0200 e6ff ffea 0048 2de9' >> $pwmdriver
echo '04b0 8de2 48d0 4de2 4800 0be5 0210 a0e3' >> $pwmdriver
echo '4800 1be5 9bff ffeb 0020 a0e1 c431 9fe5' >> $pwmdriver
echo '0020 83e5 bc31 9fe5 0030 93e5 0000 53e3' >> $pwmdriver
echo '0a00 00aa 99ff ffeb 0030 a0e1 0030 93e5' >> $pwmdriver
echo '0300 a0e1 89ff ffeb 0030 a0e1 0310 a0e1' >> $pwmdriver
echo '9401 9fe5 6dff ffeb 9001 9fe5 7dff ffeb' >> $pwmdriver
echo '8031 9fe5 0030 93e5 4020 4be2 0210 a0e1' >> $pwmdriver
echo '0300 a0e1 a1ff ffeb 0030 a0e1 0000 53e3' >> $pwmdriver
echo '0100 000a 6801 9fe5 72ff ffeb 3830 1be5' >> $pwmdriver
echo '013c c3e3 3830 0be5 3830 1be5 013c 83e3' >> $pwmdriver
echo '3830 0be5 3830 1be5 4030 c3e3 3830 0be5' >> $pwmdriver
echo '3830 1be5 4030 83e3 3830 0be5 3830 1be5' >> $pwmdriver
echo '3830 0be5 3830 1be5 1030 83e3 3830 0be5' >> $pwmdriver
echo '3830 1be5 2030 83e3 3830 0be5 3830 1be5' >> $pwmdriver
echo '3030 83e3 3830 0be5 3830 1be5 0231 c3e3' >> $pwmdriver
echo '3830 0be5 3830 1be5 0231 83e3 3830 0be5' >> $pwmdriver
echo '3830 1be5 223d 83e3 3830 0be5 3430 1be5' >> $pwmdriver
echo '0230 c3e3 3430 0be5 3430 1be5 0830 c3e3' >> $pwmdriver
echo '3430 0be5 3430 1be5 1030 c3e3 3430 0be5' >> $pwmdriver
echo '3430 1be5 4030 c3e3 3430 0be5 3430 1be5' >> $pwmdriver
echo '0130 c3e3 3430 0be5 4030 1be5 073b c3e3' >> $pwmdriver
echo '4030 0be5 4030 1be5 7a3f c3e3 0330 c3e3' >> $pwmdriver
echo '4030 0be5 3c30 1be5 0130 c3e3 3c30 0be5' >> $pwmdriver
echo '3c30 1be5 0430 c3e3 3c30 0be5 0a30 a0e3' >> $pwmdriver
echo '2a30 4be5 0030 a0e3 2930 4be5 4030 4be2' >> $pwmdriver
echo '0d10 a0e3 0300 a0e1 3dff ffeb 4030 4be2' >> $pwmdriver
echo '0d10 a0e3 0300 a0e1 24ff ffeb 3430 9fe5' >> $pwmdriver
echo '0030 93e5 4020 4be2 0010 a0e3 0300 a0e1' >> $pwmdriver
echo '21ff ffeb 0030 a0e1 0000 53e3 0100 000a' >> $pwmdriver
echo '2000 9fe5 1fff ffeb 0030 a0e3 0300 a0e1' >> $pwmdriver
echo '04d0 4be2 0088 bde8 7010 0200 7c0d 0100' >> $pwmdriver
echo 'b40d 0100 100e 0100 340e 0100 0048 2de9' >> $pwmdriver
echo '04b0 8de2 08d0 4de2 0800 0be5 0c10 0be5' >> $pwmdriver
echo '2030 9fe5 0030 93e5 0c20 1be5 0810 1be5' >> $pwmdriver
echo '0300 a0e1 23ff ffeb 0030 a0e1 0300 a0e1' >> $pwmdriver
echo '04d0 4be2 0088 bde8 7010 0200 0048 2de9' >> $pwmdriver
echo '04b0 8de2 1430 9fe5 0030 93e5 0300 a0e1' >> $pwmdriver
echo '27ff ffeb 0030 a0e1 0300 a0e1 0088 bde8' >> $pwmdriver
echo '7010 0200 0048 2de9 04b0 8de2 42df 4de2' >> $pwmdriver
echo '0030 a0e3 0c30 0be5 0030 a0e3 0830 0be5' >> $pwmdriver
echo '433f 4be2 0300 a0e1 ff30 a0e3 0320 a0e1' >> $pwmdriver
echo '0010 a0e3 04ff ffeb 7410 9fe5 7400 9fe5' >> $pwmdriver
echo 'ddfe ffeb 0c00 0be5 0c30 1be5 0000 53e3' >> $pwmdriver
echo '1300 000a 433f 4be2 0c20 1be5 ff10 a0e3' >> $pwmdriver
echo '0300 a0e1 d7fe ffeb 0030 a0e1 0000 53e3' >> $pwmdriver
echo '0900 000a 433f 4be2 0300 a0e1 fefe ffeb' >> $pwmdriver
echo '0030 a0e1 3020 9fe5 9213 c2e0 4223 a0e1' >> $pwmdriver
echo 'c33f a0e1 0330 42e0 0830 0be5 0c00 1be5' >> $pwmdriver
echo 'effe ffeb 0830 1be5 0300 a0e1 04d0 4be2' >> $pwmdriver
echo '0088 bde8 580e 0100 5c0e 0100 d34d 6210' >> $pwmdriver
echo '0048 2de9 04b0 8de2 98d0 4de2 0030 a0e3' >> $pwmdriver
echo '0830 0be5 0030 a0e3 0c30 0be5 7430 4be2' >> $pwmdriver
echo '0300 a0e1 6430 a0e3 0320 a0e1 0010 a0e3' >> $pwmdriver
echo 'd5fe ffeb 7c30 4be2 0020 a0e3 0020 83e5' >> $pwmdriver
echo '0420 83e5 0030 a0e3 1030 0be5 f401 9fe5' >> $pwmdriver
echo '21ff ffeb 2830 a0e3 9c30 0be5 1930 a0e3' >> $pwmdriver
echo '9830 0be5 3230 a0e3 9430 0be5 3230 a0e3' >> $pwmdriver
echo '9030 0be5 4130 a0e3 8c30 0be5 4b30 a0e3' >> $pwmdriver
echo '8830 0be5 4b30 a0e3 8430 0be5 6430 a0e3' >> $pwmdriver
echo '8030 0be5 b011 9fe5 b001 9fe5 96fe ffeb' >> $pwmdriver
echo '0c00 0be5 0c30 1be5 0000 53e3 2000 000a' >> $pwmdriver
echo '0030 a0e3 0830 0be5 1a00 00ea 7430 4be2' >> $pwmdriver
echo '0300 a0e1 6430 a0e3 0320 a0e1 0010 a0e3' >> $pwmdriver
echo 'adfe ffeb 7430 4be2 0c20 1be5 6410 a0e3' >> $pwmdriver
echo '0300 a0e1 87fe ffeb 0030 a0e1 0000 53e3' >> $pwmdriver
echo '0900 000a 7430 4be2 0300 a0e1 aefe ffeb' >> $pwmdriver
echo '0030 a0e1 0320 a0e1 0830 1be5 0331 a0e1' >> $pwmdriver
echo '0410 4be2 0330 81e0 9820 03e5 0830 1be5' >> $pwmdriver
echo '0130 83e2 0830 0be5 0830 1be5 0700 53e3' >> $pwmdriver
echo 'e1ff ffda 82ff ffeb 1000 0be5 9c30 1be5' >> $pwmdriver
echo '1020 1be5 0300 52e1 0400 002a 0021 9fe5' >> $pwmdriver
echo '7c30 4be2 0300 92e8 0300 83e8 3200 00ea' >> $pwmdriver
echo '9c30 1be5 1020 1be5 0300 52e1 0900 003a' >> $pwmdriver
echo '9430 1be5 1020 1be5 0300 52e1 0500 002a' >> $pwmdriver
echo '9820 1be5 7c30 4be2 c810 9fe5 0300 a0e1' >> $pwmdriver
echo '86fe ffeb 2400 00ea 9430 1be5 1020 1be5' >> $pwmdriver
echo '0300 52e1 0900 003a 8c30 1be5 1020 1be5' >> $pwmdriver
echo '0300 52e1 0500 002a 9020 1be5 7c30 4be2' >> $pwmdriver
echo '9010 9fe5 0300 a0e1 78fe ffeb 1600 00ea' >> $pwmdriver
echo '8c30 1be5 1020 1be5 0300 52e1 0900 003a' >> $pwmdriver
echo '8430 1be5 1020 1be5 0300 52e1 0500 002a' >> $pwmdriver
echo '8820 1be5 7c30 4be2 5810 9fe5 0300 a0e1' >> $pwmdriver
echo '6afe ffeb 0800 00ea 8430 1be5 1020 1be5' >> $pwmdriver
echo '0300 52e1 0400 003a 8020 1be5 7c30 4be2' >> $pwmdriver
echo '3010 9fe5 0300 a0e1 60fe ffeb 7c30 4be2' >> $pwmdriver
echo '0810 a0e3 0300 a0e1 27ff ffeb 0100 a0e3' >> $pwmdriver
echo '33fe ffeb 92ff ffea 840e 0100 580e 0100' >> $pwmdriver
echo '940e 0100 a80e 0100 b00e 0100 f047 2de9' >> $pwmdriver
echo '0070 a0e1 4860 9fe5 4850 9fe5 0660 8fe0' >> $pwmdriver
echo '0550 8fe0 0560 46e0 0180 a0e1 0290 a0e1' >> $pwmdriver
echo '12fe ffeb 4661 b0e1 f087 bd08 0040 a0e3' >> $pwmdriver
echo '0140 84e2 0430 95e4 0920 a0e1 0810 a0e1' >> $pwmdriver
echo '0700 a0e1 33ff 2fe1 0400 56e1 f7ff ff1a' >> $pwmdriver
echo 'f087 bde8 f001 0100 e801 0100 1eff 2fe1' >> $pwmdriver
echo '0840 2de9 0880 bde8 0100 0200 4361 6e20' >> $pwmdriver
echo '6e6f 7420 6f70 656e 202f 6465 762f 7474' >> $pwmdriver
echo '7955 5342 3020 7365 7269 616c 2070 6f72' >> $pwmdriver
echo '7420 4572 726f 7243 6f64 653a 2025 730a' >> $pwmdriver
echo '0000 0000 506c 6561 7365 2063 6865 636b' >> $pwmdriver
echo '2074 6865 202f 626f 6f74 2f63 6f6e 6669' >> $pwmdriver
echo '672e 7478 7420 6669 6c65 2061 6e64 2061' >> $pwmdriver
echo '6464 2064 746f 7665 726c 6179 3d64 7763' >> $pwmdriver
echo '322c 2064 725f 6d6f 6465 3d68 6f73 7420' >> $pwmdriver
echo '616e 6420 7265 626f 6f74 2052 5069 2000' >> $pwmdriver
echo '506c 6561 7365 2063 6865 636b 2073 6572' >> $pwmdriver
echo '6961 6c20 706f 7274 206f 7665 7220 4f54' >> $pwmdriver
echo '4700 0000 2d2d 2d53 6572 6961 6c20 506f' >> $pwmdriver
echo '7274 2043 616e 206e 6f74 2064 6574 6563' >> $pwmdriver
echo '7465 642d 2d2d 0000 7200 0000 2f73 7973' >> $pwmdriver
echo '2f63 6c61 7373 2f74 6865 726d 616c 2f74' >> $pwmdriver
echo '6865 726d 616c 5f7a 6f6e 6530 2f74 656d' >> $pwmdriver
echo '7000 0000 2f64 6576 2f74 7479 5553 4230' >> $pwmdriver
echo '0000 0000 2f65 7463 2f64 6573 6b70 692e' >> $pwmdriver
echo '636f 6e66 0000 0000 7077 6d5f 3030 3000' >> $pwmdriver
echo '7077 6d5f 2530 3364 0000 0000 e0f7 ff7f' >> $pwmdriver
echo '0100 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '8807 0100 6007 0100 0100 0000 0100 0000' >> $pwmdriver
echo '0c00 0000 8005 0100 0d00 0000 700d 0100' >> $pwmdriver
echo '1900 0000 100f 0200 1b00 0000 0400 0000' >> $pwmdriver
echo '1a00 0000 140f 0200 1c00 0000 0400 0000' >> $pwmdriver
echo 'f5fe ff6f b401 0100 0500 0000 c803 0100' >> $pwmdriver
echo '0600 0000 6802 0100 0a00 0000 ba00 0000' >> $pwmdriver
echo '0b00 0000 1000 0000 1500 0000 0000 0000' >> $pwmdriver
echo '0300 0000 0010 0200 0200 0000 a800 0000' >> $pwmdriver
echo '1400 0000 1100 0000 1700 0000 d804 0100' >> $pwmdriver
echo '1100 0000 d004 0100 1200 0000 0800 0000' >> $pwmdriver
echo '1300 0000 0800 0000 feff ff6f b004 0100' >> $pwmdriver
echo 'ffff ff6f 0100 0000 f0ff ff6f 8204 0100' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '180f 0200 0000 0000 0000 0000 8c05 0100' >> $pwmdriver
echo '8c05 0100 8c05 0100 8c05 0100 8c05 0100' >> $pwmdriver
echo '8c05 0100 8c05 0100 8c05 0100 8c05 0100' >> $pwmdriver
echo '8c05 0100 8c05 0100 8c05 0100 8c05 0100' >> $pwmdriver
echo '8c05 0100 8c05 0100 8c05 0100 8c05 0100' >> $pwmdriver
echo '8c05 0100 8c05 0100 8c05 0100 8c05 0100' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 4743 433a' >> $pwmdriver
echo '2028 5261 7370 6269 616e 2038 2e33 2e30' >> $pwmdriver
echo '2d36 2b72 7069 3129 2038 2e33 2e30 0041' >> $pwmdriver
echo '2e00 0000 6165 6162 6900 0124 0000 0005' >> $pwmdriver
echo '3600 0606 0801 0901 0a02 1204 1301 1401' >> $pwmdriver
echo '1501 1703 1801 1901 1a02 1c01 2201 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 5401 0100 0000 0000 0300 0100' >> $pwmdriver
echo '0000 0000 7001 0100 0000 0000 0300 0200' >> $pwmdriver
echo '0000 0000 9001 0100 0000 0000 0300 0300' >> $pwmdriver
echo '0000 0000 b401 0100 0000 0000 0300 0400' >> $pwmdriver
echo '0000 0000 6802 0100 0000 0000 0300 0500' >> $pwmdriver
echo '0000 0000 c803 0100 0000 0000 0300 0600' >> $pwmdriver
echo '0000 0000 8204 0100 0000 0000 0300 0700' >> $pwmdriver
echo '0000 0000 b004 0100 0000 0000 0300 0800' >> $pwmdriver
echo '0000 0000 d004 0100 0000 0000 0300 0900' >> $pwmdriver
echo '0000 0000 d804 0100 0000 0000 0300 0a00' >> $pwmdriver
echo '0000 0000 8005 0100 0000 0000 0300 0b00' >> $pwmdriver
echo '0000 0000 8c05 0100 0000 0000 0300 0c00' >> $pwmdriver
echo '0000 0000 9c06 0100 0000 0000 0300 0d00' >> $pwmdriver
echo '0000 0000 700d 0100 0000 0000 0300 0e00' >> $pwmdriver
echo '0000 0000 780d 0100 0000 0000 0300 0f00' >> $pwmdriver
echo '0000 0000 bc0e 0100 0000 0000 0300 1000' >> $pwmdriver
echo '0000 0000 c40e 0100 0000 0000 0300 1100' >> $pwmdriver
echo '0000 0000 100f 0200 0000 0000 0300 1200' >> $pwmdriver
echo '0000 0000 140f 0200 0000 0000 0300 1300' >> $pwmdriver
echo '0000 0000 180f 0200 0000 0000 0300 1400' >> $pwmdriver
echo '0000 0000 0010 0200 0000 0000 0300 1500' >> $pwmdriver
echo '0000 0000 6410 0200 0000 0000 0300 1600' >> $pwmdriver
echo '0000 0000 6c10 0200 0000 0000 0300 1700' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0300 1800' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0300 1900' >> $pwmdriver
echo '0100 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4800 0000 7001 0100 0000 0000 0000 0200' >> $pwmdriver
echo '4b00 0000 9c06 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 bc0e 0100 0000 0000 0000 1000' >> $pwmdriver
echo '4800 0000 cc06 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 780d 0100 0000 0000 0000 0f00' >> $pwmdriver
echo '4800 0000 6410 0200 0000 0000 0000 1600' >> $pwmdriver
echo '4e00 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4b00 0000 d806 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '9500 0000 d806 0100 0000 0000 0200 0d00' >> $pwmdriver
echo '4800 0000 f406 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 8005 0100 0000 0000 0000 0b00' >> $pwmdriver
echo '4b00 0000 700d 0100 0000 0000 0000 0e00' >> $pwmdriver
echo 'a200 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4b00 0000 8805 0100 0000 0000 0000 0b00' >> $pwmdriver
echo '4b00 0000 740d 0100 0000 0000 0000 0e00' >> $pwmdriver
echo 'e900 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4b00 0000 fc06 0100 0000 0000 0000 0d00' >> $pwmdriver
echo 'f400 0000 fc06 0100 0000 0000 0200 0d00' >> $pwmdriver
echo '4800 0000 1c07 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 2807 0100 0000 0000 0000 0d00' >> $pwmdriver
echo 'f600 0000 2807 0100 0000 0000 0200 0d00' >> $pwmdriver
echo '4800 0000 5407 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 6810 0200 0000 0000 0000 1600' >> $pwmdriver
echo '4b00 0000 6007 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '0901 0000 6007 0100 0000 0000 0200 0d00' >> $pwmdriver
echo '4800 0000 8407 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '1f01 0000 6c10 0200 0100 0000 0100 1700' >> $pwmdriver
echo '4800 0000 140f 0200 0000 0000 0000 1300' >> $pwmdriver
echo '2f01 0000 140f 0200 0000 0000 0100 1300' >> $pwmdriver
echo '4b00 0000 8807 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '5601 0000 8807 0100 0000 0000 0200 0d00' >> $pwmdriver
echo '4800 0000 100f 0200 0000 0000 0000 1200' >> $pwmdriver
echo '6201 0000 100f 0200 0000 0000 0100 1200' >> $pwmdriver
echo '4800 0000 6c10 0200 0000 0000 0000 1700' >> $pwmdriver
echo '8101 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '9101 0000 7010 0200 0400 0000 0100 1700' >> $pwmdriver
echo '4800 0000 7010 0200 0000 0000 0000 1700' >> $pwmdriver
echo '4800 0000 7c0d 0100 0000 0000 0000 0f00' >> $pwmdriver
echo '4b00 0000 8c07 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 7809 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 8c09 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 c809 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 cc09 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 f009 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 f409 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 a40a 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 b00a 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 f80c 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '9d01 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4b00 0000 0c0d 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4800 0000 640d 0100 0000 0000 0000 0d00' >> $pwmdriver
echo '4b00 0000 6c0d 0100 0000 0000 0000 0d00' >> $pwmdriver
echo 'e900 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo '4800 0000 c40e 0100 0000 0000 0000 1100' >> $pwmdriver
echo 'a901 0000 c40e 0100 0000 0000 0100 1100' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0400 f1ff' >> $pwmdriver
echo 'b701 0000 140f 0200 0000 0000 0000 1200' >> $pwmdriver
echo 'c801 0000 180f 0200 0000 0000 0100 1400' >> $pwmdriver
echo 'd101 0000 100f 0200 0000 0000 0000 1200' >> $pwmdriver
echo 'e401 0000 0010 0200 0000 0000 0100 1500' >> $pwmdriver
echo '4b00 0000 8c05 0100 0000 0000 0000 0c00' >> $pwmdriver
echo '4800 0000 9c05 0100 0000 0000 0000 0c00' >> $pwmdriver
echo '4b00 0000 a005 0100 0000 0000 0000 0c00' >> $pwmdriver
echo 'fa01 0000 6c0d 0100 0400 0000 1200 0d00' >> $pwmdriver
echo 'a702 0000 6410 0200 0000 0000 2000 1600' >> $pwmdriver
echo 'b003 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '0a02 0000 6c10 0200 0000 0000 1000 1700' >> $pwmdriver
echo '1802 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '2902 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '6e02 0000 7410 0200 0000 0000 1000 1700' >> $pwmdriver
echo '3a02 0000 6c10 0200 0000 0000 1000 1600' >> $pwmdriver
echo '4102 0000 cc09 0100 2800 0000 1200 0d00' >> $pwmdriver
echo '4f02 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '0402 0000 700d 0100 0000 0000 1202 0e00' >> $pwmdriver
echo '6002 0000 f409 0100 bc00 0000 1200 0d00' >> $pwmdriver
echo '6d02 0000 7410 0200 0000 0000 1000 1700' >> $pwmdriver
echo '7902 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '9002 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'a502 0000 6410 0200 0000 0000 1000 1600' >> $pwmdriver
echo 'b202 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'c202 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'df02 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'f302 0000 0000 0000 0000 0000 2000 0000' >> $pwmdriver
echo '1902 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '0203 0000 6810 0200 0000 0000 1102 1600' >> $pwmdriver
echo '0f03 0000 780d 0100 0400 0000 1100 0f00' >> $pwmdriver
echo '1e03 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '3503 0000 0c0d 0100 6000 0000 1200 0d00' >> $pwmdriver
echo '4503 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '6103 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'c301 0000 7410 0200 0000 0000 1000 1700' >> $pwmdriver
echo 'ab02 0000 9c06 0100 0000 0000 1200 0d00' >> $pwmdriver
echo '7303 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '8403 0000 7410 0200 0000 0000 1000 1700' >> $pwmdriver
echo '8c03 0000 6c10 0200 0000 0000 1000 1700' >> $pwmdriver
echo '9803 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'aa03 0000 b00a 0100 5c02 0000 1200 0d00' >> $pwmdriver
echo 'af03 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'c203 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo 'd203 0000 6c10 0200 0000 0000 1102 1600' >> $pwmdriver
echo 'de03 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '3f03 0000 8005 0100 0000 0000 1202 0b00' >> $pwmdriver
echo '9903 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '4302 0000 8c07 0100 0002 0000 1200 0d00' >> $pwmdriver
echo 'ef03 0000 0000 0000 0000 0000 1200 0000' >> $pwmdriver
echo '0404 0000 8c09 0100 4000 0000 1200 0d00' >> $pwmdriver
echo '002f 7573 722f 6c69 622f 6763 632f 6172' >> $pwmdriver
echo '6d2d 6c69 6e75 782d 676e 7565 6162 6968' >> $pwmdriver
echo '662f 382f 2e2e 2f2e 2e2f 2e2e 2f61 726d' >> $pwmdriver
echo '2d6c 696e 7578 2d67 6e75 6561 6269 6866' >> $pwmdriver
echo '2f63 7274 312e 6f00 2464 0024 6100 2f75' >> $pwmdriver
echo '7372 2f6c 6962 2f67 6363 2f61 726d 2d6c' >> $pwmdriver
echo '696e 7578 2d67 6e75 6561 6269 6866 2f38' >> $pwmdriver
echo '2f2e 2e2f 2e2e 2f2e 2e2f 6172 6d2d 6c69' >> $pwmdriver
echo '6e75 782d 676e 7565 6162 6968 662f 6372' >> $pwmdriver
echo '7469 2e6f 0063 616c 6c5f 7765 616b 5f66' >> $pwmdriver
echo '6e00 2f75 7372 2f6c 6962 2f67 6363 2f61' >> $pwmdriver
echo '726d 2d6c 696e 7578 2d67 6e75 6561 6269' >> $pwmdriver
echo '6866 2f38 2f2e 2e2f 2e2e 2f2e 2e2f 6172' >> $pwmdriver
echo '6d2d 6c69 6e75 782d 676e 7565 6162 6968' >> $pwmdriver
echo '662f 6372 746e 2e6f 0063 7274 7374 7566' >> $pwmdriver
echo '662e 6300 6465 7265 6769 7374 6572 5f74' >> $pwmdriver
echo '6d5f 636c 6f6e 6573 005f 5f64 6f5f 676c' >> $pwmdriver
echo '6f62 616c 5f64 746f 7273 5f61 7578 0063' >> $pwmdriver
echo '6f6d 706c 6574 6564 2e31 3037 3833 005f' >> $pwmdriver
echo '5f64 6f5f 676c 6f62 616c 5f64 746f 7273' >> $pwmdriver
echo '5f61 7578 5f66 696e 695f 6172 7261 795f' >> $pwmdriver
echo '656e 7472 7900 6672 616d 655f 6475 6d6d' >> $pwmdriver
echo '7900 5f5f 6672 616d 655f 6475 6d6d 795f' >> $pwmdriver
echo '696e 6974 5f61 7272 6179 5f65 6e74 7279' >> $pwmdriver
echo '0070 776d 436f 6e74 726f 6c46 616e 2e63' >> $pwmdriver
echo '0073 6572 6961 6c5f 706f 7274 0065 6c66' >> $pwmdriver
echo '2d69 6e69 742e 6f53 005f 5f46 5241 4d45' >> $pwmdriver
echo '5f45 4e44 5f5f 005f 5f69 6e69 745f 6172' >> $pwmdriver
echo '7261 795f 656e 6400 5f44 594e 414d 4943' >> $pwmdriver
echo '005f 5f69 6e69 745f 6172 7261 795f 7374' >> $pwmdriver
echo '6172 7400 5f47 4c4f 4241 4c5f 4f46 4653' >> $pwmdriver
echo '4554 5f54 4142 4c45 5f00 5f5f 6c69 6263' >> $pwmdriver
echo '5f63 7375 5f66 696e 6900 5f5f 6273 735f' >> $pwmdriver
echo '7374 6172 745f 5f00 666f 7065 6e40 4047' >> $pwmdriver
echo '4c49 4243 5f32 2e34 0066 6765 7473 4040' >> $pwmdriver
echo '474c 4942 435f 322e 3400 5f65 6461 7461' >> $pwmdriver
echo '005f 5f69 6e69 745f 7365 7269 616c 0073' >> $pwmdriver
echo '6c65 6570 4040 474c 4942 435f 322e 3400' >> $pwmdriver
echo '7265 6164 5f63 7075 5f74 6d70 005f 5f62' >> $pwmdriver
echo '7373 5f65 6e64 5f5f 0063 6673 6574 6f73' >> $pwmdriver
echo '7065 6564 4040 474c 4942 435f 322e 3400' >> $pwmdriver
echo '7463 7365 7461 7474 7240 4047 4c49 4243' >> $pwmdriver
echo '5f32 2e34 005f 5f64 6174 615f 7374 6172' >> $pwmdriver
echo '7400 7075 7473 4040 474c 4942 435f 322e' >> $pwmdriver
echo '3400 5f5f 6c69 6263 5f73 7461 7274 5f6d' >> $pwmdriver
echo '6169 6e40 4047 4c49 4243 5f32 2e34 0073' >> $pwmdriver
echo '7472 6572 726f 7240 4047 4c49 4243 5f32' >> $pwmdriver
echo '2e34 005f 5f67 6d6f 6e5f 7374 6172 745f' >> $pwmdriver
echo '5f00 5f5f 6473 6f5f 6861 6e64 6c65 005f' >> $pwmdriver
echo '494f 5f73 7464 696e 5f75 7365 6400 6366' >> $pwmdriver
echo '7365 7469 7370 6565 6440 4047 4c49 4243' >> $pwmdriver
echo '5f32 2e34 005f 5f6c 6962 635f 6373 755f' >> $pwmdriver
echo '696e 6974 005f 5f65 7272 6e6f 5f6c 6f63' >> $pwmdriver
echo '6174 696f 6e40 4047 4c49 4243 5f32 2e34' >> $pwmdriver
echo '006d 656d 7365 7440 4047 4c49 4243 5f32' >> $pwmdriver
echo '2e34 0077 7269 7465 4040 474c 4942 435f' >> $pwmdriver
echo '322e 3400 5f5f 656e 645f 5f00 5f5f 6273' >> $pwmdriver
echo '735f 7374 6172 7400 6663 6c6f 7365 4040' >> $pwmdriver
echo '474c 4942 435f 322e 3400 6d61 696e 0073' >> $pwmdriver
echo '7072 696e 7466 4040 474c 4942 435f 322e' >> $pwmdriver
echo '3400 6174 6f69 4040 474c 4942 435f 322e' >> $pwmdriver
echo '3400 5f5f 544d 435f 454e 445f 5f00 6162' >> $pwmdriver
echo '6f72 7440 4047 4c49 4243 5f32 2e34 0074' >> $pwmdriver
echo '6367 6574 6174 7472 4040 474c 4942 435f' >> $pwmdriver
echo '322e 3400 7365 6e64 5f73 6572 6961 6c00' >> $pwmdriver
echo '002e 7379 6d74 6162 002e 7374 7274 6162' >> $pwmdriver
echo '002e 7368 7374 7274 6162 002e 696e 7465' >> $pwmdriver
echo '7270 002e 6e6f 7465 2e41 4249 2d74 6167' >> $pwmdriver
echo '002e 6e6f 7465 2e67 6e75 2e62 7569 6c64' >> $pwmdriver
echo '2d69 6400 2e67 6e75 2e68 6173 6800 2e64' >> $pwmdriver
echo '796e 7379 6d00 2e64 796e 7374 7200 2e67' >> $pwmdriver
echo '6e75 2e76 6572 7369 6f6e 002e 676e 752e' >> $pwmdriver
echo '7665 7273 696f 6e5f 7200 2e72 656c 2e64' >> $pwmdriver
echo '796e 002e 7265 6c2e 706c 7400 2e69 6e69' >> $pwmdriver
echo '7400 2e74 6578 7400 2e66 696e 6900 2e72' >> $pwmdriver
echo '6f64 6174 6100 2e41 524d 2e65 7869 6478' >> $pwmdriver
echo '002e 6568 5f66 7261 6d65 002e 696e 6974' >> $pwmdriver
echo '5f61 7272 6179 002e 6669 6e69 5f61 7272' >> $pwmdriver
echo '6179 002e 6479 6e61 6d69 6300 2e67 6f74' >> $pwmdriver
echo '002e 6461 7461 002e 6273 7300 2e63 6f6d' >> $pwmdriver
echo '6d65 6e74 002e 4152 4d2e 6174 7472 6962' >> $pwmdriver
echo '7574 6573 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0000 0000 0000 0000' >> $pwmdriver
echo '1b00 0000 0100 0000 0200 0000 5401 0100' >> $pwmdriver
echo '5401 0000 1900 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0100 0000 0000 0000 2300 0000 0700 0000' >> $pwmdriver
echo '0200 0000 7001 0100 7001 0000 2000 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0400 0000 0000 0000' >> $pwmdriver
echo '3100 0000 0700 0000 0200 0000 9001 0100' >> $pwmdriver
echo '9001 0000 2400 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 4400 0000 f6ff ff6f' >> $pwmdriver
echo '0200 0000 b401 0100 b401 0000 b400 0000' >> $pwmdriver
echo '0500 0000 0000 0000 0400 0000 0400 0000' >> $pwmdriver
echo '4e00 0000 0b00 0000 0200 0000 6802 0100' >> $pwmdriver
echo '6802 0000 6001 0000 0600 0000 0100 0000' >> $pwmdriver
echo '0400 0000 1000 0000 5600 0000 0300 0000' >> $pwmdriver
echo '0200 0000 c803 0100 c803 0000 ba00 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0100 0000 0000 0000' >> $pwmdriver
echo '5e00 0000 ffff ff6f 0200 0000 8204 0100' >> $pwmdriver
echo '8204 0000 2c00 0000 0500 0000 0000 0000' >> $pwmdriver
echo '0200 0000 0200 0000 6b00 0000 feff ff6f' >> $pwmdriver
echo '0200 0000 b004 0100 b004 0000 2000 0000' >> $pwmdriver
echo '0600 0000 0100 0000 0400 0000 0000 0000' >> $pwmdriver
echo '7a00 0000 0900 0000 0200 0000 d004 0100' >> $pwmdriver
echo 'd004 0000 0800 0000 0500 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0800 0000 8300 0000 0900 0000' >> $pwmdriver
echo '4200 0000 d804 0100 d804 0000 a800 0000' >> $pwmdriver
echo '0500 0000 1500 0000 0400 0000 0800 0000' >> $pwmdriver
echo '8c00 0000 0100 0000 0600 0000 8005 0100' >> $pwmdriver
echo '8005 0000 0c00 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 8700 0000 0100 0000' >> $pwmdriver
echo '0600 0000 8c05 0100 8c05 0000 1001 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0400 0000 0400 0000' >> $pwmdriver
echo '9200 0000 0100 0000 0600 0000 9c06 0100' >> $pwmdriver
echo '9c06 0000 d406 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 9800 0000 0100 0000' >> $pwmdriver
echo '0600 0000 700d 0100 700d 0000 0800 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0400 0000 0000 0000' >> $pwmdriver
echo '9e00 0000 0100 0000 0200 0000 780d 0100' >> $pwmdriver
echo '780d 0000 4101 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 a600 0000 0100 0070' >> $pwmdriver
echo '8200 0000 bc0e 0100 bc0e 0000 0800 0000' >> $pwmdriver
echo '0d00 0000 0000 0000 0400 0000 0000 0000' >> $pwmdriver
echo 'b100 0000 0100 0000 0200 0000 c40e 0100' >> $pwmdriver
echo 'c40e 0000 0400 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 bb00 0000 0e00 0000' >> $pwmdriver
echo '0300 0000 100f 0200 100f 0000 0400 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0400 0000 0400 0000' >> $pwmdriver
echo 'c700 0000 0f00 0000 0300 0000 140f 0200' >> $pwmdriver
echo '140f 0000 0400 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0400 0000 d300 0000 0600 0000' >> $pwmdriver
echo '0300 0000 180f 0200 180f 0000 e800 0000' >> $pwmdriver
echo '0600 0000 0000 0000 0400 0000 0800 0000' >> $pwmdriver
echo 'dc00 0000 0100 0000 0300 0000 0010 0200' >> $pwmdriver
echo '0010 0000 6400 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0400 0000 e100 0000 0100 0000' >> $pwmdriver
echo '0300 0000 6410 0200 6410 0000 0800 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0400 0000 0000 0000' >> $pwmdriver
echo 'e700 0000 0800 0000 0300 0000 6c10 0200' >> $pwmdriver
echo '6c10 0000 0800 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0400 0000 0000 0000 ec00 0000 0100 0000' >> $pwmdriver
echo '3000 0000 0000 0000 6c10 0000 2300 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0100 0000 0100 0000' >> $pwmdriver
echo 'f500 0000 0300 0070 0000 0000 0000 0000' >> $pwmdriver
echo '8f10 0000 2f00 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0100 0000 0000 0000 0100 0000 0200 0000' >> $pwmdriver
echo '0000 0000 0000 0000 c010 0000 5008 0000' >> $pwmdriver
echo '1b00 0000 5a00 0000 0400 0000 1000 0000' >> $pwmdriver
echo '0900 0000 0300 0000 0000 0000 0000 0000' >> $pwmdriver
echo '1019 0000 1004 0000 0000 0000 0000 0000' >> $pwmdriver
echo '0100 0000 0000 0000 1100 0000 0300 0000' >> $pwmdriver
echo '0000 0000 0000 0000 201d 0000 0501 0000' >> $pwmdriver
echo '0000 0000 0000 0000 0100 0000 0000 0000' >> $pwmdriver

############################
#####Create Fan Service#####
############################

log_action_msg "Creating Fan Service"


# Create fan service file on system.
if [ -e $deskpidaemon ]; then
	rm -f $deskpidaemon
	touch /storage/.config/system.d/$daemonname.service
fi

# Create safe shut off service file on system.
if [ -e $shutidaemonscript ]; then
	rm -f $shutdaemonscript
	touch /storage/.config/system.d/$daemonname-safeshut.service
fi

############################
#####Build Fan Daemon#######
############################

log_action_msg "Building Fan Daemon"

echo "[Unit]" > $deskpidaemon
echo "Description=DeskPi PWM Control Fan Service" >> $deskpidaemon
echo "After=multi-user.target" >> $deskpidaemon
echo "[Service]" >> $deskpidaemon
echo "Type=simple" >> $deskpidaemon
echo "RemainAfterExit=no" >> $deskpidaemon
echo "ExecStart=/storage/user/bin/pwmFanControl" >> $deskpidaemon
echo "[Install]" >> $deskpidaemon
echo "WantedBy=multi-user.target" >> $deskpidaemon


############################
#####Create Power Service#####
############################

#log_action_msg "Creating Power Service"

##Installsafecutoffpower
#cp -rf $installationfolder/drivers/safecutoffpower /storage/user/bin
#chmod 755 /storage/user/bin/safecutoffpower


############################
#####Build Power Daemon#####
############################

#log_action_msg "Building Power Daemon"

#echo "[Unit]" > $shutdaemonscript
#echo "Description=DeskPi Safeshutdown Service" >> $shutdaemonscript
#echo "Conflicts=reboot.target" >> $shutdaemonscript
#echo "Before=halt.target shutdown.target poweroff.target" >> $shutdaemonscript
#echo "DefaultDependencies=no" >> $shutdaemonscript
#echo "[Service]" >> $shutdaemonscript
#echo "Type=oneshot" >> $shutdaemonscript
#echo "ExecStart=/storage/user/bin/safecutoffpower" >> $shutdaemonscript
#echo "RemainAfterExit=yes" >> $shutdaemonscript
#echo "TimeoutSec=1" >> $shutdaemonscript
#echo "[Install]" >> $shutdaemonscript
#echo "WantedBy=halt.target shutdown.target poweroff.target" >> $shutdaemonscript


################################################################
################ Daemon & Service Installation ################
################################################################

log_action_msg "DeskPi Service configuration finished." 


############################
#######Stop Services########
############################

log_action_msg "DeskPi Service Load module." 
systemctl daemon-reload
systemctl enable $daemonname.service
systemctl start $daemonname.service &
#systemctl enable $daemonname-safeshut.service
#systemctl start $daemonname-safeshut.service

############################
#########Exit Code##########
############################

log_success_msg "DeskPi PWM Fan Control and Safeshut Service installed successfully." 
# greetings and require rebooting system to take effect.
log_action_msg "System will reboot in 5 seconds to take effect." 
sync
#sleep 5 
#reboot
