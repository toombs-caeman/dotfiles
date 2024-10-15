BUILD_DIR = archlive
FSROOT = $(BUILD_DIR)/airootfs

info:
	: iso : make an arch installation image (using archiso)
	: usb : copy an image to usb

iso:
	# this config is based off of the default at releng
	cp -r /usr/share/archiso/configs/releng/ $(BUILD_DIR)
	# add extra requirements for bootstrap environment
	echo 'fzf' >> $(BUILD_DIR)/packages.x86_64
	# copy install scripts and add permissions
	cp bootstrap post-install $(FSROOT)/usr/local/bin/
	echo 'file_permissions+=(["/usr/local/bin/post-install"]="0:0:755" ["/usr/local/bin/bootstrap"]="0:0:755")' >> $(BUILD_DIR)/profiledef.sh
	cp README.md archinstall.json *.jpg $(FSROOT)/root/
	false
	sudo mkarchiso -v -r -w /tmp/archiso-tmp -o . $(BUILD_DIR)
	@rm -rf $(BUILD_DIR)

clean:
	# if making the iso fails half way then BUILD_DIR isn't removed
	rm -rf $(BUILD_DIR)

usb:
	@image="$$(find . -name "*.iso" | fzf -0 -1)"; \
	if [ -z "$$image" ]; then echo no image found; exit 1; fi; \
	device="$$(lsblk -ndo PATH -Q 'RM == 1' | fzf -0 -1)"; \
	if [ -z "$$device" ]; then echo no device selected; exit 1; fi; \
	echo install "$$image" to "$$device?"; \
	read; \
	dd bs=4M if="$$image" of="$$device" conv=fsync oflag=direct status=progress
