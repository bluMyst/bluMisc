CC=moonc
CFLAGS=

all: *.lua prototypes/*.lua

%.lua: %.moon
	$(CC) $(CFLAGS) $<

prototypes/%.lua: prototypes/%.moon
	$(CC) $(CFLAGS) $<
