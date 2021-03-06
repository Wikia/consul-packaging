CONSUL_VERSION=0.5.2
REPLICATE_VERSION=0.2.0
TEMPLATE_VERSION=0.9.0
ENVCONSUL_VERSION=0.5.0

CONSUL_ITERATION=1
ENVCONSUL_ITERATION=2
REPLICATE_ITERATION=1
TEMPLATE_ITERATION=1

PACKAGER="Gavin M. Roy <gavinr@aweber.com>"
ARCH=amd64

all: consul consul-replicate consul-template consul-webui envconsul

clean:
	@( rm -rf build/* )
	@( rm -rf dist/* )

consul: dist/consul_${CONSUL_VERSION}-${CONSUL_ITERATION}_${ARCH}.deb

consul-replicate: dist/consul-replicate_${REPLICATE_VERSION}-${REPLICATE_ITERATION}_${ARCH}.deb

consul-template: dist/consul-template_${TEMPLATE_VERSION}-${TEMPLATE_ITERATION}_${ARCH}.deb

consul-webui: dist/consul-webui_${CONSUL_VERSION}-${CONSUL_ITERATION}_all.deb

envconsul: dist/envconsul_${ENVCONSUL_VERSION}-${ENVCONSUL_ITERATION}_${ARCH}.deb

dist/consul_${CONSUL_VERSION}-${CONSUL_ITERATION}_${ARCH}.deb: build/consul/usr/sbin/consul
	@( mkdir -p dist )
	@( echo "Building consul ${CONSUL_VERSION} package" )
	@( mkdir -p build/consul )
	@( cp -R templates/consul/* build/consul/ )
	@( fpm -s dir -t deb -m ${PACKAGER} -a ${ARCH} \
			-C build/consul \
			--package dist/consul_${CONSUL_VERSION}-${CONSUL_ITERATION}_${ARCH}.deb \
			--name consul --version ${CONSUL_VERSION} --iteration ${CONSUL_ITERATION} \
			--deb-changelog changes/consul \
			--category utils \
			--deb-default build/consul/etc/default/consul \
			--deb-upstart build/consul/etc/init/consul.conf \
			--provides consul \
			--description "Consul is a tool for service discovery, monitoring and configuration" . )

dist/consul-webui_${CONSUL_VERSION}-${CONSUL_ITERATION}_all.deb: build/consul-webui/usr/share/consul-webui
	@( mkdir -p dist )
	@( echo "Building consul-webui ${CONSUL_VERSION} package" )
	@( mkdir -p build/consul-webui )
	@( cp -R templates/consul-webui/* build/consul-webui/ )
	@( fpm -s dir -t deb -m ${PACKAGER} -a all \
			-C build/consul-webui \
			--deb-changelog changes/consul-webui \
			--depends consul \
			--category web \
			--package dist/consul-webui_${CONSUL_VERSION}-${CONSUL_ITERATION}_all.deb \
			--config-files etc/consul.d/10-webui.json \
			--name consul-webui --version ${CONSUL_VERSION} --iteration ${CONSUL_ITERATION} \
			--description "Consul Web UI" . )

dist/consul-replicate_${REPLICATE_VERSION}-${REPLICATE_ITERATION}_${ARCH}.deb: build/consul-replicate/usr/sbin/consul-replicate
	@( mkdir -p dist )
	@( echo "Building consul-replicate ${TEMPLATE_VERSION} package" )
	@( mkdir -p build/consul-replicate )
	@( cp -R templates/consul-replicate/* build/consul-replicate/ )
	@( fpm -s dir -t deb -m ${PACKAGER} -a ${ARCH} \
			-C build/consul-replicate \
			--package dist/consul-replicate_${REPLICATE_VERSION}-${REPLICATE_ITERATION}_${ARCH}.deb \
			--name consul-replicate --version ${REPLICATE_VERSION} --iteration ${REPLICATE_ITERATION} \
			--depends consul \
			--category utils \
			--deb-changelog changes/consul-replicate \
			--deb-default build/consul-replicate/etc/default/consul-replicate \
			--deb-upstart build/consul-replicate/etc/init/consul-replicate \
			--provides consul-replicate \
			--description "Consul cross-DC KV replication daemon" . )

dist/consul-template_${TEMPLATE_VERSION}-${TEMPLATE_ITERATION}_${ARCH}.deb: build/consul-template/usr/sbin/consul-template
	@( mkdir -p dist )
	@( echo "Building consul-template ${TEMPLATE_VERSION} package" )
	@( mkdir -p build/consul-template )
	@( cp -R templates/consul-template/* build/consul-template/ )
	@( fpm -s dir -t deb -m ${PACKAGER} -a ${ARCH} \
			-C build/consul-template \
			--name consul-template --version ${TEMPLATE_VERSION} --iteration ${TEMPLATE_ITERATION} \
			--package dist/consul-template_${TEMPLATE_VERSION}-${TEMPLATE_ITERATION}_${ARCH}.deb \
			--depends consul \
			--category utils \
			--deb-changelog changes/consul-template \
			--config-files etc/consul-template.d/00-default.hcl \
			--deb-default build/consul-template/etc/default/consul-template \
			--provides consul-template \
			--exclude /etc/conf/consul-template.conf.conf \
			--description "Generic template rendering and notifications with Consul" . )

dist/envconsul_${ENVCONSUL_VERSION}-${ENVCONSUL_ITERATION}_${ARCH}.deb: build/envconsul/usr/sbin/envconsul
	@( mkdir -p dist )
	@( echo "Building envconsul ${ENVCONSUL_VERSION} package" )
	@( mkdir -p build/envconsul )
	@( cp -R templates/envconsul/* build/envconsul/ )
	@( fpm -s dir -t deb -m ${PACKAGER} -a ${ARCH} \
			-C build/envconsul \
			--package dist/envconsul_${ENVCONSUL_VERSION}-${ENVCONSUL_ITERATION}_${ARCH}.deb \
			--name envconsul --version ${ENVCONSUL_VERSION} --iteration ${ENVCONSUL_ITERATION} \
			--deb-changelog changes/envconsul \
			--depends consul \
			--category utils \
			--config-files etc/envconsul.d/00-default.hcl \
			--deb-default build/envconsul/etc/default/envconsul \
			--deb-upstart build/envconsul/etc/init/envconsul \
			--provides envconsul \
			--description "Read and set environmental variables for processes from Consul" . )

build/consul/usr/sbin/consul:
	@( echo "Downloading consul ${CONSUL_VERSION}" )
	@( mkdir -p build/consul/usr/sbin/ )
	@( curl -s -o /tmp/${CONSUL_VERSION}_linux_${ARCH}.zip -L https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_linux_${ARCH}.zip )
	@( unzip -q -d build/consul/usr/sbin/ /tmp/${CONSUL_VERSION}_linux_${ARCH}.zip )
	@( rm /tmp/${CONSUL_VERSION}_linux_${ARCH}.zip )

build/consul-replicate/usr/sbin/consul-replicate:
	@( echo "Downloading consul-replicate ${REPLICATE_VERSION}" )
	@( mkdir -p build/consul-replicate/usr/sbin )
	@( curl -o build/consul-replicate/usr/sbin/consul-replicate -s -L https://github.com/hashicorp/consul-replicate/releases/download/v${REPLICATE_VERSION}/consul-replicate_linux_${ARCH} )
	@( chmod a+x build/consul-replicate/usr/sbin/consul-replicate )

build/consul-template/usr/sbin/consul-template:
	@( echo "Downloading consul-template ${TEMPLATE_VERSION}" )
	@( mkdir -p build/consul-template/usr/sbin )
	@( curl -s -L https://github.com/hashicorp/consul-template/releases/download/v${TEMPLATE_VERSION}/consul-template_${TEMPLATE_VERSION}_linux_${ARCH}.tar.gz | tar xvz -C build/consul-template/usr/sbin --strip-components=1 )

build/consul-webui/usr/share/consul-webui:
	@( echo "Downloading consul-webui ${CONSUL_VERSION}" )
	@( mkdir -p build/consul-webui/usr/share )
	@( curl -s -o /tmp/${CONSUL_VERSION}_web_ui.zip -L https://dl.bintray.com/mitchellh/consul/${CONSUL_VERSION}_web_ui.zip )
	@( unzip -q -d build/consul-webui/usr/share/ /tmp/${CONSUL_VERSION}_web_ui.zip )
	@( mv build/consul-webui/usr/share/dist build/consul-webui/usr/share/consul-webui )
	@( rm /tmp/${CONSUL_VERSION}_web_ui.zip )

build/envconsul/usr/sbin/envconsul:
	@( echo "Downloading envconsul ${ENVCONSUL_VERSION}" )
	@( mkdir -p build/envconsul/usr/sbin )
	@( curl -s -L https://github.com/hashicorp/envconsul/releases/download/v${ENVCONSUL_VERSION}/envconsul_${ENVCONSUL_VERSION}_linux_${ARCH}.tar.gz | tar xvz -C build/envconsul/usr/sbin --strip-components=1 )
