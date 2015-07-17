# Zend Framework 1.x for use at Imagine Easy

 * no `require_once` (unless it breaks the component code)
 * removed a couple components (Zend_Amf, Zend_Barcode, Zend_Dojo, Zend_Ldap, Zend_Markup, Zend_Pdf, Zend_Search, Zend_Tag, Zend_Text)
 * patched `Zend_Registry` to make it compatible to HHVM

## Usage

```
$ make all
```

If you don't use Linux, start Vagrant:

```
$ vagrant up
$ vagrant ssh
$ cd /vagrant
$ make all
```
