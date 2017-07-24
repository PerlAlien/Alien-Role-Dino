/* Copyright (C) 2017 Graham Ollis */
#include <libpalindrome.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

static void
copy_letters(char *buffer, const char *original)
{
  while(*original != 0)
  {
    if(isalpha(*original))
      *(buffer++) = tolower(*original);
    original++;
  }
  *buffer = 0;
}

static void
copy_reverse(char *buffer, const char *original)
{
  int i;
  for(i=strlen(original)-1; i >= 0; i--)
    *(buffer++) = original[i];
  buffer = 0;
}

int is_palindrome(const char *something)
{
  char *copy1;
  char *copy2;
  int ret;

  copy1 = malloc(strlen(something)+1);
  copy2 = malloc(strlen(something)+1);

  copy_letters(copy1, something);
  copy_reverse(copy2, copy1);

  ret = strcmp(copy1,copy2) ? 0 : 1;

  free(copy1);
  free(copy2);

  return ret;
}
