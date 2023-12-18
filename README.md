# Electron Wrapper
---

Electron wrapper用来包装任何一个网页到一个Electron应用。目前引用了应用商店的`com.electron`包作为依赖。并使用ingredients中的nodejs作为构建依赖（你也可以不使用ingredients，仅需添加`BUILD_DEPENDS="npm"`并删除`export INGREDIENTS=...`，然后将build.sh中的所有pnpm改成npm即可。）

使用方法：

复制template文件夹到包名，并修改其中的build.sh中的：

```bash
export PACKAGE=""
export NAME=""
export NAME_CN=""
export URL="icon.png::icon-url"
export HOMEPAGE="" # wrapper content
```

这五个环境变量声明。其中URL用来下载图标，icon-url应当替换成图标的地址，图标不能是ico格式。

HOMEPAGE的值就是会被包装的网页的链接。

你也可以在build.sh所在的文件夹下放置任意js文件，以注入到加载后的网页里面。
