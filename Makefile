DISTNAME   = pixelserv
SRCS       = $(DISTNAME).c
VERSION   := $(shell git describe --tags)

OPTS      := -O3 -DDO_COUNT -DTEXT_REPLY -DREAD_FILE -DREAD_GIF -DNULLSERV_REPLIES -DSSL_RESP
TEST_OPTS := -DTEST -DVERBOSE
TINY_OPTS := -Os -DTINY
DEBUG_OPT := -DHEX_DUMP

CC        := gcc
CFLAGS    += -Wall -march=armv7-a -mfpu=neon -mfloat-abi=softfp -fgcse-las -fgcse-sm -fipa-pta -fivopts -fomit-frame-pointer -frename-registers -fsection-anchors -ftree-loop-im -ftree-loop-ivcanon -funsafe-loop-optimizations -funswitch-loops -fweb -fgraphite -fgraphite-identity -floop-block -floop-interchange -floop-nest-optimize -floop-parallelize-all -floop-strip-mine -fmodulo-sched -fmodulo-sched-allow-regmoves -ffunction-sections -fdata-sections -fvisibility=hidden -s -flto -fPIC -fPIE -pie -DNDEBUG -D__ANDROID__ -DANDROID --sysroot=/root/ndkTC/sysroot -DBUILD_USER="$(USER)" -DVERSION="$(VERSION)"
LDFLAGS   += -llog -Wl,-O3 -Wl,--as-needed -Wl,--relax -Wl,--sort-common -Wl,--gc-sections -Wl,-flto -fPIE -fPIC -pie
STRIP     := strip -s -R .note -R .comment -R .gnu.version -R .gnu.version_r

ARMTOOLS  := /root/ndkTC/sysroot/bin/
ARMPREFIX := arm-linux-androideabi-
ARMCC     := $(ARMPREFIX)$(CC)
ARMSTRIP  := $(ARMPREFIX)$(STRIP) -R .note -R .comment -R .gnu.version -R .gnu.version_r

all: arm
	@echo "Builds in dist folder."

dist:
	@mkdir dist

arm: dist
	PATH=$(ARMTOOLS):$(PATH) $(ARMCC) $(CFLAGS) $(LDFLAGS) $(OPTS) $(SRCS) -o dist/$(DISTNAME).$@
	PATH=$(ARMTOOLS):$(PATH) $(ARMCC) $(CFLAGS) $(LDFLAGS) $(TINY_OPTS) $(SRCS) -o dist/$(DISTNAME).tiny.$@
	PATH=$(ARMTOOLS):$(PATH) $(ARMSTRIP) dist/$(DISTNAME).$@
	PATH=$(ARMTOOLS):$(PATH) $(ARMSTRIP) dist/$(DISTNAME).tiny.$@
