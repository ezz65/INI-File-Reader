# Makefile 
# Maciej Woloszyn (c) 2021-09-30


##------------ configuration -- begin ------------------------

# sending files:

PUBKEY := /home/staff/woloszyn/SWOS/file_upload_key.pub
DEST := /home/staff/woloszyn/SWOS/Upload/OOP

LIST := $(wildcard *.cpp *.c *.h *.hpp *.C *.java Makefile)

DATE := $(shell date +%Y%m%dT%H%M%S)
USER := $(shell whoami)
PROJ := $(shell basename "${PWD}")
BNAME := $(PROJ)_$(USER)_$(DATE)

FILETGZ := $(BNAME).tgz
FILEENC := $(BNAME).enc
RNDKEY := $(BNAME).key
RNDENC := $(BNAME).enk

# compilation and execution:

PROG := lab
CXXFLAGS :=  -MMD -MP -std=c++14 -Wall -Wextra -Wconversion -W -O0 -g
CXX := g++
RM := rm -f
SRC = $(wildcard *.cpp)
OBJECTS = $(SRC:%.cpp=%.o)

##------------ configuration -- end --------------------------

all : $(PROG)

$(PROG) : $(OBJECTS)
	$(CXX) $(OBJECTS) $(CXXLINKLIBS) -o $(PROG)

# include automatically generated dependencies:
-include $(SRC:%.cpp=%.d)

myfiles :
	@ls -R $(DEST) | grep $(USER) | grep enc | sed 's/\.enc/\.tgz/g'

send :
	@tar cvzf $(FILETGZ) $(LIST)
	@openssl rand -base64 -out $(RNDKEY) 32
	@openssl rsautl -encrypt -inkey $(PUBKEY) -pubin -in $(RNDKEY) -out $(RNDENC)
	@openssl enc -aes-256-cbc -pbkdf2 -salt -in $(FILETGZ) -out $(FILEENC) -pass file:./$(RNDKEY)
	@chmod 1644 $(FILEENC) $(RNDENC)
	@cp -a $(FILEENC) $(RNDENC) $(DEST)
	@echo " *** File $(FILETGZ) was sent. *** "
	@$(RM) $(RNDKEY) $(RNDENC) $(FILEENC)

tgz :
	tar cvzf $(FILETGZ) $(LIST)

clean:
	$(RM) *.o *.d

cleanall:
	$(RM) *~ *.o *.d $(PROG)

# end
