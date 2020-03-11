# Copyright (C) 2017 AospExtended
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

 include vendor/aosp/config/version.mk

PRODUCT_BRAND ?= AEX

# Backup Tool
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/bin/backuptool.sh:install/bin/backuptool.sh \
    vendor/aosp/prebuilt/common/bin/backuptool.functions:install/bin/backuptool.functions \
    vendor/aosp/prebuilt/common/bin/50-base.sh:$(TARGET_COPY_OUT_SYSTEM)/addon.d/50-base.sh

ifeq ($(AB_OTA_UPDATER),true)
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/bin/backuptool_ab.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.sh \
    vendor/aosp/prebuilt/common/bin/backuptool_ab.functions:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_ab.functions \
    vendor/aosp/prebuilt/common/bin/backuptool_postinstall.sh:$(TARGET_COPY_OUT_SYSTEM)/bin/backuptool_postinstall.sh
endif

# Bootanimation
$(call inherit-product, vendor/aosp/config/bootanimation.mk)

# Gapps
ifeq ($(WITH_GAPPS),true)
include vendor/gapps/config.mk
else

ifeq ($(TARGET_USE_JELLY),true)
PRODUCT_PACKAGES += \
    Jelly
endif

# Turbo
PRODUCT_PACKAGES += \
    turbo.xml
endif

ifeq ($(TARGET_USE_GCAM),true)
PRODUCT_PACKAGES += \
    Gcam
endif

# Hidden API whitelist
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/permissions/aex-hiddenapi-package-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/aex-hiddenapi-package-whitelist.xml

# priv-app permissions
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/permissions/privapp-permissions-aex.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/privapp-permissions-aex.xml \
    vendor/aosp/prebuilt/common/etc/permissions/privapp-permissions-aex-product.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-aex-product.xml

# Enforce privapp-permissions whitelist
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.control_privapp_permissions=enforce

DEVICE_PACKAGE_OVERLAYS += \
    vendor/aosp/overlay/common \
    vendor/aosp/overlay/dictionaries

PRODUCT_ENFORCE_RRO_EXCLUDED_OVERLAYS += vendor/aosp/overlay

# Power whitelist
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/permissions/aex-power-whitelist.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/aex-power-whitelist.xml

# Custom Packages
PRODUCT_PACKAGES += \
    Terminal \
    LatinIME \
    LiveWallpapers \
    LiveWallpapersPicker \
    Stk \
    ViaBrowser \
    AEXPapers \
    ExactCalculator \
    WallpaperPickerGoogle \
    StitchImage

# Dex preopt
PRODUCT_DEXPREOPT_SPEED_APPS += \
    SystemUI \
    Launcher3QuickStep

# Extra packages
PRODUCT_PACKAGES += \
    libjni_latinimegoogle

# Live Display
PRODUCT_COPY_FILES += \
    vendor/aosp/config/permissions/privapp-permissions-livedisplay.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/permissions/privapp-permissions-livedisplay.xml

# Pixel sysconfig
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/sysconfig/pixel.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/pixel.xml

# Extra tools
PRODUCT_PACKAGES += \
    e2fsck \
    mke2fs \
    tune2fs \
    mount.exfat \
    fsck.exfat \
    mkfs.exfat \
    mkfs.f2fs \
    fsck.f2fs \
    fibmap.f2fs \
    mkfs.ntfs \
    fsck.ntfs \
    mount.ntfs \
    7z \
    bash \
    bzip2 \
    curl \
    lib7z \
    powertop \
    pigz \
    tinymix \
    unrar \
    unzip \
    vim \
    rsync \
    zip

# Exchange support
PRODUCT_PACKAGES += \
    Exchange2

# Backup Services whitelist
PRODUCT_COPY_FILES += \
    vendor/aosp/config/permissions/backup.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/backup.xml

# init.d support
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/etc/init.d/00banner:$(TARGET_COPY_OUT_SYSTEM)/etc/init.d/00banner

# AEX-specific init files
$(foreach f,$(wildcard vendor/aosp/prebuilt/common/etc/init/*.rc),\
    $(eval PRODUCT_COPY_FILES += $(f):$(TARGET_COPY_OUT_SYSTEM)/etc/init/$(notdir $f)))

# Copy over added mimetype supported in libcore.net.MimeUtils
PRODUCT_COPY_FILES += \
    vendor/aosp/prebuilt/common/lib/content-types.properties:$(TARGET_COPY_OUT_SYSTEM)/lib/content-types.properties

# Fix Dialer
PRODUCT_COPY_FILES +=  \
    vendor/aosp/prebuilt/common/etc/sysconfig/dialer_experience.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sysconfig/dialer_experience.xml

# Enable SIP+VoIP on all targets
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/permissions/android.software.sip.voip.xml

# Enable wireless Xbox 360 controller support
PRODUCT_COPY_FILES += \
    frameworks/base/data/keyboards/Vendor_045e_Product_028e.kl:$(TARGET_COPY_OUT_SYSTEM)/usr/keylayout/Vendor_045e_Product_0719.kl

# Media
PRODUCT_GENERIC_PROPERTIES += \
    media.recorder.show_manufacturer_and_model=true

# Needed by some RILs and for some GApps packages
PRODUCT_PACKAGES += \
    librsjni \
    libprotobuf-cpp-full

# Charger images
PRODUCT_PACKAGES += \
    charger_res_images

# ThemeOverlays
include packages/overlays/Themes/themes.mk

# Recommend using the non debug dexpreopter
USE_DEX2OAT_DEBUG ?= false
