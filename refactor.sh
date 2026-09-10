#!/bin/bash
echo "Refactoring Xlnk to pynq.allocate in Python source files..."

# Find all Python files and apply regex replacements using sed
find . -type f -name "*.py" -print0 | while IFS= read -r -d '' file; do
    # 1. Replace the import statement
    sed -i 's/from pynq import Xlnk/from pynq import allocate/g' "$file"
    
    # 2. Comment out Xlnk initialization
    sed -i 's/xlnk = Xlnk()/# xlnk = Xlnk()  # Replaced by pynq.allocate/g' "$file"
    
    # 3. Replace the cma_array method call with allocate
    sed -i 's/xlnk.cma_array/allocate/g' "$file"
    
    # 4. Comment out xlnk_reset calls
    sed -i 's/xlnk.xlnk_reset()/# xlnk.xlnk_reset()  # Handled automatically now/g' "$file"
done

echo "Source code successfully updated!"
