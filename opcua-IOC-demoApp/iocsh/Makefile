TOP = ../..
include $(TOP)/configure/CONFIG

# IOCSH += opcua-IOC-demo.iocsh
IOCSH += $(patsubst ../%, %, $(wildcard ../*.iocsh))

include $(TOP)/configure/RULES

