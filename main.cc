#include <iostream> 
#include <fstream>
#include <cstdlib>
#include <unordered_map>
#include "binary.tab.hh" 
extern unsigned int total;
extern Node root;
using  namespace std;

extern FILE *yyin;

void yy::parser::error(std::string const&err)
{  
	std::cout << "It's one of the bad ones... " << err << std::endl;
}        

int main(int argc, char **argv) 
{ 

	if (argc < 2)
	{
		std::cout << "Error filename not specified.\n";
		exit(-1);
	}

	yyin = fopen(argv[1], "r");

	yy::parser parser;
	ofstream out;
	int count=0;
	out.open("tree.dot");
	out<<"digraph {\n";
	if(!parser.parse())
	{
		// root.dump();
		root.dump_tree(count,out);
		out<<"}";
		out.close();

		system("dot -Tpdf tree.dot -o tree.pdf");

		Environment* e= new Environment();
		root.execute(e);
	}

	fclose(yyin);

	return 0;
}