AppName=FileRoller

all:$(AppName).app
	

PREFIX=$(HOME)/gtk/inst

file-roller.bundle:file-roller.bundle.in Makefile
	sed "s|@PREFIX@|$(PREFIX)|g" file-roller.bundle.in >file-roller.bundle
	

$(AppName).app:file-roller.bundle file-roller-launcher.sh Makefile file-roller.icns Info.plist
	gtk-mac-bundler file-roller.bundle
	

file-roller.icns:Makefile
	cmd=makeicns;\
	for f in 32 48 256 ; \
	do \
		fg="$(PREFIX)/share/icons/hicolor/$${f}x$${f}/apps/file-roller.png"; \
		test -f "$$fg" && cmd="$$cmd -$$f $$fg"; \
	done; \
	$$cmd -out file-roller.icns

clean:
	rm -rf "$(AppName).app" file-roller.bundle