   /*******************************************************/
   /*      "C" Language Integrated Production System      */
   /*                                                     */
   /*             CLIPS Version 6.30  10/19/06            */
   /*                                                     */
   /*         RUBY EXTERNAL FUNCTIONS HEADER FILE         */
   /*     (not a part of the main CLIPS distribution)     */
   /*******************************************************/

/*************************************************************/
/* Purpose: External functions for callbacks to ruby.        */
/*                                                           */
/* Principal Programmer(s):                                  */
/*      Simon Chiang                                         */
/*                                                           */
/* Contributing Programmer(s):                               */
/*                                                           */
/* Revision History:                                         */
/*      6.30: Added call and equal methods                   */
/*                                                           */
/*************************************************************/

#include "extnruby.h"

int RubyCall() 
{ 
  VALUE object_space, callback, block_id;
  ID id2ref, call;
  long block;
  
  ArgCountCheck("ruby-call",EXACTLY,1);
  block = RtnLong(1);
  block_id = LONG2FIX(block);

  object_space = rb_define_module_under(rb_cObject, "ObjectSpace");
  id2ref = rb_intern("_id2ref");
  call = rb_intern("call");
  
  callback = rb_funcall(object_space, id2ref, 1, block_id);
  rb_funcall(callback, call, 0);
  
  return(1); 
}

