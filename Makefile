ver = 2.9

all: docker

original_meshmixer_$(ver)_amd64.deb:
	wget https://s3.amazonaws.com/autodesk-meshmixer/meshmixer/amd64/meshmixer_$(ver)_amd64.deb -O $@


meshmixer_$(ver)_amd64.deb: original_meshmixer_$(ver)_amd64.deb
	rm -rf deb 2> /dev/null || :
	mkdir -p deb/DEBIAN
	dpkg -e $< deb/DEBIAN/
	dpkg -x $< deb/
	head deb/DEBIAN/postinst -n`grep ldconfig deb/DEBIAN/postinst -n | tail -n 1 | cut -d: -f1` > deb/DEBIAN/postinstnew
	mv deb/DEBIAN/postinst{new,}
	chmod +x deb/DEBIAN/postinst
	dpkg -b deb $@

docker: Dockerfile meshmixer_$(ver)_amd64.deb
	docker build -t meshmixer .

clean:
	rm *.deb 2> /dev/null || :
	rm -rf deb 2> /dev/null || :

.PHONY: clean docker all
