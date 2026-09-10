#!/bin/bash
echo "Applying BNN backward compatibility patch for modern PYNQ OS..."
PYNQ_INIT="/usr/local/share/pynq-venv/lib/python3.8/site-packages/pynq/__init__.py"

if grep -q "class Xlnk:" "$PYNQ_INIT"; then
    echo "Success: Patch is already present! Skipping injection."
else
    sudo bash -c "cat << 'EOF' >> $PYNQ_INIT

# Backward compatibility patch for legacy QNN Xlnk memory allocation
class Xlnk:
    def __init__(self):
        pass
    def cma_array(self, shape, dtype='float32'):
        from pynq import allocate
        return allocate(shape=shape, dtype=dtype)
    def xlnk_reset(self):
        pass
EOF"
    echo "Success: Patch successfully injected into the global PYNQ library."
fi
