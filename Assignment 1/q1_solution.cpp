using namespace std;
#include<string>
#include<vector>
#include<fstream>
#include<iostream>
#include<sstream>
#include <string.h>
#include <stdio.h>

bool Q1(string word){

bool c = false;
string str1("3 ROOM");
string str2("TERRACE");	
		if(word.find(str1) != -1 || word.find(str2) != -1){
			c = true;}
return c;}
		
	


int main(){


ofstream qq1 ("q1.csv");  
bool check = false;
vector <vector<string> > database;

ifstream stream;
stream.open ("resale-flat-prices.csv");

for(int r =0; r<759895;r++){
	vector<string> record;
    for(int i = 0; i<9;i++){
		string n;
		getline(stream,n, ',');
				if(!check){
				check = Q1(n);}
			record.push_back(n);	
		}
		if(check==1){
			for(int j = 0; j<record.size();j++){	
			 	qq1<<record.at(j)<<",";
				}
	database.push_back(record);
			}		
	check = false;		
		}

	stream.close();
return 0;

}
