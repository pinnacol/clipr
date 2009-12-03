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

int EnvRubyCall(void *theEnv) 
{ 
  const VALUE object_space = rb_define_module_under(rb_cObject, "ObjectSpace");
  const ID id2ref = rb_intern("_id2ref");
  const ID call = rb_intern("call");
  
  VALUE block, block_id, block_result;
  DATA_OBJECT arg;
  int i, n;
  long id, result;
  
  /*==================================*/ 
  /* Check at least one argument.     */ 
  /*==================================*/ 
  
  n = RtnArgCount();
  if (n == 0) rb_raise(rb_eArgError, "no block id given");
  
  /*==================================*/ 
  /* Get the block id.                */ 
  /*==================================*/
  
  id = RtnLong(1);
  block_id = LONG2FIX(id);
  
  /*==================================*/ 
  /* Get the rule pointers            */ 
  /*==================================*/
  
  n -= 1;
  VALUE args[n];
  for(i = 0; i < n; ++i) {
    RtnUnknown(i+2, &arg);
    args[i] = rbffi_Pointer_NewInstance(arg.value);
  }
  
  /*================================================*/
  /* Lookup the block specified by id, call it with */
  /* the rule pointers, and convert the result into */
  /* a true/false integer                           */
  /*================================================*/
  
  block = rb_funcall(object_space, id2ref, 1, block_id);
  block_result = rb_funcall2(block, call, n, (VALUE *)args);
  result = FIX2INT(block_result);
  
  /*=======================================*/
  /* FIX2INT returns 2 for nil and must be */
  /* treated as a special case of false    */
  /*=======================================*/
  
  if(result == 2) result = 0;
  
  return(result); 
}

