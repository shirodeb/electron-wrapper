export PACKAGE="com.mihoyo.ys-cloud"
export NAME="Cloud Genshin"
export NAME_CN="云·原神"
export VERSION="1.0.0"
export ARCH="all"
export URL="icon.png::https://ys.mihoyo.com/cloud/img/logo_home_header.82e54fa5.png"
export DO_NOT_UNARCHIVE=1
# autostart,notification,trayicon,clipboard,account,bluetooth,camera,audio_record,installed_apps
export REQUIRED_PERMISSIONS=""

export HOMEPAGE="https://ys.mihoyo.com/cloud/"
# export DEPENDS="libgconf-2-4, libgtk-3-0, libnotify4, libnss3, libxtst6, xdg-utils, libatspi2.0-0, libdrm2, libgbm1, libxcb-dri3-0, kde-cli-tools | kde-runtime | trash-cli | libglib2.0-bin | gvfs-bin, deepin-elf-verify"
export DEPENDS="com.electron"
export BUILD_DEPENDS="npm"
export SECTION="misc"
export PROVIDE=""
export DESC1="Electron wrapper for $HOMEPAGE"
export DESC2=""

export INGREDIENTS=(nodejs)

function build() {
    cp "$ROOT_DIR/templates/index.js" "$SRC_DIR/index.js"
    cp "$ROOT_DIR/templates/run.sh" "$APP_DIR/files/run.sh"
    cat "$ROOT_DIR/templates/package.json" | envsubst >"$SRC_DIR/package.json"

    pushd "$SRC_DIR"

    export ELECTRON_MIRROR=https://npm.taobao.org/mirrors/electron/
    pnpm install --registry=https://registry.npm.taobao.org
    pnpm run build
    cp -RT out/linux-unpacked/resources $APP_DIR/files/resources
    mkdir -p "$APP_DIR/files/userscripts"
    cp "$ROOT_DIR"/*.js "$APP_DIR/files/userscripts/"

    popd

    utils.icon.collect $SRC_DIR "-maxdepth 1"
    rm -rf $APP_DIR/entries/icons/hicolor/**/apps/icon.png

    mkdir -p "$APP_DIR/entries/applications"
    cat <<EOF >$APP_DIR/entries/applications/$PACKAGE.desktop
[Desktop Entry]
Name=$NAME
Name[zh_CN]=$NAME_CN
Exec=env PACKAGE=$PACKAGE /opt/apps/$PACKAGE/files/run.sh %U
Terminal=false
Type=Application
Icon=$PACKAGE
StartupWMClass=$PACKAGE
Categories=Utility;
EOF
    return 0
}
