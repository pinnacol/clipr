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
  
  int i, n;
  n = ArgCountCheck("ruby-call", AT_LEAST, 1);
  
  if (n == -1) 
    rb_raise(rb_eArgError, "no block id given");
  
  DATA_OBJECT objects[n];
  if (ArgTypeCheck("ruby-call", 1, INTEGER, &objects[0]) == 0) 
    rb_raise(rb_eArgError, "expected block id as first argument");
    
  /*=========================*/ 
  /* Get the callback inputs */ 
  /*=========================*/
  
  n += 1;
  VALUE args[n];
  args[0] = rbffi_Pointer_NewInstance(theEnv);
  args[1] = LONG2FIX(DOToLong(objects[0]));
  
  for(i = 2; i < n; ++i) {
    RtnUnknown(i, &objects[i-1]);
    args[i] = rbffi_Pointer_NewInstance(&objects[i-1]);
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

