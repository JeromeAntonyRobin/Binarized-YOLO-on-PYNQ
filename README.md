# Binarized-YOLO-on-PYNQ

A hardware-accelerated Binarized Neural Network (BNN) object detection framework for PYNQ edge devices. 

By deploying an aggressively quantized (1-bit weight, 3-bit activation) Tinier-YOLO Convolutional Neural Network, this project swaps heavy floating-point math for raw FPGA logic gate execution. Offloading these multi-layer binarized convolutions directly to the programmable logic achieves massive CPU-to-FPGA speed multipliers (~150x) while tracking 20 object classes on the PASCAL VOC dataset.

## PYNQ v2.7+ Modernization

This project is a natively modernized version of the original legacy QNN-MO-PYNQ architecture. The original codebase relied on the deprecated `Xlnk` memory allocator, which causes immediate crashes on modern PYNQ images. 

All Python source code in this repository has been natively refactored to use the modern `pynq.allocate` function. It now works flawlessly out-of-the-box on PYNQ v2.7+ (Ubuntu 20.04) without requiring any terminal hacks or legacy patches.

## Quick Start

Deploying the project to your existing SD card is entirely possible, but it means bypassing the custom environment the author prepared. In order to install it on your PYNQ board, connect to the board, open a terminal, and type:

    sudo pip3 install git+https://github.com/JeromeAntonyRobin/Binarized-YOLO-on-PYNQ.git

**NOTE:** The board has to be connected to the internet. The installation can take up to 10 minutes, since dependencies must be resolved and sources compiled.

This will install the QNN package to your board, and create a `qnn` directory in the Jupyter home area. You will find the Jupyter notebooks to test the QNN overlays in this directory.

## Repository Organization

The repo is organized as follows:

*   **`qnn/`**: Contains the `TinierYolo` and `DoReFaNet` python class descriptions as well as the classes for the test networks.
    *   **`src/`**: Finely-tuned HLS C++ source code and drivers for the overlays to rebuild them.
*   **`bitstreams/`**: Pre-compiled hardware overlays ready for immediate deployment.
*   **`params/`**: Set of trained parameters for the overlays:
    *   A pruned version of DoReFa-Net network, trained on the ImageNet dataset with 1-bit weights and 2-bit activations.
    *   A modified version of Tiny Yolo, namely Tinier-Yolo, trained on the PASCAL VOC dataset with 1-bit weights and 3-bit activations.
*   **`notebooks/`**: Lists a set of python notebook examples that during installation will be moved into the `/home/xilinx/jupyter_notebooks/qnn/` folder.
*   **`tests/`**: Contains test scripts and test images.

## Hardware Design Rebuild (Optional)

*Disclaimer: Pre-built bitstreams are already included! You only need to follow these steps if you wish to modify the physical HLS C++ hardware architecture from scratch.*

In order to rebuild the hardware designs, the repo should be cloned in a machine with an installation of the Vivado Design Suite (tested with 2017.4). Following the step-by-step instructions:

1.  Clone the repository on your linux machine: `git clone https://github.com/JeromeAntonyRobin/Binarized-YOLO-on-PYNQ.git`
2.  Move to `clone_path/Binarized-YOLO-on-PYNQ/qnn/src/network/`
3.  Set the `XILINX_QNN_ROOT` environment variable to `clone_path/Binarized-YOLO-on-PYNQ/qnn/src/`
4.  Launch the shell script `make-hw.sh` with parameters for the target network, platform, and mode: `./make-hw.sh {network} {platform} {mode}`
    *   `network` can be W1A2 or W1A3.
    *   `platform` can be pynqz1-z2 or ultra96.
    *   `mode` can be `h` to launch Vivado HLS synthesis, `b` to launch the Vivado project, or `a` to launch both.
5.  Results are placed in `output/`, containing the bitstreams, HLS reports, Vivado projects, and generated RTL.
