#
# Copyright (C) 2025-2026 The TWRP Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

DEVICE_PATH := device/xiaomi/klimt

# Architecture: MT6991 (Dimensity 9400) — arm64 only
TARGET_ARCH                 := arm64
TARGET_ARCH_VARIANT         := armv8-a
TARGET_CPU_ABI              := arm64-v8a
TARGET_CPU_VARIANT          := generic
TARGET_CPU_VARIANT_RUNTIME  := generic

TARGET_IS_64_BIT            := true
TARGET_USES_64_BIT_BINDER   := true
TARGET_SUPPORTS_32_BIT_APPS := false
TARGET_SUPPORTS_64_BIT_APPS := true

# Platform & Bootloader
PRODUCT_PLATFORM            := mt6991
TARGET_BOOTLOADER_BOARD_NAME := mt6991
TARGET_BOARD_PLATFORM       := mt6991
TARGET_NO_BOOTLOADER        := true
TARGET_NO_KERNEL            := true
TARGET_USES_UEFI            := true
TARGET_OTA_ASSERT_DEVICE    := klimt
TARGET_BOARD_INFO_FILE      := $(DEVICE_PATH)/board-info.txt
TARGET_COPY_OUT_VENDOR      := vendor

# Building with minimal manifest & build hacks for modern Android / TWRP
ALLOW_MISSING_DEPENDENCIES                      := true
BUILD_BROKEN_DUP_RULES                          := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES    := true
BUILD_BROKEN_NINJA_USES_ENV_VARS                += RTIC_MPGEN
BUILD_BROKEN_PLUGIN_VALIDATION                  := soong-libaosprecovery_defaults soong-libguitwrp_defaults soong-libminuitwrp_defaults soong-vold_defaults

# Kernel & Boot Image (Stock klimt vendor_boot v4 facts)
TARGET_KERNEL_ARCH              := arm64
TARGET_KERNEL_HEADER_ARCH       := arm64
BOARD_USES_GENERIC_KERNEL_IMAGE := true
BOARD_RAMDISK_USE_LZ4           := true
BOARD_INCLUDE_DTB_IN_BOOTIMG    := true
BOARD_KERNEL_SEPARATED_DTBO     := true

# Prebuilt DTB & DTBO Image
TARGET_PREBUILT_DTB             := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_PREBUILT_DTBIMAGE         := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_PREBUILT_DTBIMAGE_DIR     := $(DEVICE_PATH)/prebuilt/dtb
BOARD_PREBUILT_DTBOIMAGE        := $(DEVICE_PATH)/prebuilt/dtbo.img

BOARD_BOOT_HEADER_VERSION       := 4
BOARD_VENDOR_BOOT_HEADER_VERSION := 4
BOARD_PAGE_SIZE                 := 4096
BOARD_KERNEL_PAGESIZE           := 4096
BOARD_KERNEL_BASE               := 0x00000000
BOARD_KERNEL_OFFSET             := 0x80000000
BOARD_RAMDISK_OFFSET            := 0xa6f00000
BOARD_TAGS_OFFSET               := 0x87c80000
BOARD_DTB_OFFSET                := 0x87c80000
BOARD_DTB_SIZE                  := 532594
BOARD_HEADER_SIZE               := 2128
BOARD_KERNEL_CMDLINE            := bootopt=64S3,32N2,64N2

BOARD_MKBOOTIMG_ARGS += \
    --header_version $(BOARD_BOOT_HEADER_VERSION) \
    --pagesize $(BOARD_PAGE_SIZE) \
    --kernel_offset $(BOARD_KERNEL_OFFSET) \
    --ramdisk_offset $(BOARD_RAMDISK_OFFSET) \
    --tags_offset $(BOARD_TAGS_OFFSET) \
    --dtb_offset $(BOARD_DTB_OFFSET) \
    --dtb $(TARGET_PREBUILT_DTB) \
    --board ""

# Partitions Sizes (from stock scatter and super metadata)
BOARD_FLASH_BLOCK_SIZE                  := 262144        # 256 KB
BOARD_BOOTIMAGE_PARTITION_SIZE          := 67108864      # 64 MB
BOARD_VENDOR_BOOTIMAGE_PARTITION_SIZE   := 67108864      # 64 MB
BOARD_INIT_BOOT_IMAGE_PARTITION_SIZE    := 8388608       # 8 MB
BOARD_DTBOIMG_PARTITION_SIZE            := 8388608       # 8 MB
BOARD_SUPER_PARTITION_SIZE              := 11811160064   # 11 GB

# Dynamic Partitions (Stock Xiaomi Super Layout: group main)
BOARD_SUPER_PARTITION_GROUPS            := main
BOARD_MAIN_SIZE                         := 11800674304
BOARD_MAIN_PARTITION_LIST               := odm odm_dlkm product system system_dlkm system_ext vendor vendor_dlkm mi_ext
BOARD_PARTITION_LIST                    := $(call to-upper, $(BOARD_MAIN_PARTITION_LIST))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval BOARD_$(p)IMAGE_FILE_SYSTEM_TYPE := erofs))
$(foreach p, $(BOARD_PARTITION_LIST), $(eval TARGET_COPY_OUT_$(p) := $(call to-lower, $(p))))

TARGET_USERIMAGES_USE_EXT4              := true
TARGET_USERIMAGES_USE_F2FS              := true
TARGET_USERIMAGES_USE_EROFS             := true
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE    := f2fs
BOARD_METADATAIMAGE_FILE_SYSTEM_TYPE    := f2fs
BOARD_USES_VENDOR_DLKMIMAGE             := true
BOARD_USES_MTK_HARDWARE                 := true

# Recovery in Vendor Boot
TARGET_NO_RECOVERY                      := true
BOARD_USES_RECOVERY_AS_BOOT             := false
BOARD_MOVE_RECOVERY_RESOURCES_TO_VENDOR_BOOT := true
BOARD_INCLUDE_RECOVERY_RAMDISK_IN_VENDOR_BOOT := true
BOARD_MOVE_GSI_AVB_KEYS_TO_VENDOR_BOOT  := true

# Recovery Display & General
TARGET_RECOVERY_PIXEL_FORMAT            := RGBX_8888
TARGET_RECOVERY_FSTAB                   := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab
TARGET_SYSTEM_PROP                      += $(DEVICE_PATH)/system.prop
BOARD_HAS_LARGE_FILESYSTEM              := true
BOARD_HAS_NO_SELECT_BUTTON              := true
BOARD_SUPPRESS_SECURE_ERASE             := true
BOARD_AVB_ENABLE                        := true

# Crypto & FBE Decryption for Android 15/16
BOARD_USES_METADATA_PARTITION           := true
TW_INCLUDE_CRYPTO                       := true
TW_INCLUDE_CRYPTO_FBE                   := true
TW_INCLUDE_FBE_METADATA_DECRYPT         := true
TW_USE_FSCRYPT_POLICY                   := 2
PLATFORM_VERSION                        := 99.87.36
PLATFORM_VERSION_LAST_STABLE            := $(PLATFORM_VERSION)
PLATFORM_SECURITY_PATCH                 := 2099-12-31
BOOT_SECURITY_PATCH                     := $(PLATFORM_SECURITY_PATCH)
VENDOR_SECURITY_PATCH                   := $(PLATFORM_SECURITY_PATCH)
TW_USE_DMCTL                            := true
TW_KEEP_VENDOR_MOUNTED                  := true
TW_KEEP_ODM_MOUNTED                     := true

# Display & Touch & Themes
TW_THEME                                := portrait_hdpi
TARGET_SCREEN_WIDTH                     := 1280
TARGET_SCREEN_HEIGHT                    := 2772
TW_FRAMERATE                            := 120
TW_STATUS_ICONS_ALIGN                   := center
TWRP_NEW_THEME                          := true
TW_BRIGHTNESS_PATH                      := "/sys/class/leds/lcd-backlight/brightness"
TW_DEFAULT_BRIGHTNESS                   := 8192
TW_MAX_BRIGHTNESS                       := 16383

# TWRP Features & Tools
TW_DEFAULT_LANGUAGE                     := en
TW_EXTRA_LANGUAGES                      := true
TW_USE_LEGACY_BATTERY_SERVICES          := true
TW_EXCLUDE_DEFAULT_USB_INIT             := true
TW_USE_NEW_MINADBD                      := true
TW_EXCLUDE_APEX                         := true
RECOVERY_SDCARD_ON_DATA                 := true
TW_PREPARE_DATA_MEDIA_EARLY             := true
TW_NO_LEGACY_PROPS                      := true
TW_NO_BIND_SYSTEM                       := true
TW_LOAD_VENDOR_BOOT_MODULES             := true

TW_INCLUDE_FASTBOOTD                    := true
TW_INCLUDE_LPTOOLS                      := true
TW_INCLUDE_LPDUMP                       := true
TW_INCLUDE_REPACKTOOLS                  := true
TW_INCLUDE_RESETPROP                    := true
TW_INCLUDE_LIBRESETPROP                 := true
TW_INCLUDE_EROFS                        := true
TW_INCLUDE_FUSE_EXFAT                   := true
TW_INCLUDE_FUSE_NTFS                    := true
TW_INCLUDE_NTFS_3G                      := true
TARGET_USES_MKE2FS                      := true

# USB & Storage
TW_HAS_MTP                              := true
TW_MTP_DEVICE                           := "/dev/mtp_usb"
TW_NO_USB_STORAGE                       := true
TW_INPUT_BLACKLIST                      := "hbtp_vm"
TW_DEVICE_VERSION                       := Xiaomi_15T_Pro-klimt
