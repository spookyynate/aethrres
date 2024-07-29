# Architecture (x86 or x64)
ARCHITECTURE ?= x64

# Set architecture-specific flags
ifeq ($(ARCHITECTURE),x86)
    ARCHITECTURE_FLAGS = -m32
else
    ARCHITECTURE_FLAGS = -m64
endif

CXX = g++
CXXFLAGS = -Wall -Wextra -std=c++20 -DUNICODE -D_UNICODE -O2 $(ARCHITECTURE_FLAGS)
LDFLAGS = $(ARCHITECTURE_FLAGS)

ROOT = alphares
BIN = $(ROOT)/bin
LIB = $(ROOT)/lib
SRC = $(ROOT)/src
INCLUDE = $(ROOT)/include
LIBRARY = $(LIB)/simpleini
RESOURCES = $(ROOT)/resources
RC = $(RESOURCES)/resources.rc
RES_OBJ = $(RESOURCES)/resources.o

# Source and object files
SOURCES = $(wildcard $(SRC)/*.cpp)
OBJECTS = $(SOURCES:.cpp=.o)
EXECUTABLE = alphares

# Library
LIBS = -lgdi32 -luser32 -mwindows
INCLUDES = -I$(INCLUDE) -I$(LIBRARY)

.PHONY: all clean

# Main build target
all: | $(BIN)
	$(MAKE) $(EXECUTABLE)

# Creating the "bin" directory
$(BIN):
	mkdir -p $(BIN)

# Linking
$(EXECUTABLE): $(OBJECTS) $(RES_OBJ)
	$(CXX) $(CXXFLAGS) $(OBJECTS) $(RES_OBJ) -o $(BIN)/$(EXECUTABLE) $(LIBS) $(INCLUDES) $(LDFLAGS) -static -s

# Compiling C++ source files
$(SRC)/%.o: $(SRC)/%.cpp
	$(CXX) $(CXXFLAGS) $(INCLUDES) -c $< -o $@

# Compiling resources
$(RES_OBJ): $(RC)
	windres $< -O coff -o $@

# Full clean-up
distclean:
	rm -f $(SRC)/*.o $(BIN)/$(EXECUTABLE) $(RES_OBJ)

# Clean-up
clean:
	rm -f $(SRC)/*.o $(RES_OBJ)
