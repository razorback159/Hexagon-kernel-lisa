# SPDX-License-Identifier: GPL-2.0


obj-$(CONFIG_LIBNVDIMM) += libnvdimm.o
obj-$(CONFIG_BLK_DEV_PMEM) += nd_pmem.o
obj-$(CONFIG_ND_BTT) += nd_btt.o
obj-$(CONFIG_ND_BLK) += nd_blk.o
obj-$(CONFIG_X86_PMEM_LEGACY) += nd_e820.o
obj-$(CONFIG_OF_PMEM) += of_pmem.o
obj-$(CONFIG_VIRTIO_PMEM) += virtio_pmem.o nd_virtio.o

nd_pmem-y := pmem.o

nd_btt-y := btt.o

nd_blk-y := blk.o

nd_e820-y := e820.o

libnvdimm-y := core.o
libnvdimm-y += bus.o
libnvdimm-y += dimm_devs.o
libnvdimm-y += dimm.o
libnvdimm-y += region_devs.o
libnvdimm-y += region.o
libnvdimm-y += namespace_devs.o
libnvdimm-y += label.o
libnvdimm-y += badrange.o
libnvdimm-$(CONFIG_ND_CLAIM) += claim.o
libnvdimm-$(CONFIG_BTT) += btt_devs.o
libnvdimm-$(CONFIG_NVDIMM_PFN) += pfn_devs.o
libnvdimm-$(CONFIG_NVDIMM_DAX) += dax_devs.o
libnvdimm-$(CONFIG_NVDIMM_KEYS) += security.o

TOOLS := ../../tools
TEST_SRC := $(TOOLS)/testing/nvdimm/test
obj-$(CONFIG_NVDIMM_TEST_BUILD) += $(TEST_SRC)/iomap.o
