MODNAME		:= SunFixer
KSPDIR		:= ${HOME}/ksp/KSP_linux
MANAGED		:= ${KSPDIR}/KSP_Data/Managed
GAMEDATA	:= ${KSPDIR}/GameData
MODGAMEDATA := ${GAMEDATA}/${MODNAME}
PLUGINDIR	:= ${MODGAMEDATA}/Plugins

TARGETS		:= ${MODNAME}.dll

MOD_FILES := \
	SunFixer.cs		\
	$e

DOC_FILES := \
	License.txt \
	README.md

RESGEN2		:= resgen2
GMCS		:= mcs
GMCSFLAGS	:= -optimize -warnaserror -unsafe
GIT			:= git
TAR			:= tar
ZIP			:= zip

SUBDIRS=

all: ${TARGETS}
	@for dir in ${SUBDIRS}; do \
		make -C $$dir $@ || exit 1; \
	done

.PHONY: version
version:
	@../tools/git-version.sh

info:
	@echo "${MODNAME} Build Information"
	@echo "    resgen2:    ${RESGEN2}"
	@echo "    gmcs:       ${GMCS}"
	@echo "    gmcs flags: ${GMCSFLAGS}"
	@echo "    git:        ${GIT}"
	@echo "    tar:        ${TAR}"
	@echo "    zip:        ${ZIP}"
	@echo "    KSP Data:   ${KSPDIR}"

${MODNAME}.dll: ${MOD_FILES}
	${GMCS} ${GMCSFLAGS} -t:library -lib:${MANAGED} \
		-r:Assembly-CSharp,Assembly-CSharp-firstpass \
		-r:UnityEngine,UnityEngine.UI \
		-out:$@ $^

clean:
	@for dir in ${SUBDIRS}; do \
		make -C $$dir $@ || exit 1; \
	done
	rm -f ${TARGETS} Assembly/AssemblyInfo.cs

install: all
	@for dir in ${SUBDIRS}; do \
		make -C $$dir $@ || exit 1; \
	done
	mkdir -p ${PLUGINDIR}
	cp ${TARGETS} ${PLUGINDIR}
	cp ${DOC_FILES} ${MODGAMEDATA}

.PHONY: all clean install
