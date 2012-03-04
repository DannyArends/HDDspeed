/******************************************************************//**
 * \file src/stats.d
 * \brief statistics function of the HDDspeed utility
 *
 * <i>Copyright (c) 2012</i> Danny Arends<br>
 * Last modified Mar, 2012<br>
 * First written Jan, 2011<br>
 * Written in the D Programming Language (http://www.digitalmars.com/d)
 **********************************************************************/
import std.math; 
import std.stdio;
import std.conv;

pure T toKb(T)(T n){ return n/1024; }
pure T toMb(T)(T n){ return n/(1024*1024); }

pure T doMean(T)(T[] data){
  T mean = 0;
  for(uint i = 0; i < (data.length-1); i++){
    mean += (data[i] - mean) / (i + 1);
  }
  return mean;
}

pure T doSum(T)(T[] values ...){
  T s = 0;
  foreach (T x; values){
    s += x;
  }
  return s;
}

pure T[] doScale(T)(T[] values, T[] scale){
  T[] result;
  result.length = values.length;
  foreach(int cnt, e; values){
    if(scale[cnt] != 0){
      result[cnt] = values[cnt]/ scale[cnt];
    }else{
      result[cnt] = T.max;
    }
  }
  return result;
}

pure real doSumOfSquares(T)(T[] data){
  T mean = doMean(data);
  real sumofsquares = 0;
  for(uint i = 0; i < (data.length-1); i++){
    sumofsquares += pow((data[i]-mean),2);
  }
  return sumofsquares;
}

pure real doVar(T)(T[] data){ 
  return (doSumOfSquares!T(data)/(data.length-1)); 
}

pure real doVar(T)(real sumofsquares,uint n){ 
  return (sumofsquares/(n-1)); 
}

pure real doSD(T)(T[] data){ 
  return sqrt(doVar!T(data)); 
}
