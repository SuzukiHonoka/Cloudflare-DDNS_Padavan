BIN_NAME=cf
SRC_NAME=$(BIN_NAME).sh
BIN_URL=https://github.com/SuzukiHonoka/Cloudflare_DDNS
SRC_URL=https://raw.githubusercontent.com/SuzukiHonoka/Cloudflare-DDNS_Padavan/master/$(SRC_NAME)
BIN_PATH=/usr/bin
BUILD_PATH=$(THISDIR)/build
DIST_PATH=$(BUILD_PATH)/src

THISDIR = $(shell pwd)

all: bin_download src_download
	export GOPATH=$(BUILD_PATH)
	mkdir $(BUILD_PATH)/bin
	export GOBIN=$GOPATH/bin
	cd $(DIST_PATH)/$(BIN_NAME)
	go get ./...
	GOOS=linux GOARCH=mipsle go build -o $(BIN_NAME) main.go
	$(CONFIG_CROSS_COMPILER_ROOT)/bin/mipsel-linux-uclibc-strip $(BIN_NAME)
	upx --best --lzma $(BIN_NAME)

bin_download:
	( if [ ! -d $(DIST_PATH) ];then \
		mkdir -p $(DIST_PATH); \
		cd $(DIST_PATH); \
		git clone --depth=1 $(BIN_URL) $(BIN_NAME); \
	fi )
	

src_download:
	( if [ ! -f $(SRC_NAME) ]; then \
		wget $(SRC_URL); \
	fi )

clean:
	rm -rf $(BUILD_PATH) && rm $(THISDIR)/$(SRC_NAME)

romfs:
	$(ROMFSINST) -p +x $(DIST_PATH)/$(BIN_NAME)/$(BIN_NAME) $(BIN_PATH)/$(BIN_NAME)
	$(ROMFSINST) -p +x $(THISDIR)/$(SRC_NAME) $(BIN_PATH)/$(SRC_NAME)
