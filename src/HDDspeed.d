/******************************************************************//**
 * \file src/HDDspeed.d
 * \brief main function of the HDDspeed utility
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
import generate;

enum BUFFERSIZE : long{
  BUFFER_1B     =               1,
  BUFFER_4KB   =            4_096,
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
    case "1b"   :return BUFFERSIZE.BUFFER_1B;break;
    case "4kb"  :return BUFFERSIZE.BUFFER_4KB;break;
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

int main(string[] args){
  long[] text_times;
  long[] bin_times;
  long[] write_times;
  BUFFERSIZE buffersize = BUFFERSIZE.BUFFER_16KB;
  int ntests = 50;
  bool text_err = false;
  string txt_file = "test.txt";
  string bin_file = "test.bin";
  if(args.length > 1){
    try{
      ntests = to!int(args[1]);
    }catch(Exception e) {
      print_usage();
      writefln("ERROR: n.tests is not an integer: %s", args[1]);
      return(1);
    }
    if(ntests <= 0){
      print_usage();
      writefln("ERROR: n.tests is negative: %s", args[1]);
      return(1);
    }
    if(args.length > 2){ buffersize = setBufferSize(args[2]); }
  }    
  print_header();
  clean_file(bin_file);
  clean_file(txt_file);
  long   total_bytes=0;
  long   filesize=0;
  long[] sizes;
  for(auto x=0; x < ntests; x++) {
    //writefln("Running test %d", x);
    long size = uniform(8000, 10000);

    // Generate files
    write_times ~= genFile(txt_file, size, FILETYPE.TEXTFILE);
    write_times ~= genFile(bin_file, 1000 * size, FILETYPE.BINARYFILE);

    // Using readln on a text file
    string text_buffer;
    long sum_tf = 0;
    long n_tf = 0;
    MonoTime t_t_s = MonoTime.currTime;
    File* t_f = new File(txt_file,"r");
    try{
      if(!text_err) {
        while((text_buffer = t_f.readln()) !is null){
          foreach(i; text_buffer){
            n_tf++;
          }
        }
      }
    }catch(Exception e) {
      writefln("Text read error caught: %s", e.msg);
      text_err=true;
    }
    t_f.close();
    text_times ~= (MonoTime.currTime - t_t_s).total!"hnsecs"();
    delete text_buffer;


    // Using binary blocks
    ubyte[] inputbuffer = new ubyte[cast(size_t)(buffersize/ubyte.sizeof)];
    long sum_bf = 0;
    long n_bf = 0;
    MonoTime t_b_s = MonoTime.currTime;
    File* b_f = new File(bin_file, "rb");
    while ((inputbuffer = b_f.rawRead(inputbuffer)).length != 0) {
      foreach(i; inputbuffer){
        n_bf++;
      }
    }
    b_f.close();
    bin_times ~= (MonoTime.currTime - t_b_s).total!"hnsecs"();
    delete inputbuffer;
    writeln("Test ",x, ": ", n_tf, " ", n_bf);
    stdout.flush();
    filesize += size;
    sizes ~= filesize;
    total_bytes = doSum(sizes);
  }
  write("\n");

  
  writefln("Bytes used in testing txt/bin: %s Kb / %s Mb",toKb(total_bytes),toMb(1000 * total_bytes));
  writefln("Write: %s mB/sec",1e7 *  toMb(to!double(((1000 * filesize) + filesize)) / to!double(doSum(write_times))));
  writefln("Read (txt): %s mB/sec",1e7 * toMb(to!double(total_bytes) / to!double(doSum(text_times))));
  writefln("Read (bin): %s mB/sec",1e7 * toMb((to!double(1000 * total_bytes) / to!double(doSum(bin_times)))));
  return(0);
}
