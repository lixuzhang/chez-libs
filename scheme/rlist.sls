;; SRFI 101: Purely Functional Random-Access Pairs and Lists
;; Copyright (c) David Van Horn 2009.  All Rights Reserved.

;; Permission is hereby granted, free of charge, to any person obtaining
;; a copy of this software and associated documentation
;; files (the "Software"), to deal in the Software without restriction,
;; including without limitation the rights to use, copy, modify, merge,
;; publish, distribute, sublicense, and/or sell copies of the Software,
;; and to permit persons to whom the Software is furnished to do so,
;; subject to the following conditions:

;; The above copyright notice and this permission notice shall be
;; included in all copies or substantial portions of the Software.

;; THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
;; EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
;; MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
;; NONINFRINGEMENT. REMEMBER, THERE IS NO SCHEME UNDERGROUND. IN NO EVENT
;; SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
;; DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
;; OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR
;; THE USE OR OTHER DEALINGS IN THE SOFTWARE.

;; Packaged for R7RS Scheme RedEdition by Peter Lane, 2017

(library
  (scheme rlist)
  (export rquote 
          rpair? 
          rcons
          rcar
          rcdr
          rcaar
          rcadr
          rcddr
          rcdar
          rcaaar
          rcaadr
          rcaddr
          rcadar
          rcdaar
          rcdadr
          rcdddr
          rcddar
          rcaaaar
          rcaaadr
          rcaaddr
          rcaadar
          rcadaar
          rcadadr
          rcadddr
          rcaddar
          rcdaaar
          rcdaadr
          rcdaddr
          rcdadar
          rcddaar
          rcddadr
          rcddddr
          rcdddar
          rnull?
          rlist?
          rlist 
          rmake-list
          rlength 
          rappend
          rreverse
          rlist-tail
          rlist-ref
          rlist-set
          rlist-ref/update 
          rmap 
          rfor-each 
          rlist->list
          list->rlist
          )
  (import (srfi :101 rlists)))
