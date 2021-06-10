#!/bin/bash
#
# @brief   Generate module-pair source and header code (C)
# @version ver.1.0
# @date    Tue Jan 10 11:37:27 CET 2017
# @company None, free software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.    ${UTIL}/bin/devel.sh
.    ${UTIL}/bin/usage.sh
.    ${UTIL}/bin/check_root.sh
.    ${UTIL}/bin/check_tool.sh
.    ${UTIL}/bin/logging.sh
.    ${UTIL}/bin/load_conf.sh
.    ${UTIL}/bin/load_util_conf.sh
.    ${UTIL}/bin/progress_bar.sh

GEN_C_MOD_TOOL=gen_c_module
GEN_C_MOD_VERSION=ver.1.0
GEN_C_MOD_HOME=${UTIL_ROOT}/${GEN_C_MOD_TOOL}/${GEN_C_MOD_VERSION}
GEN_C_MOD_CFG=${GEN_C_MOD_HOME}/conf/${GEN_C_MOD_TOOL}.cfg
GEN_C_MOD_UTIL_CFG=${GEN_C_MOD_HOME}/conf/${GEN_C_MOD_TOOL}_util.cfg
GEN_C_MOD_LOG=${GEN_C_MOD_HOME}/log

declare -A GEN_C_MOD_USAGE=(
    [USAGE_TOOL]="${GEN_C_MODULE}"
    [USAGE_ARG1]="[MODULE NAME] Name of module"
    [USAGE_EX_PRE]="# Example generating module-pair"
    [USAGE_EX]="${GEN_C_MODULE} MN"
)

declare -A GEN_C_MOD_LOGGING=(
    [LOG_TOOL]="${GEN_C_MOD_TOOL}"
    [LOG_FLAG]="info"
    [LOG_PATH]="${GEN_C_MOD_LOG}"
    [LOG_MSGE]="None"
)

declare -A PB_STRUCTURE=(
    [BW]=50
    [MP]=100
    [SLEEP]=0.01
)

TOOL_DEBUG="false"
TOOL_LOG="false"
TOOL_NOTIFY="false"

#
# @brief  Main function Generate module-pair source and header code
# @param  Value required module name
# @retval Function __gen_c_mod exit with integer value
#            0   - tool finished with success operation
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local MN="gen_user_name"
# __gen_c_mod "$MN"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#    # true
# else
#    # false
# fi
#
function __gen_c_mod {
    local MN=$1
    if [ -n "${MN}" ]; then
        local FUNC=${FUNCNAME[0]} MSG="None"
        local STATUS_CONF STATUS_CONF_UTIL STATUS
        MSG="Loading basic and util configuration!"
        info_debug_message "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
        progress_bar PB_STRUCTURE
        declare -A config_gen_c_mod=()
        load_conf "$GEN_C_MOD_CFG" config_gen_c_mod
        STATUS_CONF=$?
        declare -A config_gen_c_mod_util=()
        load_util_conf "$GEN_C_MOD_UTIL_CFG" config_gen_c_mod_util
        STATUS_CONF_UTIL=$?
        declare -A STATUS_STRUCTURE=(
            [1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL
        )
        check_status STATUS_STRUCTURE
        STATUS=$?
        if [ $STATUS -eq $NOT_SUCCESS ]; then
            MSG="Force exit!"
            info_debug_message_end "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
            exit 129
        fi
        TOOL_LOG=${config_gen_c_mod[LOGGING]}
        TOOL_DBG=${config_gen_c_mod[DEBUGGING]}
        TOOL_NOTIFY=${config_gen_c_mod[EMAILING]}
        local SRCF="${MN}.c" T="    " SLINE
        local UMN=$(echo ${MN} | tr 'a-z' 'A-Z')
        local ST=${config_gen_c_mod_util[SOURCE_TEMPLATE]}
        local STF="${GEN_C_MOD_HOME}/conf/${ST}"
        local AN=${config_gen_c_mod_util[AUTHOR_NAME]}
        local AE=${config_gen_c_mod_util[AUTHOR_EMAIL]}
        MSG="Generating file [${SRCF}]"
        info_debug_message "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
        while read SLINE
        do
            eval echo "${SLINE}" >> ${SRCF}
        done < ${STF}
        local HLINE HT=${config_gen_c_mod_util[HEADER_TEMPLATE]} TREE
        local HTF="${GEN_C_MOD_HOME}/conf/${HT}" HEDF="${MN}.h"
        MSG="Generate file [${HEDF}]"
        info_debug_message "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
        while read HLINE
        do
            eval echo "${HLINE}" >> ${HEDF}
        done < ${HTF}
        MSG="Set owner!"
        info_debug_message "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
        local USRID=${config_gen_c_mod_util[USERID]}
        local GRPID=${config_gen_c_mod_util[GROUPID]}
        eval "chown ${USRID}.${GRPID} ${SRCF}"
        eval "chown ${USRID}.${GRPID} ${HEDF}"
        MSG="Set permission!"
        info_debug_message "$MSG" "$FUNC" "$GEN_C_MOD_TOOL"
        eval "chmod 644 ${SRCF}"
        eval "chmod 644 ${HEDF}"
        MSG="Generated C module ${MN}"
        GEN_C_MOD_LOGGING[LOG_MSGE]=$MSG
        logging GEN_C_MOD_LOGGING
        info_debug_message "Done" "$FUNC" "$GEN_C_MOD_TOOL"
        TREE=$(which tree)
        check_tool "${TREE}"
        STATUS=$?
        if [ $STATUS -eq $SUCCESS ]; then
            eval "${TREE} -L 3 ."
        fi
        return $SUCCESS
    fi
    usage GEN_C_MOD_USAGE
    exit 128
}

#
# @brief   Main entry point
# @param   Value required module name
# @exitval Script tool gen_c_mod exit with integer value
#            0   - tool finished with success operation
#            127 - run tool script as root user from cli
#            128 - missing argument(s) from cli
#            129 - failed to load tool script configuration from files
#
printf "\n%s\n%s\n\n" "${GEN_C_MOD_TOOL} ${GEN_C_MOD_VERSION}" "`date`"
check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
    __gen_c_mod $1
fi

exit 127

