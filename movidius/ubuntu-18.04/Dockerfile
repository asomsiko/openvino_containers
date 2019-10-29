FROM ubuntu:18.04 AS build

# hadolint ignore=DL3008
RUN apt-get update && apt-get install -y --no-install-recommends \
  ca-certificates \
  build-essential \
  aria2 \
  tar \
  autoconf \
  automake \
  libtool \
  cpio \
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
RUN aria2c -x8 -q "https://registrationcenter-download.intel.com/akdlm/irc_nas/15944/l_openvino_toolkit_p_2019.3.334.tgz" \
   && tar xf l_openvino_toolkit_p_2019.3.334.tgz
RUN echo "ACCEPT_EULA=accept" > silent.cfg                        && \
    echo "CONTINUE_WITH_OPTIONAL_ERROR=yes" >> silent.cfg         && \
    echo "PSET_INSTALL_DIR=/build/openvino" >> silent.cfg         && \
    echo "CONTINUE_WITH_INSTALLDIR_OVERWRITE=yes" >> silent.cfg   && \
    echo "COMPONENTS=DEFAULTS" >> silent.cfg                      && \
    echo "COMPONENTS=ALL" >> silent.cfg                           && \
    echo "PSET_MODE=install" >> silent.cfg                        && \
    echo "INTEL_SW_IMPROVEMENT_PROGRAM_CONSENT=no" >> silent.cfg  && \
    echo "SIGNING_ENABLED=yes" >> silent.cfg
RUN ./l_openvino_toolkit_p_2019.3.334/install.sh --ignore-signature --cli-mode -s silent.cfg
RUN mkdir -p /install/lib/x86_64-linux-gnu/ \
   && cp ./openvino/deployment_tools/inference_engine/lib/intel64/*.so* /install/lib/x86_64-linux-gnu/ \
   && cp ./openvino/deployment_tools/inference_engine/lib/intel64/*.mvcmd /install/lib/x86_64-linux-gnu/ \
   && cp ./openvino/deployment_tools/inference_engine/lib/intel64/plugins.xml /install/lib/x86_64-linux-gnu/ \
   && cp -r ./openvino/deployment_tools/inference_engine/lib/intel64/vpu_custom_kernels /install/lib/x86_64-linux-gnu/ \
   && cp ./openvino/deployment_tools/inference_engine/external/tbb/lib/*.so* /install/lib/x86_64-linux-gnu/

FROM ubuntu:18.04

COPY --from=build /install /usr/local
RUN ldconfig
