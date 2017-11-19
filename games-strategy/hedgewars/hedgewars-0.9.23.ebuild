# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# TODO: when physfs-2.1.0 hits the tree, set
# -DPHYSFS_SYSTEM=ON

EAPI=5
CMAKE_BUILD_TYPE=Release
CMAKE_MAKEFILE_GENERATOR=emake
inherit cmake-utils eutils games

MY_P=${PN}-src-${PV}
DESCRIPTION="A turn-based strategy, artillery, action and comedy game"
HOMEPAGE="http://hedgewars.org/"
SRC_URI="http://www.hedgewars.org/download/releases/${MY_P}.tar.bz2"

LICENSE="GPL-2 Apache-2.0 FDL-1.3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
QA_FLAGS_IGNORED=${GAMES_BINDIR}/hwengine # pascal sucks
QA_PRESTRIPPED=${GAMES_BINDIR}/hwengine # pascal sucks

RDEPEND="
	dev-lang/lua:0=
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	media-libs/freeglut
	media-libs/libpng:0
	media-libs/libsdl[sound,opengl,video]
	media-libs/sdl2-image[png]
	media-libs/sdl2-mixer[vorbis]
	media-libs/sdl2-net
	media-libs/sdl2-ttf
	sys-libs/zlib
	virtual/ffmpeg"
DEPEND="${RDEPEND}
	>=dev-lang/fpc-2.4"
RDEPEND="${RDEPEND}
	app-arch/xz-utils
	media-fonts/wqy-zenhei
	>=media-fonts/dejavu-2.28"

S=${WORKDIR}/${MY_P}

src_configure() {
	local mycmakeargs=(
	    -DCMAKE_BUILD_TYPE=Debug
		-DMINIMAL_FLAGS=ON
		-DCMAKE_INSTALL_PREFIX="/usr"
		-DDATA_INSTALL_DIR="${GAMES_DATADIR}/${PN}"
		-Dtarget_binary_install_dir="${GAMES_BINDIR}"
		-Dtarget_library_install_dir="$(games_get_libdir)"
		-DNOSERVER=TRUE
		-DCMAKE_VERBOSE_MAKEFILE=TRUE
		-DPHYSFS_SYSTEM=OFF
	)
	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	DOCS="ChangeLog.txt README" cmake-utils_src_install
	#rm -f "${D}"/usr/share/games/hedgewars/Data/Fonts/{DejaVuSans-Bold.ttf,wqy-zenhei.ttc}
	#dosym /usr/share/fonts/dejavu/DejaVuSans-Bold.ttf \
	#	"${GAMES_DATADIR}"/hedgewars/Data/Fonts/DejaVuSans-Bold.ttf
	#dosym /usr/share/fonts/wqy-zenhei/wqy-zenhei.ttc \
#		"${GAMES_DATADIR}"/hedgewars/Data/Fonts/wqy-zenhei.ttc
	doicon misc/hedgewars.png
	make_desktop_entry ${PN} Hedgewars
	doman man/${PN}.6
	prepgamesdirs
}