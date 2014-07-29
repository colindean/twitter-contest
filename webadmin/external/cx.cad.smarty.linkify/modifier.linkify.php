<?php
/*********************
** This modifier provides a "linkify" modifier for Smarty.
** Usage {$string_with_links|linkify}
**
** This code was written by Colin Dean and is in the public domain.
** The regexes were assembled from somewhere. My regex-fu isn't that strong.
**********************/

function smarty_modifier_linkify($string){
  $text = eregi_replace('(((f|ht){1}tp://)[-a-zA-Z0-9@:%_\+.~#?&//=]+)',
    '<a href="\\1">\\1</a>', $string);

  $text = eregi_replace('([[:space:]()[{}])(www.[-a-zA-Z0-9@:%_\+.~#?&//=]+)',
    '\\1<a href="http://\\2">\\2</a>', $text);

  $text = eregi_replace('([_\.0-9a-z-]+@([0-9a-z][0-9a-z-]+\.)+[a-z]{2,3})',
    '<a href="mailto:\\1">\\1</a>', $text);
  return $text;
}

?>
