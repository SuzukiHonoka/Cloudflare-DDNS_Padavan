BIN_NAME=cf
SRC_NAME=$(BIN_NAME).sh
BIN_URL=https://github.com/SuzukiHonoka/Cloudflare_DDNS
SRC_URL=https://raw.githubusercontent.com/SuzukiHonoka/Cloudflare-DDNS_Padavan/master/$(SRC_NAME)
BIN_PATH=/usr/bin

THISDIR = $(shell pwd)

all: bin_download src_download
	cd $(BIN_NAME)
	go get ./...
	GOOS=linux GOARCH=mipsle go build -o cf main.go
	$(CONFIG_CROSS_COMPILER_ROOT)/bin/mipsel-linux-uclibc-strip $(BIN_NAME)/$(BIN_NAME)
	upx --best --lzma $(BIN_NAME)/$(BIN_NAME)

bin_download:
	( if [ ! -d $(BIN_NAME) ];then \
		git clone --depth=1 $(BIN_URL) $(BIN_NAME); \
	fi )
	

src_download:
	( if [ ! -f $(SRC_NAME) ]; then \
		wget $(SRC_URL); \
	fi )

clean:
	rm -rf $(THISDIR)/$(BIN_NAME) && rm $(THISDIR)/$(SRC_NAME)

romfs:
	$(ROMFSINST) -p +x $(THISDIR)/$(BIN_NAME)/$(BIN_NAME) $(BIN_PATH)/$(BIN_NAME)
	$(ROMFSINST) -d $(THISDIR)/$(SRC_NAME) $(BIN_PATH)/$(SRC_NAME)
