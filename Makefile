# Makefile for semi-automatically importing a new zf1 version

.PHONY: download move composer-cleanup zf-cleanup strip-require patch
all:    download move composer-cleanup zf-cleanup strip-require patch

download:
	@echo ==================== download
	./composer.phar require zendframework/zendframework1

move: download
	@echo ==================== moving files
	rm -rf library/Zend
	mv vendor/zendframework/zendframework1/library/Zend/ library/

composer-cleanup: move
	@echo ==================== composer cleanup
	rm -r vendor
	rm    composer.lock
	git checkout -- composer.json

zf-cleanup: move
	@echo ==================== deleting unused modules
	rm -rf library/Zend/Amf*
	rm -rf library/Zend/Barcode*
	rm -rf library/Zend/Dojo*
	rm -rf library/Zend/EventManager*
	rm -rf library/Zend/Gdata/Analytics*
	rm -rf library/Zend/Ldap*
	rm -rf library/Zend/Markup*
	rm -rf library/Zend/Mobile*
	rm -rf library/Zend/Pdf*
	rm -rf library/Zend/Search*
	rm -rf library/Zend/Stdlib*
	rm -rf library/Zend/Tag*
	rm -rf library/Zend/Text*
	rm -rf library/Zend/Validate/Ldap*

strip-require: move
	@echo ==================== removing require_once
	# do not strip require_once from:
	# * Zend_Loader_Autoloader
	# * Zend_Application*
	# * Zend_Tool*
	cd ./library/Zend
	find . -name '*.php' \
		-not -wholename '*/Loader/Autoloader.php' \
		-not -wholename '*/Application*' \
		-not -wholename '*/Tool*' \
		-print0 | \
		xargs -0 sed --regexp-extended --in-place \
			-e 's/(require_once)/\/\/ \1/g'
	cd ../..

patch: move strip-require
	@echo ==================== applying patches
	cat patches/*.patch | patch -p0
