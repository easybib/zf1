#!/bin/sh

### This is still from SVN - will not work with git.
### TO BE FIXED!

exit 1

version=$1
if [ "x${version}" = "x" ]; then
    echo "No version, please: $0 1.1.2"
    exit 1
fi

remote="http://framework.zend.com/releases/ZendFramework-${version}/ZendFramework-${version}-minimal.tar.gz"

wget $remote
if [ "$?" != 0 ]; then
    echo "Failed to download file."
    exit 1
fi

tar -zxvf ZendFramework-${version}-minimal.tar.gz
if [ "$?" != 0 ]; then
    echo "Failed to extract file."
    exit 1
fi

mv ./ZendFramework-${version}-minimal/library/Zend ./Zend-${version}
if [ "$?" != 0 ]; then
    echo "Couldn't move framework files."
    exit 1
fi

svn add ./Zend-${version}
svn ci -m "initial checkin of ZF ${version}" ./Zend-${version}

# do not strip require_once from:
# * Zend_Loader_Autoloader
# * Zend_Application*
# * Zend_Tool*
cd ./Zend-${version}
find . -name '*.php' \
    -not -wholename '*/Loader/Autoloader.php' \
    -not -wholename '*/Application*' \
    -not -wholename '*/Tool*' \
    -print0 | \
    xargs -0 sed --regexp-extended --in-place 's/(require_once)/\/\/ \1/g'

cd ..

svn ci -m 'strip require_once' Zend-${version}
svn up Zend-${version}

svn rm Zend-${version}/Amf*
svn rm Zend-${version}/Barcode*
svn rm Zend-${version}/Dojo*
svn rm Zend-${version}/Ldap*
svn rm Zend-${version}/Markup*
svn rm Zend-${version}/Pdf*
svn rm Zend-${version}/Search*
svn rm Zend-${version}/Tag*
svn rm Zend-${version}/Text*

svn ci -m 'remove Zend_Amf, Zend_Barcode, Zend_Dojo, Zend_Ldap, Zend_Markup, Zend_Pdf, Zend_Search, Zend_Tag, Zend_Text' Zend-${version}/

echo "Done";
