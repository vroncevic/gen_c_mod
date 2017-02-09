#!/bin/bash
#
# @brief   Generate module-pair source and header code
# @version ver.1.0
# @date    Tue Jan 10 11:37:27 CET 2017
# @company None, free software to use 2016
# @author  Vladimir Roncevic <elektron.ronca@gmail.com>
#
UTIL_ROOT=/root/scripts
UTIL_VERSION=ver.1.0
UTIL=${UTIL_ROOT}/sh_util/${UTIL_VERSION}
UTIL_LOG=${UTIL}/log

.	${UTIL}/bin/devel.sh
.	${UTIL}/bin/usage.sh
.	${UTIL}/bin/check_root.sh
.	${UTIL}/bin/check_tool.sh
.	${UTIL}/bin/logging.sh
.	${UTIL}/bin/load_conf.sh
.	${UTIL}/bin/load_util_conf.sh
.	${UTIL}/bin/progress_bar.sh

GEN_C_MODULE_TOOL=gen_c_module
GEN_C_MODULE_VERSION=ver.1.0
GEN_C_MODULE_HOME=${UTIL_ROOT}/${GEN_C_MODULE_TOOL}/${GEN_C_MODULE_VERSION}
GEN_C_MODULE_CFG=${GEN_C_MODULE_HOME}/conf/${GEN_C_MODULE_TOOL}.cfg
GEN_C_MODULE_UTIL_CFG=${GEN_C_MODULE_HOME}/conf/${GEN_C_MODULE_TOOL}_util.cfg
GEN_C_MODULE_LOG=${GEN_C_MODULE_HOME}/log

declare -A GEN_C_MODULE_USAGE=(
	[USAGE_TOOL]="__${GEN_C_MODULE}"
	[USAGE_ARG1]="[MODULE NAME] Name of module"
	[USAGE_EX_PRE]="# Example generating module-pair"
	[USAGE_EX]="__${GEN_C_MODULE} MN"
)

declare -A GEN_C_MODULE_LOGGING=(
	[LOG_TOOL]="${GEN_C_MODULE_TOOL}"
	[LOG_FLAG]="info"
	[LOG_PATH]="${GEN_C_MODULE_LOG}"
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
# @retval Function __gen_c_module exit with integer value
#			0   - tool finished with success operation
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#
# @usage
# @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
#
# local MN="gen_user_name"
# __gen_c_module "$MN"
# local STATUS=$?
#
# if [ $STATUS -eq $SUCCESS ]; then
#	# true
# else
#	# false
# fi
#
function __gen_c_module() {
	local MN=$1
	if [ -n "${MN}" ]; then
		local FUNC=${FUNCNAME[0]} MSG="None" STATUS_CONF STATUS_CONF_UTIL STATUS
		MSG="Loading basic and util configuration!"
		__info_debug_message "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
		__progress_bar PB_STRUCTURE
		declare -A config_gen_c_module=()
		__load_conf "$GEN_C_MODULE_CFG" config_gen_c_module
		STATUS_CONF=$?
		declare -A config_gen_c_module_util=()
		__load_util_conf "$GEN_C_MODULE_UTIL_CFG" config_gen_c_module_util
		STATUS_CONF_UTIL=$?
		declare -A STATUS_STRUCTURE=(
			[1]=$STATUS_CONF [2]=$STATUS_CONF_UTIL
		)
		__check_status STATUS_STRUCTURE
		STATUS=$?
		if [ $STATUS -eq $NOT_SUCCESS ]; then
			MSG="Force exit!"
			__info_debug_message_end "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
			exit 129
		fi
		TOOL_LOG=${config_gen_c_module[LOGGING]}
		TOOL_DBG=${config_gen_c_module[DEBUGGING]}
		TOOL_NOTIFY=${config_gen_c_module[EMAILING]}
		local SRCF="${MN}.c" T="	" SLINE
		local UMN=$(echo ${MN} | tr 'a-z' 'A-Z')
		local ST=${config_gen_c_module_util[SOURCE_TEMPLATE]}
		local STF="${GEN_C_MODULE_HOME}/conf/${ST}"
		local AN=${config_gen_c_module_util[AUTHOR_NAME]}
		local AE=${config_gen_c_module_util[AUTHOR_EMAIL]}
		MSG="Generating file [${SRCF}]"
		__info_debug_message "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
		while read SLINE
		do
			eval echo "${SLINE}" >> ${SRCF}
		done < ${STF}
		local HLINE HT=${config_gen_c_module_util[HEADER_TEMPLATE]} TREE
		local HTF="${GEN_C_MODULE_HOME}/conf/${HT}" HEDF="${MN}.h"
		MSG="Generate file [${HEDF}]"
		__info_debug_message "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
		while read HLINE
		do
			eval echo "${HLINE}" >> ${HEDF}
		done < ${HTF}
		MSG="Set owner!"
		__info_debug_message "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
		local USRID=${config_gen_c_module_util[UID]}
		local GRPID=${config_gen_c_module_util[GID]}
		eval "chown ${USRID}.${GRPID} ${SRCF}"
		eval "chown ${USRID}.${GRPID} ${HEDF}"
		MSG="Set permission!"
		__info_debug_message "$MSG" "$FUNC" "$GEN_C_MODULE_TOOL"
		eval "chmod 644 ${SRCF}"
		eval "chmod 644 ${HEDF}"
		__info_debug_message "Done" "$FUNC" "$GEN_C_MODULE_TOOL"
		TREE=$(which tree)
		__check_tool "${TREE}"
		STATUS=$?
		if [ $STATUS -eq $SUCCESS ]; then
			eval "${TREE} -L 3 ."
		fi
		return $SUCCESS
	fi
	__usage GEN_C_MODULE_USAGE
	exit 128
}

#
# @brief   Main entry point
# @param   Value required module name
# @exitval Script tool gen_c_module exit with integer value
#			0   - tool finished with success operation
# 			127 - run tool script as root user from cli
#			128 - missing argument(s) from cli
#			129 - failed to load tool script configuration from files
#
printf "\n%s\n%s\n\n" "${GEN_C_MODULE_TOOL} ${GEN_C_MODULE_VERSION}" "`date`"
__check_root
STATUS=$?
if [ $STATUS -eq $SUCCESS ]; then
	__gen_c_module $1
fi

exit 127

