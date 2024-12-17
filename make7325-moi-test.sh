#!/bin/bash

DEFAULT_DEVICE_DIRECTORY="$CROWN_KERNEL_DIRECTORY"

# Kernel Source Paths
CROWN_KERNEL_DIRECTORY=/home/moi/kernel_samsung_moi_sm7325/

TOOLCHAINS_DIRECTORY=/home/moi/aarch64-linux-android-4.9-043

TOOLCHAINS_DIRECTORY2=/home/moi/clang-r383902b1


AIK_N960=/home/moi/AnyKernel3

ZIP_MOVE="/home/moi/Zip"
ZIP_N960=/home/moi/MCK-A52S/
PERM_CROWNIMG_DIR="/home/moi/kernel_samsung_moi_sm7325/N960"


# Password for AIK sudo
PASSWORD="moi"


## Kernel Directory

	cd "$CROWN_KERNEL_DIRECTORY" || exit

#cp Makefile.moi2 Makefile

export ARCH=arm64
export SUBARCH=arm64
export HEADER_ARCH=arm64
export PROJECT_NAME=a52sxq
export PATH=/usr/local/bin/ccache:$PATH

	export BUILD_CROSS_COMPILE=$TOOLCHAINS_DIRECTORY"/bin/aarch64-linux-android-"


	export PATH=$TOOLCHAINS_DIRECTORY2"/bin:$PATH"
	export PLATFORM_VERSION=12
	export ANDROID_MAJOR_VERSION=12
	export CONFIG_SECTION_MISMATCH_WARN_ONLY=y
	export CROSS_COMPILE_ARM32=$TOOLCHAINS_DIRECTORY"/bin/aarch64-linux-android-"
	export CC=$TOOLCHAINS_DIRECTORY2"/bin/clang"
	export AR=$TOOLCHAINS_DIRECTORY2"/bin/llvm-ar"
	export NM=$TOOLCHAINS_DIRECTORY2"/bin/llvm-nm"
	export OBJCOPY=$TOOLCHAINS_DIRECTORY2"/bin/llvm-objcopy"
	export OBJDUMP=$TOOLCHAINS_DIRECTORY2"/bin/llvm-objdump"
	export STRIP=$TOOLCHAINS_DIRECTORY2"/bin/llvm-strip"
	export KERNEL_LLVM_BIN=$TOOLCHAINS_DIRECTORY2"/bin/clang"
	export REAL_CC="/usr/local/bin/ccache "$KERNEL_LLVM_BIN
	export CLANG_TRIPLE="aarch64-linux-gnu-"
	CCACHE_EXEC=/usr/local/bin/ccache
	$_CCACHE_EXEC -M 8G
	LLVM_CCACHE_BUILD=ON
	CCACHE_CPP2=yes
	export USE_CCACHE=1
	mkdir -p "$TOOLCHAINS_DIRECTORY"/bin/ccache/bin/


clear



while read -p "git reset ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
git reset --hard origin/oneui-ksu

		rm -R out
		echo
		echo "done."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

while read -p "patch A52S ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
# disable CRC
		cd ~/kernel_samsung_moi_sm7325/drivers/mmc/core
		cp core.c.moi core.c

#boeffala
		cd ~/kernel_samsung_moi_sm7325/drivers/base/power
		cp Makefile.moi Makefile		
#		cp main.c.moi main.c
		cp wakeup.c.moi wakeup.c
		cd ~/kernel_samsung_moi_sm7325/kernel/power
		cp Kconfig.moi Kconfig
#define VM_READAHEAD_PAGES	(SZ_512K / PAGE_SIZE)
		cd ~/kernel_samsung_moi_sm7325/include/linux
		cp mm.h.moi mm.h
#virer KSU
		cd ~/kernel_samsung_moi_sm7325/drivers/
		cp Kconfig.moi Kconfig
		cp Makefile.moi Makefile
#
	
		
		cd ~/kernel_samsung_moi_sm7325/
		echo "patched."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

while read -p "clean ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
# modif démarrage kernel origine

		rm -R out
		make -j64 -C $(pwd)  clean
		make -j64 -C $(pwd) M=$(PWD) clean
		make -j64 -C $(pwd)  mrproper
		echo
		echo "cleaned."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done

DATE_START=$(date +"%s")


while read -p "Build LLD ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
	
mkdir out						

#sed -i -e 's/#define THERMAL_MAX_TRIPS	12/#define THERMAL_MAX_TRIPS	16/g' "/home/moi/kernel_samsung_moi_sm7325/include/linux/thermal.h"


#	KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"
#		export ARCH=arm64
		set -e
		set -o pipefail

		PATH=/usr/local/bin/ccache:${PATH} make -j$(nproc --all) -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc PROJECT_NAME=a52sxq CONFIG_SEC_A52SXQ_PROJECT=y $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC='ccache '$KERNEL_LLVM_BIN HOSTCC="ccache clang" AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip LLVM=1 vendor/moi_a52sxq_eur_open_defconfig

#		PATH=/usr/local/bin/ccache:${PATH} make -j$(nproc --all) -C $(pwd) O=$(pwd)/out DTC_EXT=$(pwd)/tools/dtc PROJECT_NAME=a52sxq CONFIG_SEC_A52SXQ_PROJECT=y $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE REAL_CC='ccache '$KERNEL_LLVM_BIN HOSTCC="ccache clang" AR=llvm-ar NM=llvm-nm OBJCOPY=llvm-objcopy OBJDUMP=llvm-objdump STRIP=llvm-strip LLVM=1
		
		export ARCH=arm64
		export LLVM=1
		export CLANG_PREBUILT_BIN=$KERNEL_LLVM_BIN
		export PATH=$PATH:$CLANG_PREBUILT_BIN:/usr/local/bin/ccache
#		KERNEL_LLVM_BIN=/root/Desktop/clang/bin/clang
		CLANG_TRIPLE=aarch64-linux-gnu-
		KERNEL_MAKE_ENV="CONFIG_BUILD_ARM64_DT_OVERLAY=y"


		make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y vendor/moi_a52sxq_eur_open_defconfig
#		make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC=$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y menuconfig
		make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y
		make -j8 -C $(pwd) O=$(pwd)/out $KERNEL_MAKE_ENV ARCH=arm64 CROSS_COMPILE=$BUILD_CROSS_COMPILE CC='ccache '$KERNEL_LLVM_BIN CLANG_TRIPLE=$CLANG_TRIPLE CONFIG_SECTION_MISMATCH_WARN_ONLY=y modules_install INSTALL_MOD_STRIP=1 INSTALL_MOD_PATH=kernel_modules
		

		set +e
		set +o pipefail
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done



while read -p "create zip mkbootimg ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )
	RAMFS_TMP=../mkbootimg-dir2
	rm "$RAMFS_TMP"/mesa.zip
		rm "$RAMFS_TMP"/zip/mesa/eur/dtbo.img
		rm "$RAMFS_TMP"/zip/mesa/eur/boot.img
		cp "$CROWN_KERNEL_DIRECTORY"out/arch/arm64/boot/Image "$RAMFS_TMP"/Image
		cp "$CROWN_KERNEL_DIRECTORY"out/arch/arm64/boot/dtbo.img "$RAMFS_TMP"/zip/mesa/eur/dtbo.img
		rm "$RAMFS_TMP"/zip/vendor/lib/modules/*.ko
		\cp $(find ./out/* -name '*.ko') "$RAMFS_TMP"/zip/vendor/lib/modules
		find "$RAMFS_TMP"/zip/vendor/lib/modules -type f -name "*.ko" -print0 | xargs -0 -n1 "${BUILD_CROSS_COMPILE}strip" --strip-unneeded

python3 /home/moi/android_system_tools_mkbootimg/mkbootimg.py \
    --kernel "$RAMFS_TMP"/Image \
    --ramdisk "$RAMFS_TMP"/boot.img-ramdisk.cpio.gz \
    --cmdline 'console=null androidboot.hardware=qcom androidboot.memcg=1 lpm_levels.sleep_disabled=1 video=vfb:640x400,bpp=32,memsize=3072000 msm_rtb.filter=0x237 service_locator.enable=1 androidboot.usbcontroller=a600000.dwc3 swiotlb=0 loop.max_part=7 cgroup.memory=nokmem,nosocket firmware_class.path=/vendor/firmware_mnt/image pcie_ports=compat loop.max_part=7 iptable_raw.raw_before_defrag=1 ip6table_raw.raw_before_defrag=1 printk.devkmsg=on' \
    --dtb "$RAMFS_TMP"/dtb \
    --base           0x00000000 \
    --pagesize       4096 \
    --kernel_offset  0x00008000 \
    --ramdisk_offset 0x02000000 \
    --tags_offset    0x01e00000 \
    --os_version     '11.0.0'\
    --os_patch_level '2024-01-00' \
    --header_version '3' \
    -o "$RAMFS_TMP"/boot.img		
	


		cp "$RAMFS_TMP"/boot.img "$RAMFS_TMP"/zip/mesa/eur/boot.img
		cd "$RAMFS_TMP"/zip || exit
		echo "$PASSWORD" | zip -r9 ../mesa.zip * 
		cd "$CROWN_KERNEL_DIRECTORY"
		cp "$RAMFS_TMP"/mesa.zip "$ZIP_N960"MOI_9GXH2_KSU-moi.zip



		echo
		echo "created."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done


while read -p "patch old N960 ?(y/n)? " cchoice
do
case "$cchoice" in
	y|Y )

sed -i -e 's/CONFIG_DEFAULT_BIC=y/CONFIG_DEFAULT_HTCP=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"



# # ##modif # CONFIG_DEFAULT_TCP_CONG="westwood"
sed -i -e 's/CONFIG_DEFAULT_TCP_CONG="bic"/CONFIG_DEFAULT_TCP_CONG="htcp"/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"


# add CONFIG_LITTLE_CPU_MASK=15
if ! grep -q "CONFIG_LITTLE_CPU_MASK=15" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_NR_CPUS=8/CONFIG_NR_CPUS=8\
CONFIG_LITTLE_CPU_MASK=15/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

# add CONFIG_BIG_CPU_MASK=240
if ! grep -q "CONFIG_BIG_CPU_MASK=240" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_LITTLE_CPU_MASK=15/CONFIG_LITTLE_CPU_MASK=15\
CONFIG_BIG_CPU_MASK=240/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

# # ##modif #  CONFIG_PELT_UTIL_HALFLIFE_16 is not set
sed -i -e 's/CONFIG_PELT_UTIL_HALFLIFE_16=y/# CONFIG_PELT_UTIL_HALFLIFE_16 is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"



# # ##modif #  CONFIG_PELT_UTIL_HALFLIFE_10=y
sed -i -e 's/# CONFIG_PELT_UTIL_HALFLIFE_10 is not set/CONFIG_PELT_UTIL_HALFLIFE_10=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"


#modif #  CONFIG_HZ_250 is not set
sed -i -e 's/CONFIG_HZ_250=y/# CONFIG_HZ_250 is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# #modif CONFIG_HZ=250 > CONFIG_HZ=500
sed -i -e 's/CONFIG_HZ=250/CONFIG_HZ=500/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# modif ajout CONFIG_HZ_500=y
if  grep -q "CONFIG_HZ=500" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_HZ=500/CONFIG_HZ=500\
CONFIG_HZ_500=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi
# # #modif CONFIG_HZ_500 is not set > CONFIG_HZ_500=y
sed -i -e 's/# CONFIG_HZ_500 is not set/CONFIG_HZ_500=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# modif CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y
sed -i -e 's/CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL=y/# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# add CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTILX=y
if ! grep -q "CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTILX=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set/# CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL is not set\
CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTILX=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

#modif CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set
sed -i -e 's/CONFIG_CPU_FREQ_GOV_SCHEDUTIL=y/# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

#add CONFIG_CPU_FREQ_GOV_SCHEDUTILX=y
if ! grep -q "CONFIG_CPU_FREQ_GOV_SCHEDUTILX=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set/# CONFIG_CPU_FREQ_GOV_SCHEDUTIL is not set\
CONFIG_CPU_FREQ_GOV_SCHEDUTILX=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi
#--------------------------------------------------------------------------

# add CONFIG_BATTERY_SAVER=y
 if ! grep -q "CONFIG_BATTERY_SAVER=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_MORO_SOUND=y/CONFIG_MORO_SOUND=y\
CONFIG_BATTERY_SAVER=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi


# # # modif CONFIG_ZSWAP_SAME_PAGE_SHARING=y
sed -i -e 's/# CONFIG_ZSWAP_SAME_PAGE_SHARING is not set/CONFIG_ZSWAP_SAME_PAGE_SHARING=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"


sed -i -e 's/CONFIG_ZRAM_DEFAULT_COMP_ALGORITHM="zstd"/CONFIG_ZRAM_DEFAULT_COMP_ALGORITHM="lz4"/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # add CONFIG_INCREASE_MAXIMUM_SWAPPINESS=y,CONFIG_FIX_INACTIVE_RATIO=y
if ! grep -q "CONFIG_INCREASE_MAXIMUM_SWAPPINESS=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_ZSMALLOC_STAT=y/CONFIG_ZSMALLOC_STAT=y\
CONFIG_INCREASE_MAXIMUM_SWAPPINESS=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

#test uclamp

 if ! grep -q "CONFIG_UCLAMP_TASK=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
 then
 sed -i -e 's/CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y/CONFIG_ARCH_SUPPORTS_NUMA_BALANCING=y\
CONFIG_UCLAMP_TASK=y\
CONFIG_UCLAMP_TASK_GROUP=y\
CONFIG_UCLAMP_BUCKETS_COUNT=15/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
 fi

# # replace 128 CONFIG_VM_MAX_READAHEAD=512
sed -i -e 's/CONFIG_VM_MAX_READAHEAD=128/CONFIG_VM_MAX_READAHEAD=64/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # modif  # CONFIG_LOD_SEC is not set
sed -i -e 's/CONFIG_LOD_SEC=y/# CONFIG_LOD_SEC is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # modif  CONFIG_TIMA is not set
sed -i -e 's/CONFIG_TIMA=y/# CONFIG_TIMA is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # modif  CONFIG_TIMA_LKMAUTH is not set
sed -i -e 's/CONFIG_TIMA_LKMAUTH=y/# CONFIG_TIMA_LKMAUTH is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # modif  CONFIG_TIMA_LKM_BLOCK is not set
sed -i -e 's/CONFIG_TIMA_LKM_BLOCK=y/# CONFIG_TIMA_LKM_BLOCK is not set/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"

# # add CONFIG_KAIR=y,CONFIG_SCHED_KAIR_GLUE=y
if ! grep -q "CONFIG_KAIR=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_SBITMAP=y/CONFIG_SBITMAP=y\
CONFIG_KAIR=y\
CONFIG_SCHED_KAIR_GLUE=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

#add IRQ 990 https://github.com/RaySlash/android_kernel_samsung_exynos990/
if ! grep -q "CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_GENERIC_IRQ_SHOW_LEVEL=y/CONFIG_GENERIC_IRQ_SHOW_LEVEL=y\
CONFIG_GENERIC_IRQ_EFFECTIVE_AFF_MASK=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

if ! grep -q "CONFIG_GENERIC_IRQ_MULTI_HANDLER=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_SPARSE_IRQ=y/CONFIG_SPARSE_IRQ=y\
CONFIG_GENERIC_IRQ_MULTI_HANDLER=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

# ADD CONFIG_BOEFFLA_WL_BLOCKER
if ! grep -q "CONFIG_BOEFFLA_WL_BLOCKER=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_SCHED_KAIR_GLUE=y/CONFIG_SCHED_KAIR_GLUE=y\
CONFIG_BOEFFLA_WL_BLOCKER=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

if ! grep -q "CONFIG_NET_UDP_TUNNEL=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/# CONFIG_NET_UDP_TUNNEL is not set/CONFIG_NET_UDP_TUNNEL=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

if ! grep -q "# CONFIG_GENEVE is not set" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
 sed -i -e 's/CONFIG_BOEFFLA_WL_BLOCKER=y/CONFIG_BOEFFLA_WL_BLOCKER=y\
# CONFIG_GENEVE is not set\
# CONFIG_GTP is not set\
CONFIG_WIREGUARD=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi
#--------- disable temp
# ajout : CONFIG_DEVFREQ_BOOST
if ! grep -q "CONFIG_DEVFREQ_BOOST=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
 sed -i -e 's/CONFIG_ARM_EXYNOS9810_BUS_DEVFREQ=y/CONFIG_ARM_EXYNOS9810_BUS_DEVFREQ=y\
CONFIG_DEVFREQ_BOOST=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

if ! grep -q "CONFIG_DEVFREQ_INPUT_BOOST_DURATION_MS" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/CONFIG_DEVFREQ_BOOST=y/CONFIG_DEVFREQ_BOOST=y\
CONFIG_DEVFREQ_INPUT_BOOST_DURATION_MS=64\
CONFIG_DEVFREQ_WAKE_BOOST_DURATION_MS=250\
CONFIG_DEVFREQ_EXYNOS_MIF_BOOST_FREQ=845000\
CONFIG_DEVFREQ_EXYNOS_MIF_LIGHT_INPUT_BOOST_FREQ=676000/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

#test NOK NAD
if ! grep -q "CONFIG_SEC_NAD_HPM=y" "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
then
sed -i -e 's/# CONFIG_SEC_NAD_HPM is not set/CONFIG_SEC_NAD_HPM=y/g' "/home/moi/kernel_samsung_moi_sm7325/arch/arm64/configs/exynos9810-crownlte_defconfig"
fi

		   cd /home/moi/kernel_samsung_moi_sm7325/
		   cp Makefile.moi Makefile


		  cd /home/moi/kernel_samsung_moi_sm7325/drivers/cpufreq
			cp Kconfig.moi3 Kconfig
#  			modif https://github.com/AndreiLux/linux/commit/f4e619a446cdb357a98379570231093c0aab14fe :  Ignore ECT max frequency limits
		  cp exynos-acme.c.moi5 exynos-acme.c
#freq max 2886000
		 cd /home/moi/Note9-ZeusKernelQ-OneUI-AOSP/AIK3-N960-Q
			 cp anykernel.sh.moi anykernel.sh
		 cd /home/moi/Note9-ZeusKernelQ-OneUI-AOSP/AIK3-N960-Q/vendor/etc
			 cp /home/moi/Note9-ZeusKernelQ-OneUI-AOSP/fstab.samsungexynos9810 ./fstab.samsungexynos9810
# schedutilx
		   cd /home/moi/kernel_samsung_moi_sm7325/kernel/sched/
			 cp Makefile.moi Makefile

#-----------------------------------------------------
			  cp cpufreq.c.moi cpufreq.c
#-----------------------------------------------------

		 cd ~/kernel_samsung_moi_sm7325/include/linux
#test uclamp
			  cp cpufreq.h.moi5a cpufreq.h
#test
			  cp kobject.h.moi kobject.h
			  cp log2.h.moi log2.h
				 cp tick.h.moi tick.h
#modif pour new schedutilx
			 cd ~/kernel_samsung_ascendia_sm7325/kernel/time
				 cp tick-sched.c.moi tick-sched.c
			cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/cpufreq
#test cpufreq_driver_fast_switch
			  cp cpufreq.c.moi6 cpufreq.c
			  cp cpufreq_governor.c.moi cpufreq_governor.c
#---------------------------------------------------------
# #test
		   cd ~/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/
				cp exynos-hotplug_governor.c.moi22f exynos-hotplug_governor.c

# #test
# #BUG GOV SINGLE
			 cp exynos-cpu_hotplug.c.moi exynos-cpu_hotplug.c
# #BUG ??? > non
			 cd ~/kernel_samsung_ascendia_sm7325/include/soc/samsung
			 cp exynos-dm.h.moi exynos-dm.h
#test moi
			 cd ~/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/
# test mod freq governor
			 cp exynos-dm.c.moi3 exynos-dm.c

# #modif init services :
		  cd /home/moi/Note9-ZeusKernelQ-OneUI-AOSP
			 rm ~/Note9-ZeusKernelQ-OneUI-AOSP/AIK3-N960-Q/vendor/etc/init/init.services.rc
			 rm ~/Note9-ZeusKernelQ-OneUI-AOSP/AIK3-N960-Q/UPDATE-AnyKernel3.zip
 			  cp ./init.services.rc.moi.4 ~/Note9-ZeusKernelQ-OneUI-AOSP/AIK3-N960-Q/vendor/etc/init/init.services.rc 
		 cd ~/kernel_samsung_ascendia_sm7325/arch/arm64/boot/dts/
		 rm -R -f ~/kernel_samsung_ascendia_sm7325/arch/arm64/boot/dts/exynos
		cp -R exynos.moi exynos
		 cd ~/kernel_samsung_ascendia_sm7325/arch/arm64/boot/dts/exynos
		cp exynos9810-crownlte_eur_open_26.dts.moi5 exynos9810-crownlte_eur_open_26.dts 
# # tests domains
		 cd /home/moi/kernel_samsung_ascendia_sm7325/kernel/sched/

# # bug 195000 limit 
		 cd ~/kernel_samsung_ascendia_sm7325/drivers/thermal/samsung
		cp exynos_tmu.c.moi1 exynos_tmu.c
		 cd ~/kernel_samsung_ascendia_sm7325/drivers/thermal/
		 cp of-thermal.c.moi of-thermal.c
		 cp power_allocator.c.moi power_allocator.c
		 cd ~/kernel_samsung_ascendia_sm7325/kernel

# #modif IRQ hotplug
		 cd ~/kernel_samsung_ascendia_sm7325/kernel/irq
		cp cpuhotplug.c.990 cpuhotplug.c
		cp internals.h.moi internals.h
		cp generic-chip.c.moi generic-chip.c
		cp manage.c.moi15 manage.c
		cp chip.c.moi chip.c
		cp autoprobe.c.moi autoprobe.c
		cp proc.c.moi proc.c
		cp devres.c.moi devres.c
		cp handle.c.moi handle.c
		cp migration.c.moi migration.c
		cp msi.c.moi msi.c
		cp irqdomain.c.moi irqdomain.c
		cp Kconfig.moi Kconfig
		cp Makefile.moi Makefile
		 cd ~/kernel_samsung_ascendia_sm7325/arch/arm/kernel
		 cp irq.c.moi irq.c
		 cd ~/kernel_samsung_ascendia_sm7325/include/linux
		cp irq.h.moi irq.h
		cp irqdesc.h.moi irqdesc.h
		cp msi.h.moi msi.h
		cp irqdomain.h.moi irqdomain.h
		cp fwnode.h.moi fwnode.h
		cp property.h.moi property.h
		cp of.h.moi of.h
		 cp kthread.h.moi kthread.h
		 cd ~/kernel_samsung_ascendia_sm7325/arch/arm64
		 cp Kconfig.moi2 Kconfig
		cd ~/kernel_samsung_ascendia_sm7325/drivers/of
		cp base.c.moi base.c
		cd ~/kernel_samsung_ascendia_sm7325/drivers/irqchip
		cp Kconfig.moi Kconfig
		cd ~/kernel_samsung_ascendia_sm7325/arch/arm
		cp Kconfig.moi Kconfig
		cd ~/kernel_samsung_ascendia_sm7325/arch/arm64/include/asm
		cp irq.h.moi irq.h
		cd ~/kernel_samsung_ascendia_sm7325/arch/arm64/kernel
		cp irq.c.moi irq.c
#FIN #modif IRQ hotplug


#-----------------------------------------------------
# #test uclamp
		  cd ~/kernel_samsung_ascendia_sm7325/include/uapi/linux
		  cp sched.h.moi2 sched.h
		  cd ~/kernel_samsung_ascendia_sm7325/include/linux
		  cp spinlock.h.moi spinlock.h
		  cp cpuset.h.moi cpuset.h
		  cp cgroup.h.moi cgroup.h
		  cd ~/kernel_samsung_ascendia_sm7325/kernel/
# #BUG!	sleeping function called from invalid context	 
		 cp cpuset.c.moi cpuset.c
		  cp cgroup.c.moi cgroup.c
		  cd ~/kernel_samsung_ascendia_sm7325/init
		  cp Kconfig.moi4 Kconfig

# # modifs fin https://github.com/synt4x93/android_kernel_samsung_universal9810
		  cd ~/kernel_samsung_ascendia_sm7325/kernel/sched/
		  cp deadline.c.moi4 deadline.c

#sans EAS :
		cp core.c.moi12xy1 core.c
#-----------------------------------------------------

		  cd ~/kernel_samsung_ascendia_sm7325/include/linux
		  cp sched.h.moi8 sched.h


# disable CRC
	cd ~/kernel_samsung_ascendia_sm7325/drivers/mmc/core
	cp core.c.moi core.c

#UCLamp
cd ~/kernel_samsung_ascendia_sm7325/include/linux/sched
	cp sysctl.h.moi sysctl.h
cd ~/kernel_samsung_ascendia_sm7325/kernel
	cp sysctl.c.moi sysctl.c
	cp fork.c.moi2 fork.c

#thermal: limit polling work queue to CPU0/1
#https://github.com/THEBOSS619/Note9-ZeusKernelQ-OneUI-AOSP/commit/750604e67c26ed275c1ee3c7de6c0ba2fcf3eaa4
#drivers: thermal: Don't qualify thermal polling as high priority
#https://github.com/THEBOSS619/Note9-ZeusKernelQ-OneUI-AOSP/commit/1055bb5266d1b744039c19a6e3976c77812678d9
	cd ~/kernel_samsung_ascendia_sm7325/drivers/thermal/
		cp thermal_core.c.moi thermal_core.c
#thermal: Increase thermal trip points to 16
#https://github.com/THEBOSS619/Note9-ZeusKernelQ-OneUI-AOSP/commit/22a93b6d03c107d1220220849764c8359ad42c46
	cd ~/kernel_samsung_ascendia_sm7325/include/linux/
		cp thermal.h.moi thermal.h

#https://github.com/RaySlash/android_kernel_samsung_exynos990/commit/371bf42732694d142b0de026e152266c039b97d3
cd ~/kernel_samsung_ascendia_sm7325/kernel/sched/
	cp freqvar_tune.c.moi freqvar_tune.c

#https://github.com/torvalds/linux/commit/82762d2af31a60081162890983a83499c9c7dd74
		cp sched.h.moi7 sched.h
#	cp fair.c.moi10a fair.c
#https://github.com/torvalds/linux/commit/82762d2af31a60081162890983a83499c9c7dd74
	cp fair.c.moi11 fair.c
	cp rt.c.moi rt.c
#KAIR
cd ~/kernel_samsung_ascendia_sm7325/lib
	cp Kconfig.moi Kconfig
	cp Makefile.moi Makefile
		cd  ~/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/exynos9810/
		cp cmucal-node.c.moi cmucal-node.c
#boeffala

#		cd ~/kernel_samsung_ascendia_sm7325/drivers/base/power
#		cp boeffla_wl_blocker.h.moi boeffla_wl_blocker.h
#		cp boeffla_wl_blocker.c.moi boeffla_wl_blocker.c
#		cp Makefile.moi Makefile
#		cp main.c.moi main.c
#		cp wakeup.c.moi wakeup.c
#		cd ~/kernel_samsung_ascendia_sm7325/drivers/base
#		cp Kconfig.moi Kconfig
#		cd ~/kernel_samsung_ascendia_sm7325/kernel/power
#		cp Kconfig.moi Kconfig
# ajout : CONFIG_DEVFREQ_BOOST
		cd ~/kernel_samsung_ascendia_sm7325/drivers/devfreq/
			cp Makefile.moi Makefile
			cp Kconfig.moi Kconfig
# mod https://github.com/topser9/kernel_samsung_universal7885/commit/c6c399466d74085f5552b077452280db49ec46f7
			cp devfreq.c.moi devfreq.c
		cd ~/kernel_samsung_ascendia_sm7325/drivers/devfreq/exynos
# mod https://github.com/topser9/kernel_samsung_universal7885/commit/c6c399466d74085f5552b077452280db49ec46f7
		cp exynos-devfreq.c.moi3 exynos-devfreq.c
#test debug
		cp exynos9810_bus_mif.c.moi3 exynos9810_bus_mif.c
		cp exynos9810_bus_int.c.moi exynos9810_bus_int.c
		cd ~/kernel_samsung_ascendia_sm7325/include/linux/
		cp devfreq.h.moi devfreq.h

#modif CAL
		cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/exynos9810
		cp pmucal_cp_exynos9810.h.moi pmucal_cp_exynos9810.h
			cp cmucal-node.c.zeus2 cmucal-node.c
			cp cmucal-vclk.c.test cmucal-vclk.c
			cp cmucal-vclklut.c.moi cmucal-vclklut.c
			cp cmucal-vclklut.h.moi cmucal-vclklut.h
		cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/
#test https://github.com/ThunderStorms21th/Galaxy-S10/tree/master/drivers/soc/samsung/cal-if
			cp acpm_dvfs.c.moi acpm_dvfs.c
			cp acpm_dvfs.h.moi acpm_dvfs.h
		cp cmucal.h.moi cmucal.h
			cp cmucal.h.zeus cmucal.h
			cp ra.c.zeus ra.c
#test https://github.com/ThunderStorms21th/Galaxy-S10/tree/master/drivers/soc/samsung/cal-if
			cp vclk.c.moi vclk.c
		cp fvmap.c.moi fvmap.c
		cp Makefile.moi Makefile
		cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/
		cp Kconfig.moi Kconfig
		
#test desactivation Argos
		cd ~/kernel_samsung_ascendia_sm7325/drivers/pci/host
# test https://github.com/topser9/kernel_samsung_m30/commit/3442968ef015c7a8f4d95cbf3537a1cc7e086966
		cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/
		cp fvmap.c.moi2 fvmap.c
# test https://github.com/topser9/kernel_samsung_m30/commit/f628e9b52d8c763938ef777b9ffac8b684bd0961
		cd ~/kernel_samsung_ascendia_sm7325/drivers/soc/samsung
		cp ect_parser.c.moi2 ect_parser.c
# test CONFIG_EXYNOS_WD_DVFS
		cd ~/kernel_samsung_ascendia_sm7325/drivers/devfreq
		cp governor_simpleinteractive.c.moi governor_simpleinteractive.c
		
# test 9611
		cd ~/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/exynos9810
		cd /home/moi/kernel_samsung_ascendia_sm7325/drivers/soc/samsung/cal-if/
# test modif regulator vdd2_mem + vddq_mem
		cd ~/kernel_samsung_ascendia_sm7325/drivers/regulator/
		cd ~/kernel_samsung_ascendia_sm7325/mm/
		cp Kconfig.moi Kconfig

cd ~/kernel_samsung_ascendia_sm7325/
		echo
		echo "patched."
		break
		;;
	n|N )
		break
		;;
	* )
		echo
		echo "Invalid try again!"
		echo
		;;
esac
done









