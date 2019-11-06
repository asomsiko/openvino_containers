FROM ubuntu:18.04 AS build

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  cmake \
  aria2 \
  tar \
  autoconf \
  automake \
  libtool \
  cpio \
  rsync \
  python3 \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /build/libusb
RUN aria2c -x8 -q "https://github.com/libusb/libusb/releases/download/v1.0.23/libusb-1.0.23.tar.bz2" \
   && tar xf libusb-1.0.23.tar.bz2
WORKDIR /build/libusb/libusb-1.0.23
RUN ./configure --disable-udev --enable-shared --prefix=/install --libdir="\${prefix}/lib/x86_64-linux-gnu" \
   && make -j"$(nproc)" \
   && make install

WORKDIR /build/openvino
RUN aria2c -x8 -q "http://registrationcenter-download.intel.com/akdlm/irc_nas/16057/l_openvino_toolkit_p_2019.3.376.tgz" \
   && tar xf l_openvino_toolkit_p_2019.3.376.tgz
RUN echo "ACCEPT_EULA=accept" > silent.cfg                        && \
    echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> silent.cfg         && \
    echo "PSET_INSTALL_DIR=/build/openvino" >> silent.cfg         && \
    echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> silent.cfg   && \
    echo "COMPONENTS=DEFAULTS" >> silent.cfg                      && \
    echo "COMPONENTS=ALL" >> silent.cfg                           && \
    echo "PSET_MODE=install" >> silent.cfg                        && \
    echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> silent.cfg  && \
    echo "SIGNING_ENABLED=yes" >> silent.cfg
RUN ./l_openvino_toolkit_p_2019.3.376/install.sh --ignore-signature --cli-mode -s silent.cfg

RUN ./openvino/deployment_tools/tools/deployment_manager/deployment_manager.py --targets vpu --output_dir . --archive_name openvino_deploy_package \
   && mkdir -p openvino_deploy_package \
   && tar xf openvino_deploy_package.tar.gz --directory openvino_deploy_package \
   && rsync -avm --include='*.so*' --include='*.xml' --include='*.bin' --include='*.mvcmd' --filter 'hide,! */' openvino_deploy_package/* /install \
   && rsync -avm --include='*.so*' --filter 'hide,! */' ./openvino/opencv /install/openvino

RUN ./openvino/inference_engine/samples/build_samples.sh

RUN mkdir -p /install/bin \
   && cp /root/inference_engine_samples_build/intel64/Release/lib/*.so* /install/lib/x86_64-linux-gnu/ \
   && cp /root/inference_engine_samples_build/intel64/Release/benchmark_app /install/bin/

FROM ubuntu:18.04

COPY --from=build /install /usr/local/
RUN ldconfig \
   /usr/local/lib/x86_64-linux-gnu/ \
   /usr/local/openvino/opencv/lib/ \
   /usr/local/openvino/deployment_tools/inference_engine/lib/intel64/ \
   /usr/local/openvino/deployment_tools/inference_engine/external/tbb/lib/
