$(PROJROOT)/deps/unity:
	mkdir -p $(PROJROOT)/deps
	cd $(PROJROOT)/deps; \
	wget -q -O $(PROJROOT)/deps/unity.zip https://github.com/ThrowTheSwitch/Unity/archive/refs/tags/v2.6.0.zip; \
	unzip unity.zip; \
	mv ?nity-* unity; \
	rm unity.zip

$(PROJROOT)/deps/cmock:
	mkdir -p $(PROJROOT)/deps
	cd $(PROJROOT)/deps; \
	wget -q -O $(PROJROOT)/deps/cmock.zip https://github.com/ThrowTheSwitch/CMock/archive/refs/tags/v2.5.3.zip; \
	unzip cmock.zip; \
	mv ??ock-* cmock; \
	rm cmock.zip; \
	cd cmock; \
	bundle install
