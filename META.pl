#!/usr/bin/env perl

use strict ;
BEGIN { push (@INC, "..") }
use Version ;

our $destdir = shift @ARGV ;

print <<"EOF";
# Specifications for the "pa_ppx_seq" preprocessor:
requires = "camlp5,fmt,pa_ppx.base"
version = "$Version::version"
description = "pa_ppx pa_seq support"

# For linking
package "link" (
requires = "camlp5,fmt,pa_ppx.base.link"
archive(byte) = "pa_ppx_seq.cma"
archive(native) = "pa_ppx_seq.cmxa"
)

# For the toploop:
archive(byte,toploop) = "pa_ppx_seq.cma"

  # For the preprocessor itself:
  requires(syntax,preprocessor) = "camlp5,fmt,pa_ppx.base"
  archive(syntax,preprocessor,-native) = "pa_ppx_seq.cma"
  archive(syntax,preprocessor,native) = "pa_ppx_seq.cmxa"

EOF
