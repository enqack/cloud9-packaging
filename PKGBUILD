# Maintainer: Leo von Klenze <leo@devel.von-klenze.de>
pkgname=cloud9
pkgver=0.6.0.20120318
pkgrel=1
pkgdesc="Cloud9 IDE - Your code anywhere, anytime. Open Source Javascript Cloud9 IDE"
arch=('i686' 'x86_64')
url="https://github.com/ajaxorg/cloud9"
license=('GPLv3')
provides=(cloud9)
conflicts=(cloud9)
source=()
noextract=()
md5sums=()
install=cloud9.install

build() {
}

package() {
  install -d "$pkgdir/opt/cloud9"
  install -d "$pkgdir/usr/bin"

  cp -R $srcdir/$_gitname/* $pkgdir/opt/$_gitname
  cp $srcdir/runcloud9 $pkgdir/opt/$_gitname/bin
  sed -ie 's/require.paths/\/\/ require.paths/g' $pkgdir/opt/cloud9/support/paths.js   
  ln -s "/opt/cloud9/bin/runcloud9" "$pkgdir/usr/bin/cloud9"
} 

