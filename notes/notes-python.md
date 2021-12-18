
## Python
## Installation
https://opensource.com/article/19/5/python-3-default-mac
Note we are using pyenv: /Users/at/.zshrc#/#%20Use%20pyenv
and: alias python=/opt/homebrew/bin/python3 to use the most current homebrew installed python 3 version as whenever 'python' is called
You can install Python packages with pip3 install <package> They will install into the site-package directory /opt/homebrew/lib/python3.9/site-packages

Todo: there is still a note about the virtual env set in :checkhealth. see https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654
## Pyenv
https://github.com/pyenv/pyenv-virtualenv/blob/master/README.md
pyenv versions      - show what environment is currently active
pyenv global        - only shows the current system version | set the global system version pyenv global && pyenv global 3.10.0
pip list            - what is installed in the current environment! output as of 2021-12-13:
                      Package    Version
                      ---------- -------
                      greenlet   1.1.2
                      msgpack    1.0.3
                      pip        21.3.1
                      pynvim     0.4.3
                      setuptools 57.4.0

_                     Package           Version
                      ----------------- -------
                      astroid           2.9.0
                      click             8.0.3
                      codespell         2.1.0
                      google-cl         0.0.1
                      greenlet          1.1.2
                      isort             5.10.1
                      lazy-object-proxy 1.6.0
                      mccabe            0.6.1
                      msgpack           1.0.3
                      pip               21.3.1
                      platformdirs      2.4.0
                      pylint            2.12.1
                      pynvim            0.4.3
                      setuptools        57.4.0
                      toml              0.10.2
                      wrapt             1.13.3



### pyenv virtualenv
https://opensource.com/article/19/6/python-virtual-environments-mac
pyenv virtualenvs   - show virtual envs

Example from https://neovim.io/doc/user/provider.html
pyenv install 3.4.4
pyenv virtualenv 3.4.4 py3nvim
pyenv activate py3nvim
python3 -m pip install pynvim
pyenv which python  # Note the path
The last command reports the interpreter path, add it to your init.vim:
let g:python3_host_prog = '/path/to/py3nvim/bin/python'


" Example of how to run a Python function:  ~/.vim/plugin/utils-stubs.vim#/Example%20of%20how

