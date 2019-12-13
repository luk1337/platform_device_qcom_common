ifeq ($(AB_OTA_UPDATER), true)
BUILD_OEM_UPDATER := true
endif
ifneq ($(filter librecovery_updater_msm,$(TARGET_RECOVERY_UPDATER_LIBS)),)
BUILD_OEM_UPDATER := true
endif
BUILD_OEM_UPDATER := false
ifeq ($(BUILD_OEM_UPDATER), true)
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_STATIC_LIBRARIES += libedify libotautil libz
LOCAL_C_INCLUDES := bootable/recovery \
		    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_SRC_FILES := gpt-utils.cpp dec.cpp oem-updater.cpp
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
LOCAL_MODULE := librecovery_updater_msm
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)
LOCAL_MODULE_TAGS := optional
LOCAL_C_INCLUDES := bootable/recovery \
		    $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr/include
LOCAL_SRC_FILES := gpt-utils.cpp
LOCAL_ADDITIONAL_DEPENDENCIES := $(TARGET_OUT_INTERMEDIATES)/KERNEL_OBJ/usr
LOCAL_SHARED_LIBRARIES += liblog libcutils libz
LOCAL_MODULE := librecovery_updater_msm
LOCAL_COPY_HEADERS_TO := gpt-utils/inc
LOCAL_COPY_HEADERS := gpt-utils.h
LOCAL_VENDOR_MODULE := true
include $(BUILD_SHARED_LIBRARY)
endif
