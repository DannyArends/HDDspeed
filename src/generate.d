/******************************************************************//**
 * \file src/generate.d
 * \brief random file generation functions of the HDDspeed utility
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jan, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.stdio;
import std.conv;
import core.time;
import std.random;

import stats;

string[] chars = [ 
  "a", "A", "b", "B", 
  "c", "C", "d", "D",
  "e", "E", "f", "F",
  "g", "G", "h", "H",
  "i", "I", "j", "J",
  "k", "K", "l", "L",
  "m", "M", "n", "N",
  "o", "O", "p", "P",
  "q", "Q", "r", "R",
  "s", "S", "t", "T",
  "u", "U", "v", "V",
  "w", "W", "x", "X",
  "y", "Y", "z", "Z",
  " ", "\t", ",", "\n",
  "{", "}", "[", "]"
];

enum FILETYPE : uint {
  TEXTFILE = 1, 
  BINARYFILE = 2
}

void clean_file(string filename){
  File* fp = new File(filename,"w");
  fp.write("");
  fp.close();
}

long genFile(string name, long size, FILETYPE type){
  long[] times;
  long x =0;
  char[] buffer;
  while(x < size) {
    if(type == FILETYPE.TEXTFILE){
      foreach (e; randomSample(chars, 1)) {
        version(Windows){
          if(e == "\n") x++;
        }
        buffer ~= e;
        x++;
      }
    }else{
      int n = uniform(0,9);
      buffer ~= to!char(n);
      x++;      
    }
  }
  MonoTime ts = MonoTime.currTime();
  File* fp = new File(name,"a");
  fp.write(buffer);
  fp.close();
  return((MonoTime.currTime-ts).total!"hnsecs"());
}
