  #include <string>
  #include <iostream>
  #include <vector>
  #include <fstream>
  #include "value.h" 
  #include "environment.h" 
  #include <math.h>       /* remainder */
using namespace std;

                      //structure integer, floating, String, bolean
                      //hexadecimal
                      //esponential
                      //create an hash map for the name of the function
                      //controllare che quando si assegna stringa a variabile
                      //handle exponential
                      //print con più arguments


class Node{
public:
  std::string tag, value;
  std::vector<Node> children;
  Node(const std::string& t, const std::string& v) : tag(t) , value(v){}
  Node() 
  {
    tag = "uninitialised" ; 
    value = "uninitialised";
  }

  void dump(int depth=0) { 

    for(int i=0; i<depth; i++) 
      std::cout << " "; std::cout << tag << ":" << value << std::endl; 
    std::vector<Node>::iterator i;
    for(i=children.begin(); i!=children.end(); i++) 
      (*i).dump(depth+1); 

  }
  void dump_tree(int &currentNode, ofstream &out){
                              //create a file stream
    int current=currentNode;
    out<<currentNode<<" [label=\""<<tag<<"\\n"<<value<<"\"];"<<"\n";
    currentNode++;
    std::vector<Node>::iterator i;
    for(i=children.begin(); i!=children.end(); i++) {
      out<<current<<" -> "<<currentNode<<";\n";
      (*i).dump_tree(currentNode,out); 
    }
  }

  Value execute(Environment *e){
    Value result;

  /*legend of type
       1=integer 
       2=float
       3=String
       4=boolean
       cannot update variables with them selves the assignment broken
       //list[i + 1] broken!!!!!
       */                     
       if(this->tag == "addition"){
         if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==2){
          result.floatt=this->children.front().execute(e).floatt + this->children.back().execute(e).floatt;
          result.type=2;
          return result;
        }
        else if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==1){
         result.floatt=this->children.front().execute(e).floatt + this->children.back().execute(e).integer;
         result.type=2;
         return result;
       }
       else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==2){
         result.floatt=this->children.front().execute(e).integer + this->children.back().execute(e).floatt;
         result.type=2;
         return result;
       }
       else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==1){
         result.integer=this->children.front().execute(e).integer + this->children.back().execute(e).integer;
         result.type=1;
         return result;
       }
       else cout <<"problem, sorry for the addition, maybe variable not defined...";
     }
     else if(this->tag == "multiplication"){
       if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==2){
        result.floatt=this->children.front().execute(e).floatt * this->children.back().execute(e).floatt;
        result.type=2;
        return result;
      }
      else if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==1){
       result.floatt=this->children.front().execute(e).floatt * this->children.back().execute(e).integer;
       result.type=2;
       return result;
     }
     else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==2){
       result.floatt=this->children.front().execute(e).integer * this->children.back().execute(e).floatt;
       result.type=2;
       return result;
     }
     else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==1){
       result.integer=this->children.front().execute(e).integer * this->children.back().execute(e).integer;
       result.type=1;
       return result;
     }
     else cout <<"problem, sorry for the multiplication, maybe variable not defined...";
   }

   else  if(this->tag == "substraction"){
     if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==2){
      result.floatt=this->children.front().execute(e).floatt - this->children.back().execute(e).floatt;
      result.type=2;
      return result;
    }
    else if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==1){
     result.floatt=this->children.front().execute(e).floatt - this->children.back().execute(e).integer;
     result.type=2;
     return result;
   }
   else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==2){
     result.floatt=this->children.front().execute(e).integer - this->children.back().execute(e).floatt;
     result.type=2;
     return result;
   }
   else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==1){
     result.integer=this->children.front().execute(e).integer - this->children.back().execute(e).integer;
     result.type=1;
     return result;
   }
   else cout <<"problem, sorry for the substraction, maybe variable not defined...";
 }
 else if(this->tag == "division"){
  if(this->children.back().value == "0"){
    cout << "Error: cannot perform division by 0\n";
    exit(-1);
  }
  else if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==2){
    result.floatt=this->children.front().execute(e).floatt / this->children.back().execute(e).floatt;
    result.type=2;
    return result;
  }
  else if(this->children.front().execute(e).type==2 && this->children.back().execute(e).type==1){
   result.floatt=this->children.front().execute(e).floatt / this->children.back().execute(e).integer;
   result.type=2;
   return result;
 }
 else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==2){
   result.floatt=this->children.front().execute(e).integer / this->children.back().execute(e).floatt;
   result.type=2;
   return result;
 }
 else if(this->children.front().execute(e).type==1 && this->children.back().execute(e).type==1){
   result.floatt=(float)this->children.front().execute(e).integer /(float) this->children.back().execute(e).integer;
   result.type=2;
   return result;
 }
 else cout <<"problem, sorry for the division, maybe variable not defined...";
}

else if(this->tag=="NUMBER"){
  if(this->value.find("0x") != std::string::npos){
    result.integer = strtoul(this->value.c_str(), NULL, 16);
    result.type=1;
    return result;
  }
  else if(this->value.find(".") != std::string::npos){
    result.floatt= std::stof(this->value);
    result.type=2;
    return result;
  }
  else
    result.integer = std::stoi(this->value);
  result.type=1;
  return result;
}
else if(this->tag=="TRUE"){
  result.type=4;
  result.boolean=true;
  return result;
}
else if(this->tag=="FALSE"){
  result.type=4;
  result.boolean=false;
  return result;
}
else if(this->tag=="STRING"){

  result.text = this->value;
  result.type=3;
  return result;

}
else if(this->tag=="String"){
  result.text = this->value;
  result.type=3;
  return result;
}
else if(this->tag=="varName"){
  result=e->getValue(this->value);
  return result;
}
else if (this->tag=="prefixbktName"){
  string value=this->children.front().children.front().value;
  std::string& tagValue =  this->children.back().tag;
  if(tagValue=="NUMBER" || tagValue=="addition"  || tagValue=="substraction" 
   || tagValue=="multiplication" || tagValue=="division" ||  tagValue=="percentagexp" ){ 
    int position;

  if (tagValue == "division")
    position = (int)this->children.back().execute(e).floatt - 1;
  else
    position=this->children.back().execute(e).integer-1;
  result=e->getValueatlistindex(value,position);
}
else if(this->children.back().children.front().tag=="varName"){
  int position=e->hashtable[this->children.back().children.front().value].integer-1;
  result=e->getValueatlistindex(value,position);
}
else {
  cout<< "the index can be only varialble or number!"<<endl;
  exit(-1);
}
return result;
}
else if(this->tag=="chunk"){
  if(this->children.size()==1){
    return this->children.front().execute(e);
  }

  else {
    this->children.front().execute(e);
    return this->children.back().execute(e);
  }
}

else if (this->tag=="statements"){
  for(auto i: children){
    i.execute(e);
  }
}   
else if(this->tag=="fcallprfargs"){
  if(this->children.front().children.front().tag=="prefixpointName"){
    if(this->children.front().children.front().children.back().value=="write"){
      Node explist=this->children.back().children.front();
      for(int i=0;i<explist.children.size();i++){
        switch(explist.children[i].execute(e).type){
          case 0 : cout << "something went wrong"<<endl; break;
          case 1 : cout << explist.children[i].execute(e).integer; break;   
          case 2 : cout << explist.children[i].execute(e).floatt; break;   
          case 3 : cout << explist.children[i].execute(e).text;  break;
          default: cout <<"problem the result is neither an integer a float or a string!\n";  
        }
      }
    }
    else if(this->children.front().children.front().children.back().value=="read"){
      result.type=1;
      cin>>result.integer; 
      return result;
    }
  }
  else if(this->children.front().children.front().value=="print"){

    if(this->children.back().tag=="String"){
      cout<<this->children.back().value<<endl;
    }    
    else{
      Node explist=children.back().children.front();                      
      for(int i=0;i<explist.children.size();i++){
        if(i==explist.children.size()-1){
          switch(explist.children[i].execute(e).type){
            case 0 : cout << "something went wrong"<<endl; break;
            case 1 : cout << explist.children[i].execute(e).integer<<endl; break;   
            case 2 : cout << explist.children[i].execute(e).floatt<<endl; break;   
            case 3 : cout << explist.children[i].execute(e).text<<endl;  break;
            case 4 : cout <<  std::boolalpha<<explist.children[i].execute(e).boolean<<endl;  break;
            default: cout <<"problem the result is neither an integer a float or a string!\n";  
          }
        }
        else{
          switch(explist.children[i].execute(e).type){
            case 0 : cout << "something went wrong"<<"\t"; break;
            case 1 : cout << explist.children[i].execute(e).integer<<"\t"; break;   
            case 2 : cout << explist.children[i].execute(e).floatt<<"\t"; break;   
            case 3 : cout << explist.children[i].execute(e).text<<"\t";  break;
            case 4 : cout <<  std::boolalpha << explist.children[i].execute(e).boolean<<endl;  break;
            default: cout <<"problem the result is neither an integer a float or a string!\n";  
          }
        }
      }
    }
  }
  else return this->children.front().execute(e);
}
else if(this->tag=="prefixpointName"){
}
else if(this->tag=="args"){
  return this->children.front().execute(e); 
}

else if(this->tag=="explist"){
  for(auto i: this->children){
   i.execute(e); 
 }
}  

else if(this->tag=="varlist"){
 for(auto i: this->children){
   i.execute(e); 
 }
}  
else if(this->tag=="prefixvar"){
  return this->children.front().execute(e); 
}  
else if(this->tag=="assign"){
  std::vector<Value> brkexplist;
  for(int i=0;i<this->children.back().children.size();i++){
    if(this->children.back().children[i].tag=="prefixvar"){
      Node prefixVar=children.back().children[i];
      if(prefixVar.children.front().tag=="prefixbktName"){
        brkexplist.push_back(prefixVar.children.front().execute(e));       
      }
    }
  }
  for(int i=0;i<this->children.front().children.size();i++){
     if(this->children.front().children[i].tag=="prefixbktName"){
        Node prefixbktName=this->children.front().children[i];
        string listname=prefixbktName.children.front().children.front().value;
        int position=prefixbktName.children.back().execute(e).integer;
        if(i>=brkexplist.size()){
        }
       else{
        Value value=brkexplist[i];
        e->setValue(listname, position-1, value);
      }
    }
  }
  std::vector<string> varlist;
  for(auto i: this->children.front().children){
   varlist.push_back(i.value);
 }
 int list_index = -1;
 for(int i=0;i< this->children.back().children.size(); i++){
  if(this->children.back().children[i].tag=="bracketList"){
    list_index=i;
    break;
  }
}
if (list_index != -1)
{
  e->listhashtable[varlist[list_index]] = std::vector<Value>();
  for(auto i: this->children.back().children[list_index].children.front().children){
    e->listhashtable[varlist[list_index]].push_back(i.children.front().execute(e)); 
  } 
}

else{
 std::vector<Value> explist;
 for(auto i: this->children.back().children){
   explist.push_back(i.execute(e));
 }
 for(int i=0;i<varlist.size();i++){
  if(i>=explist.size()){
  }
  else e->hashtable[varlist[i]]=explist[i];
}
}
}
else if (this->tag=="expfield"){
  for(auto i:this->children){
    i.execute(e);
  }
}

else if(this->tag=="IfNode"){
  result=this->children.front().execute(e);
  if(result.boolean==true){
   return this->children[1].execute(e);
 }
 Node elseif= this->children[2];
 for (int i=0;i<elseif.children.size();i+=2){
  if(elseif.children[i].execute(e).boolean==true){
    return elseif.children[i+1].execute(e);
  }
}     
return this->children.back().execute(e);
}
else if(this->tag=="ElseNode"){
  return this->children.front().execute(e);
} 
else if(this->tag=="emptyelse"){
}

else if(this->tag=="doubleequalexp"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  result.type=4;
  if(two.type==4 && one.type==4){
    if(one.boolean==two.boolean){
      result.boolean=true;
    }
    else result.boolean=false;
  }
  else if(one.integer==two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="lowerdisequation"){
  result.type=4;
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  if(one.integer<two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="elowerdisequation"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  result.type=4;
  if(one.integer<=two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="greaterdisequation"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  result.type=4;
  if(one.integer>two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="egreaterdisequation"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  result.type=4;
  if(one.integer>=two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="equaltiladaexp"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  result.type=4;
  if(one.integer=~two.integer){
    result.boolean=true;
  }
  else result.boolean=false;
  return result;
}
else if(this->tag=="percentagexp"){
  Value one=this->children.front().execute(e);
  Value two=this->children.back().execute(e);
  int remainderr=remainder(one.integer,two.integer);
  result.type=1;
  result.integer=remainderr;
  return result; 
}
else if(this->tag=="uhash"){
  int length= e->listhashtable[this->children.front().children.front().value].size();
  result.type=1;
  result.integer=length;
  return result;
}

else if(this->tag=="SimpleForNode"){
  Value iterator;
  string value=this->children.front().value;
  int initial=this->children[1].execute(e).integer;
  iterator.integer=initial;
  iterator.type=1;
  e->hashtable[value]=iterator;
  int end=this->children[2].execute(e).integer;
  for(int i=initial;i<=end;i++){
   this->children.back().execute(e);
   iterator.integer+=1;
   e->hashtable[value]=iterator;
 }
}
else if(this->tag=="RepeatNode"){
 do
{
this->children.front().execute(e);
}
while(this->children.back().execute(e).boolean==false);
}
  else cout<< "a tag is missing:\n"<<this->tag<<"\n"<<endl;
  return result;
}
}
;