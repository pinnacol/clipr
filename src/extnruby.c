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
  const VALUE object_space = rb_define_module_under(rb_cObject, "ObjectSpace");
  const ID id2ref = rb_intern("_id2ref");
  const ID call = rb_intern("call");
  
  VALUE block, block_id, block_result;
  long id, result;
  
  ArgCountCheck("ruby-call",EXACTLY,1);
  id = RtnLong(1);
  
  /*==================================================*/
  /* Lookup the block specified by id, call it, and   */
  /* convert the result into an true/false integer    */
  /*==================================================*/
  
  block_id = LONG2FIX(id);
  block = rb_funcall(object_space, id2ref, 1, block_id);
  
  block_result = rb_funcall(block, call, 0);
  result = FIX2INT(block_result);
  
  /*=======================================*/
  /* FIX2INT returns 2 for nil and must be */
  /* treated as a special case of false    */
  /*=======================================*/
  
  if(result == 2) result = 0;
  
  return(result); 
}

