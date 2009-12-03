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

#include "clips.h"
#include "ruby.h"

int EnvRubyCall();