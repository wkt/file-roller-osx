AppName=File Roller

all:$(AppName).app
	

PREFIX=${HOME}/gtk/inst

file-roller.bundle:file-roller.bundle.in Makefile
	sed "s|@PREFIX@|$(PREFIX)|g" file-roller.bundle.in >file-roller.bundle
	

Info.plist:Info.plist.in Makefile
	sed "s|@AppName@|$(AppName)|g" Info.plist.in >Info.plist

$(AppName).app: file-roller.bundle launcher.sh Makefile file-roller.icns Info.plist
	@mkdir -p  $(PREFIX)/lib/
	@touch $(PREFIX)/lib/charset.alias
	gtk-mac-bundler file-roller.bundle
	make do_lproj
	@touch "$(AppName).app"
	

file-roller.icns:Makefile
	cmd=makeicns;\
	for f in 32 48 256 ; \
	do \
		fg="$(PREFIX)/share/icons/hicolor/$${f}x$${f}/apps/file-roller.png"; \
		test -f "$$fg" && cmd="$$cmd -$$f $$fg"; \
	done; \
	$$cmd -out file-roller.icns

do_lproj:
	for d in *.lproj ; \
	do \
		for s in $$d/*.strings; \
		do	\
			mkdir -p  "$(AppName).app/Contents/Resources/$${d}"; \
			plutil -convert binary1 -o "$(AppName).app/Contents/Resources/$${s}" $${s}; \
		done; \
	done

clean:
	rm -rf "$(AppName).app" file-roller.bundle Info.plist file-roller.icns