include $(ROOTDIR)/makefiles/platforms.mk

VERSION = $(shell cat $(ROOTDIR)/fbreader/VERSION)
MAKE = make ROOTDIR=$(ROOTDIR)
LIBMAKE = $(MAKE) ZLSHARED=$(ZLSHARED)

include $(ROOTDIR)/makefiles/arch/$(TARGET_ARCH).mk

BINDIR ?= $(INSTALLDIR)/bin
LIBDIR ?= $(INSTALLDIR)/lib
INCDIR ?= $(INSTALLDIR)/include
SHAREDIR ?= $(INSTALLDIR)/share
BASEDIR ?= $(SHAREDIR)

XML_LIBS ?= -lexpat
ARCHIVER_LIBS ?= -lz -lbz2
NETWORK_LIBS ?= -lcurl

CFLAGS += -DINSTALLDIR=\"$(INSTALLDIR)\" -DBASEDIR=\"$(BASEDIR)\" -DLIBDIR=\"$(LIBDIR)\" -DIMAGEDIR=\"$(IMAGEDIR)\" -DAPPIMAGEDIR=\"$(APPIMAGEDIR)\" -DVERSION=\"$(VERSION)\"
ifeq "$(ZLSHARED)" "yes"
  CFLAGS += -fPIC -DZLSHARED
endif

ifeq "$(TARGET_STATUS)" "release"
	CFLAGS += -O3
	LDFLAGS += -s
endif
ifeq "$(TARGET_STATUS)" "debug"
	CFLAGS += -O0 -g
endif
ifeq "$(TARGET_STATUS)" "profile"
	CFLAGS += -O3 -g -pg
endif

ZINCLUDE = -I $(ROOTDIR)/zlibrary/core/include -I $(ROOTDIR)/zlibrary/text/include

ZLSHARED ?= yes

ifeq "$(ZLSHARED)" "yes"
  CORE_LIBS = -lm -L$(ROOTDIR)/zlibrary/core -lzlcore -ldl
	TEXT_LIBS = -lzltext
else
  CORE_LIBS = -lm -L$(ROOTDIR)/zlibrary/ui -L$(ROOTDIR)/zlibrary/core -lzlcore -lzlui-$(UI_TYPE) -lzlcore $(UILIBS) $(XML_LIBS) $(ARCHIVER_LIBS) $(NETWORK_LIBS)
	TEXT_LIBS = -lzltext $(EXTERNAL_LIBS) -llinebreak -lfribidi
endif

ifneq "$(BUILD_RESOURCE_OBJECT)" "yes"
.resources:
endif
