https://github.com/junegunn/vim-easy-align/blob/master/EXAMPLES.md

eins = zwei
ee  =  ewe
sdfsdf = fds

### Table formatting
*|
**|
<Enter>*|
<Enter>**|
<Enter><Enter>*|

| Option| Type | Default | Description |
|--|--|--|--|
| threads | Fixnum | 1 | number of threads in the thread pool |
|queues |Fixnum | 1 | number of concurrent queues |
|queue_size | Fixnum | 1000 | size of each queue |
|   interval | Numeric | 0 | dispatcher interval for batch processing |
|batch | Boolean | false | enables batch processing mode |
|batch_size | Fixnum | nil | number of maximum items to be assigned at once |
|logger | Logger | nil | logger instance for debug logs |


a =
a = 1
bbbb = 2
ccccccc = 3
ccccccccccccccc
ddd = 4
eeee === eee = eee = eee=f
fff = ggg += gg &&= gg
g != hhhhhhhh == 888
i   := 5
i     %= 5
i       *= 5
j     =~ 5
j   >= 5
aa      =>         123
aa <<= 123
aa        >>= 123
bbb               => 123
c     => 1233123
d   =>      123
dddddd &&= 123
dddddd ||= 123
dddddd /= 123
gg <=> ee


\ ht        = add type stub
leader es   = add function to type-sig/ expand signature
leader if    = add an index/num to the signature-symbol name
leader ct        = create inline test stub
\ ca        = create assertion

my_object
    .method1()      .chain()
    .second_method().call()
    .third()        .call()
    .method_4()     .execute()

options = { :caching => nil,
            :versions => 3,
            "cache=blocks" => false }.merge(options)

aaa,   bb,c
d,eeeeeee
fffff, gggggggggg,
h, ,           ii
j,,k

const char    str = "Hello";
int64_t       count = 1 + 2;
static double pi = 3.14;

" ─   Alignment rules                                   ──

let g:easy_align_delimiters['d'] = {
\ 'pattern': '\(const\|static\)\@<! ',
\ 'left_margin': 0, 'right_margin': 0
\ }


let g:easy_align_delimiters = {
      \ '>': { 'pattern': '>>\|=>\|>' },
      \ '/': {
      \     'pattern':         '//\+\|/\*\|\*/',
      \     'delimiter_align': 'l',
      \     'ignore_groups':   ['!Comment'] },
      \ '-': {
      \     'pattern':       '/-/',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ ')': {
      \     'pattern':       '[()]',
      \     'left_margin':   0,
      \     'right_margin':  0,
      \     'stick_to_left': 0
      \   },
      \ 'd': {
      \     'pattern':      ' \(\S\+\s*[;=]\)\@=',
      \     'left_margin':  0,
      \     'right_margin': 0
      \   }
      \ }





