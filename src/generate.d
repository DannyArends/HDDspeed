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
import std.datetime;
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
  " ", "\t", ", ",".\n",
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
  File* fp = new File(name,"a");
  long x =0;
  while(x < size){
    uint n = uniform(0,12);
    if(type == FILETYPE.TEXTFILE){
      if(n+x > size) n = cast(uint) (size-x);
      foreach (e; randomSample(chars, n)) {
        SysTime ts = Clock.currTime();
        fp.write(e);
        times ~= (Clock.currTime()-ts).total!"msecs"();
      }
      x += n;
    }else{
      SysTime ts = Clock.currTime();
      fp.write(to!char(n));
      times ~= (Clock.currTime()-ts).total!"msecs"();
      x++;      
    }
  }
  fp.close();
  return doSum(times);
}
