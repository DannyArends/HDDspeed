/** \file fileloader.d
 * Last modified Jan, 2012
 * First written Jan, 2012
 *
 * Copyright (c) 2012 Danny Arends
 * GNU General Public License, version 3
 * Contains: HDDspeed
 **/

import std.stdio;
import std.conv;
import std.datetime;
import std.random;

import stats;
import generate;

enum BUFFERSIZE : long{
  BUFFER_16KB   =          16_384,
  BUFFER_2MB    =       2_097_152, 
  BUFFER_4MB    =       4_194_304, 
  BUFFER_16MB   =      16_777_216, 
  BUFFER_64MB   =      67_108_864, 
  BUFFER_256MB  =     268_435_456,
  BUFFER_1GB    =   1_073_741_824,
  BUFFER_2GB    =   2_000_000_000,
  BUFFER_4GB    =   4_294_967_296,
  BUFFER_16GB   =  17_179_869_184
}

BUFFERSIZE setBufferSize(string argument){
  switch(argument){
    case "16kb" :return BUFFERSIZE.BUFFER_16KB;break;
    case "2mb"  :return BUFFERSIZE.BUFFER_2MB;break;
    case "4mb"  :return BUFFERSIZE.BUFFER_4MB;break;
    case "16mb" :return BUFFERSIZE.BUFFER_16MB;break;
    case "64mb" :return BUFFERSIZE.BUFFER_64MB;break;
    case "256mb":return BUFFERSIZE.BUFFER_256MB;break;
    case "1gb"  :return BUFFERSIZE.BUFFER_1GB;break;
    case "32bit":return BUFFERSIZE.BUFFER_2GB;break;
    case "4gb"  :return BUFFERSIZE.BUFFER_4GB;break;
    case "16gb" :return BUFFERSIZE.BUFFER_16GB;break;
    default     :return BUFFERSIZE.BUFFER_16KB;break;
  }
  assert(0);
}

void print_header(){
  writeln("HDDspeed tester v0.002");
  writeln("Copyright (c) 2011-2012 written by Danny Arends");
}
  
void print_usage(){
  print_header();
  writeln("Documentation: http://www.dannyarends.nl/HDDspeed/index.html");
  writeln("Usage:");
  writeln("HDDspeed [n.tests] [size]\n");
  writeln(" [n.tests]  Number of tests, larger = better");
  writeln(" [size]     Size of buffer, experimental");
}

void main(string[] args){
  long[] text_times;
  long[] bin_times;
  long[] write_times;
  BUFFERSIZE buffersize = BUFFERSIZE.BUFFER_16KB;
  int ntests = 47;
  bool text_err = false;
  string txt_file = "test.txt";
  string bin_file = "test.bin";
  if(args.length > 1){
    try{
      ntests = to!int(args[1]);
    }catch(Exception e) {
      print_usage();
      writefln("ERROR: n.tests is not an integer: %s", args[1]);
      return;
    }
    if(ntests <= 0){
      print_usage();
      writefln("ERROR: n.tests is negative: %s", args[1]);
      return;
    }
    if(args.length > 2){ buffersize = setBufferSize(args[2]); }
  }    
  print_header();
  clean_file(bin_file);
  clean_file(txt_file);
  long   total_bytes=0;
  long   filesize=0;
  long[] sizes;
  for(auto x=0;x<ntests;x++){
    long size = uniform(800,1000);
    //Using readln on a text file
    write_times ~= genFile(txt_file,size*10,FILETYPE.TEXTFILE);
    write_times ~= genFile(bin_file,size*1000,FILETYPE.BINARYFILE);
    File* t_f = new File(txt_file,"r");
    string text_buffer;
    SysTime t_t_s = Clock.currTime();
    try{
      if(!text_err) while(t_f.readln(text_buffer)){ }
    }catch(Exception e) {
      writefln("Text read error caught: %s", e.msg);
      text_err=true;
    }
    text_times ~= (Clock.currTime()-t_t_s).total!"msecs"();
    delete text_buffer;
    t_f.close();
    
    //Using binary blocks
    File* b_f = new File(bin_file,"rb");
    ubyte[] inputbuffer = new ubyte[cast(size_t)(buffersize/ubyte.sizeof)];
    SysTime t_b_s = Clock.currTime();
    while(b_f.rawRead(inputbuffer)){ }
    bin_times ~= (Clock.currTime()-t_b_s).total!"msecs"();
    delete inputbuffer;
    b_f.close();
    write(".");
    stdout.flush();
    filesize += size;
    sizes ~= filesize;
    total_bytes += filesize;
  }
  write("\n");
  writefln("Bytes used in testing: %s Kb / %s Mb",toKb(10*total_bytes),toMb(1000*total_bytes));
  writefln("Write: %s mB/sec",toMb(((1000*total_bytes)+(10*total_bytes))/(doSum(bin_times)+1)*1000));
  writefln("Read (txt): %s kB/sec",toKb((10*total_bytes)/(doSum(text_times)+1)*1000));
  writefln("Read (bin): %s mB/sec",toMb((1000*total_bytes)/(doSum(bin_times)+1)*1000));
  string buf = readln();
}
