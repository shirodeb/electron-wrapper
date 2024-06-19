export PACKAGE="com.mihoyo.sr-cloud"
export NAME="Honkai:Star Rail CloudGame"
export NAME_CN="云·崩坏星穹铁道"
export VERSION="1.0.0"
export ARCH="all"
export URL="icon.png::https://webstatic.mihoyo.com/common/clgm-web-app/sr/img/logo_home_header.d98f2de5.png"
export DO_NOT_UNARCHIVE=1
# autostart,notification,trayicon,clipboard,account,bluetooth,camera,audio_record,installed_apps
export REQUIRED_PERMISSIONS=""
export INGREDIENTS=(nodejs)
export HOMEPAGE="https://sr.mihoyo.com/cloud/#/" # wrapper content
export DEPENDS="com.electron"
#export BUILD_DEPENDS="npm"
export SECTION="misc"
export PROVIDE=""
export DESC1="Electron wrapper for $HOMEPAGE"
export DESC2=""


function build() {
    cp "$ROOT_DIR/templates/index.js" "$SRC_DIR/index.js"
    cp "$ROOT_DIR/templates/run.sh" "$APP_DIR/files/run.sh"
    cat "$ROOT_DIR/templates/package.json" | envsubst >"$SRC_DIR/package.json"

    pushd "$SRC_DIR"

    npm install
    npm run build
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
Categories=Games;
EOF
    return 0
}
