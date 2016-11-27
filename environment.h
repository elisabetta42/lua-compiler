 #include <string>
 #include <iostream>
 #include <vector>
 #include <fstream>
 #include <unordered_map>
  using namespace std;

class Environment{
//double hashtable charachter value;
public:
    unordered_map<string, Value> hashtable;	
    unordered_map<string,  std::vector<Value>> listhashtable;	
    Value empty;
	Value getValue(string index){
		auto got = hashtable.find (index);
        if ( got == hashtable.end() ){
        //std::cout << "not found";
        empty.text="null";
        empty.type=3;
		return empty;	
	    }
		else return hashtable[index];
	}
	Value getValueatlistindex(string index, int position){
		auto got = listhashtable.find (index);
        if ( got == listhashtable.end() ){
        //std::cout << "not found";
        empty.text="null";
        empty.type=3;
		return empty;	
	    }
		else return listhashtable[index][position];
	}
	void setValue(string listname, int position, Value value){
		auto got = listhashtable.find (listname);
        if ( got == listhashtable.end() ){
        std::cout << "this position does not exists in the list";
	    }
		else {
		 listhashtable[listname][position]=value;
		}
	}
	void printhash(string index){
		if(hashtable[index].type==1){
         cout<<index<<" "<<hashtable[index].integer<<endl;
		}
		else if(hashtable[index].type==2){
		 cout<<index<<" "<<hashtable[index].floatt<<endl;
	    }
	    else if(hashtable[index].type==3){
         cout<<index<<" "<<hashtable[index].text<<endl;
	    }
	    else cout << "problem in printing the hashtable..."<<endl; 
	    }
	    void hashsize(){
         for(auto i: hashtable){
         	cout<<i.first;
         	cout<<i.second.integer;
         }
	    }
    };