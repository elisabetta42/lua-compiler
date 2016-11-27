int: lex.yy.c binary.tab.o main.cc 
		g++ -g -std=c++11 -oint binary.tab.o lex.yy.c main.cc 
binary.tab.o: binary.tab.cc 
			  g++ -g -std=c++11 -c binary.tab.cc 
binary.tab.cc: binary.yy 
			   bison --verbose binary.yy 
lex.yy.c: binary.ll binary.tab.cc 
	flex binary.ll 
clean:
	rm -f binary.tab.* lex.yy.c* int