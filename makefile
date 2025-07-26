all: tubeeditor.asm tubeeditor.rom 

tubeeditor.asm: tubeeditor.py TubeEditor-1.03.rom
	PYTHONPATH=./py8dis/py8dis python3 tubeeditor.py --output tubeeditor.asm

tubeeditor.rom: tubeeditor.asm
	beebasm -i $< -o $@
