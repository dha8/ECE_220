
BIN=floorplanner

CXXFLAGS = -Wall -O3 -I/usr/include/cairo -I/usr/include/pixman-1 -I/usr/include/freetype2 -I/usr/include/libpng12

ARCH := $(shell getconf LONG_BIT)

LDFLAGS_32 = -ltest32
LDFLAGS_64 = -ltest64

LDFLAGS := -L./lib $(LDFLAGS_$(ARCH))  

$(BIN): main.c floorplan.c tLib_graphics.cpp floorplan.h tLib_graphics.h
	g++ $(CXXFLAGS) -c tLib_graphics.cpp -o tLib_graphics.o -lcairo
	g++ $(CXXFLAGS) -c floorplan.c -o floorplan.o  -lcairo
	g++ $(CXXFLAGS) -c main.c -o main.o -lcairo
	g++ $(CXXFLAGS) tLib_graphics.o floorplan.o main.o -lcairo $(LDFLAGS) -o $(BIN) 

.PHONY: clean
clean:
	rm floorplanner *.o *.png

circuit1: $(BIN)
	./$(BIN) circuits/circuit1.txt circuit1.png

circuit2: $(BIN)
	./$(BIN) circuits/circuit2.txt circuit2.png

circuit3: $(BIN)
	./$(BIN) circuits/circuit3.txt circuit3.png

circuit4: $(BIN)
	./$(BIN) circuits/circuit4.txt circuit4.png

circuit5: $(BIN)
	./$(BIN) circuits/circuit5.txt circuit5.png
