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
opcua_IOC_demo_registerRecordDeviceDriver pdbbase

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

# Pretty minimal setup: one session with a 200ms subscription on top
opcuaSession OPC1 opc.tcp://127.0.0.1:48020
opcuaSubscription SUB1 OPC1 200

# Switch off security
opcuaOptions OPC1 sec-mode=None

# Set up a namespace mapping
# (the databases use ns=2, but the demo server >=v1.8 uses ns=3)

opcuaMapNamespace OPC1 2 "http://www.unifiedautomation.com/DemoServer/"

# Load the databases for the UaServerCpp demo server
# (you can set DEBUG=<n>) to set default values in all TPRO fields)

dbLoadRecords "$(DB_TOP)/UaDemoServer-server.db", "P=OPC:,R=,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.Arrays.db", "P=OPC:,R=DDA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.Scalar.db", "P=OPC:,R=DDS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.Arrays.db", "P=OPC:,R=DSA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.Scalar.db", "P=OPC:,R=DSS:,SESS=OPC1,SUBS=SUB1"

dbLoadRecords "$(DB_TOP)/Demo.WorkOrder.db", "P=OPC:,SESS=OPC1,SUBS=SUB1"

# DO NOT LOAD THESE DBs ON EPICS BASE < 7.0     \/  \/  \/     EPICS 7 ONLY
# int64 and long string records need EPICS 7
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.ScalarE7.db", "P=OPC:,R=DDS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Dynamic.ArraysE7.db", "P=OPC:,R=DDA:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.ScalarE7.db", "P=OPC:,R=DSS:,SESS=OPC1,SUBS=SUB1"
dbLoadRecords "$(DB_TOP)/Demo.Static.ArraysE7.db", "P=OPC:,R=DSA:,SESS=OPC1,SUBS=SUB1"


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
