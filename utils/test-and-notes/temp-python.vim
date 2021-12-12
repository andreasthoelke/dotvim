

python << EOF
import vim
import string

def my_replace_string(s, needle, repl):
  # return string.replace(s, needle, repl)
  return s.replace(needle, repl)

EOF

command! -range ReplaceToken :<line1>,<line2>pydo return my_replace_string(line, "ab", "XX");


" ein eabk wefks fdsf ab kjeabkj
" ein (index) wefab fdsf kjeabkj
" ein eabk wefab (index) kjeabkj
" ein eabk wefab fdsf kjeabkj

python << EOF
import vim
import re

def my_replace_with_numbers(myrange):
    idx = [0]
    def _replace(m):
        idx[0] += 1
        return str(idx[0])
    new_string = re.sub("\\(index\\)", _replace, '\n'.join(myrange[:]))
    myrange[:] = new_string.split('\n')

EOF

command! -range IndexBuf :<line1>,<line2>py my_replace_with_numbers(vim.current.range)


python << EOF
import vim
import string

def var_replace(s):
    needle = vim.eval('needle')
    replacement = vim.eval('@a')
    return string.replace(s, needle, replacement)

EOF

command! -range VarBasedReplace :<line1>,<line2>pydo return var_replace(line);

" " https://vimways.org/2018/a-python-interface-cookbook/

python << EOF
import vim
import string

def vim_replace():
    s = vim.eval('g:for_py_string')
    needle = vim.eval('g:for_py_needle')
    repl = vim.eval('g:for_py_repl')
    ret = string.replace(s, needle, repl)
    return ret

EOF

function! MyReplace(str, needle, repl)
    let g:for_py_string = a:str
    let g:for_py_needle = a:needle
    let g:for_py_repl = a:repl
    return pyeval('vim_replace()')
endfunction



python << EOF
import urllib3, urllib3.request
import json
import vim

def _get(url):
    return urllib3.PoolManager().request('GET', url).data

def _get_country():
    try:
        ip = _get('http://ipinfo.io/ip')
        json_location_data = _get('http://api.ip2country.info/ip?%s' % ip)
        location_data = json.loads(json_location_data)
        return location_data['countryName']
    except Exception as e:
        print 'Error in sample plugin (%s)' % e.msg

def print_country():
    print 'You seem to be in %s' % _get_country()

def testa():
    vim.current.line += 'hi there'

def testb( arg1 ):
    return arg1

def testc( arg1, arg2 ):
    return arg1 + arg2

def testd( arg1 ):
    ab = 'eins'
    ab += arg1
    return ab

EOF

" echo pyeval("testb( 'aabb' )")
" echo pyeval("testd( 'aabb' )")
" echo pyeval("testc( 3, 5 )")

" echo pyeval("print_country()")
" echo pyeval("_get('http://purescript.org')")

function! Example(arg)
python << _EOF_

import vim
print "arg is " + vim.eval("a:arg")

_EOF_
endfunction

" call Example(123)








function! RandFnName1()
python << EOF
import string
import random
import vim
vim.current.line += ''.join(random.choice(string.ascii_lowercase) for _ in range(2)) + '0 = undefined'
EOF
endfunction
" " Note the Python code must not be indented in a Vim function

function! RandSymbol1()
python << EOF
import string
import random
import vim
vim.current.line += ''.join(random.choice(string.ascii_lowercase) for _ in range(2)) + '0'
EOF
endfunction


