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
/*      6.30: Added EnvRubyCall method                       */
/*                                                           */
/*************************************************************/

#include "extnruby.h"

/*********************************************************/
/* A callback method to pass control to Ruby from CLIPS. */
/* EnvRubyCall converts its inputs into ruby objects and */
/* passes them to Clips::Api#callback; that method then  */
/* dispatches control to some arbitrary block of code.   */
/*                                                       */
/* EnvRubyCall must receive at least one integer input   */
/* to identify the block called by Clips::Api#callback.  */
/*********************************************************/
int EnvRubyCall(void *theEnv) 
{ 
  /*==================*/ 
  /* Check arguments. */ 
  /*==================*/
  
  DATA_OBJECT arg;
  int i, n;
  
  n = ArgCountCheck("ruby-call", AT_LEAST, 1);
  
  if (n == -1) 
    rb_raise(rb_eArgError, "no block id given");
    
  if (ArgTypeCheck("ruby-call", 1, INTEGER, &arg) == 0) 
    rb_raise(rb_eArgError, "expected block id as first argument");
    
  /*=========================*/ 
  /* Get the callback inputs */ 
  /*=========================*/
  
  VALUE args[n];
  args[0] = LONG2FIX(DOToLong(arg));
  
  for(i = 1; i < n; ++i) {
    RtnUnknown(i+1, &arg);
    args[i] = rbffi_Pointer_NewInstance(&arg);
  }
  
  /*=================================*/
  /* Make the callback to Clips::Api */
  /*=================================*/
  
  VALUE clips = rb_const_get(rb_cObject, rb_intern("Clips"));
  VALUE api   = rb_const_get(clips, rb_intern("Api"));
  
  long result = FIX2INT(rb_funcall2(api, rb_intern("callback"), n, (VALUE *)args));
  
  /*=======================================*/
  /* FIX2INT returns 2 for nil and must be */
  /* treated as a special case of false    */
  /*=======================================*/
  
  if(result == 2) result = 0;
  
  return(result); 
}

