#!../../bin/linux-x86_64/opcua-IOC-demo
#--
< envPaths
#--
cd "${TOP}"
#--
#--https://epics-controls.org/resources-and-support/documents/howto-documents/channel-access-reach-multiple-soft-iocs-linux/
#--if one needs connections between IOCs on one host
#--add the broadcast address of the lookback interface to each IOC setting
epicsEnvSet("EPICS_CA_ADDR_LIST","127.255.255.255")
#--epicsEnvSet("EPICS_CA_AUTO_ADDR_LIST","YES")

#-- PVXA Environment Variables
#-- epicsEnvSet("EPICS_PVA_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_AUTO_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_AUTO_BEACON_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVAS_INTF_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVAS_SERVER_PORT","")
#-- epicsEnvSet("EPICS_PVA_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_BROADCAST_PORT","")
#-- epicsEnvSet("EPICS_PVAS_IGNORE_ADDR_LIST","")
#-- epicsEnvSet("EPICS_PVA_CONN_TMO","")
#--
epicsEnvSet("DB_TOP",                "$(TOP)/db")
epicsEnvSet("EPICS_DB_INCLUDE_PATH", "$(DB_TOP)")
epicsEnvSet("STREAM_PROTOCOL_PATH",  "$(DB_TOP)")
epicsEnvSet("IOCSH_LOCAL_TOP",       "$(TOP)/iocsh")
#--epicsEnvSet("IOCSH_TOP",            "$(EPICS_BASE)/../modules/soft/iocsh/iocsh")
#--
epicsEnvSet("ENGINEER",  "jeonglee")
epicsEnvSet("LOCATION",  "SoftIOC")
epicsEnvSet("WIKI", "")
#-- 
epicsEnvSet("IOCNAME", "home-opcua-IOC-demo")
epicsEnvSet("IOC", "iochome-opcua-IOC-demo")
#--
epicsEnvSet("PRE", "AAAA:")
epicsEnvSet("REC", "BBBB:")

dbLoadDatabase "dbd/opcua-IOC-demo.dbd"
opcuaiochome-opcua-IOC-demodemo_registerRecordDeviceDriver pdbbase

#--
#-- The following termination defintion should be in st.cmd or .iocsh. 
#-- Mostly, it should be .iocsh file. Please don't use them within .proto file
#--
#-- <0x0d> \r
#-- <0x0a> \n
#-- asynOctetSetInputEos($(PORT), 0, "\r")
#-- asynOctetSetOutputEos($(PORT), 0, "\r")

#--
#-- iocshLoad("$(IOCSH_TOP)/als_default.iocsh")
#-- iocshLoad("$(IOCSH_TOP)/iocLog.iocsh",    "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#--# Load record instances
#-- iocshLoad("$(IOCSH_TOP)/iocStats.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/iocStatsAdmin.iocsh",  "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/reccaster.iocsh", "IOCNAME=$(IOCNAME), DATABASE_TOP=$(DB_TOP)")
#-- iocshLoad("$(IOCSH_TOP)/caPutLog.iocsh",  "IOCNAME=$(IOCNAME), LOG_INET=$(LOG_DEST), LOG_INET_PORT=$(LOG_PORT)")
#-- iocshLoad("$(IOCSH_TOP)/autosave.iocsh", "AS_TOP=$(TOP),IOCNAME=$(IOCNAME),DATABASE_TOP=$(DB_TOP),SEQ_PERIOD=60")

#-- access control list
#--asSetFilename("$(DB_TOP)/access_securityhome-opcua-IOC-demo.acf")

cd "${TOP}/iocBoot/${IOC}"

#--epicsEnvSet("PORT1",      "AABBCCDD")
#--epicsEnvSet("PORT1_IP",   "xxx.xxx.xxx.xxx")
#--epicsEnvSet("PORT1_PORT", "xxxx")
#--iocshLoad("$(IOCSH_LOCAL_TOP)/opcua-IOC-demo.iocsh", "P=$(PRE),R=$(REC),DATABASE_TOP=$(DB_TOP),PORT=$(PORT1),IPADDR=$(PORT1_IP),IPPORT=$(PORT1_PORT)")

#>>>>>>>>>>>>>
iocInit
#>>>>>>>>>>>>>
##
##-- epicsEnvShow > /vxboot/PVenv/${IOCNAME}.softioc
##-- dbl > /vxboot/PVnames/${IOCNAME}
##-- iocshLoad("$(IOCSH_TOP)/after_iocInit.iocsh", "IOC=$(IOC),TRAGET_TOP=/vxboot")
##
# pvasr
ClockTime_Report
##
##
##
#--# Start any sequence programs
#--seq sncxxx,"user=jeonglee"
#--asynReport(1)
#-
