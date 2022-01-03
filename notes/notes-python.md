
## Python
## Installation
https://opensource.com/article/19/5/python-3-default-mac
Note we are using pyenv: /Users/at/.zshrc#/#%20Use%20pyenv
and: alias python=/opt/homebrew/bin/python3 to use the most current homebrew installed python 3 version as whenever 'python' is called
You can install Python packages with pip3 install <package> They will install into the site-package directory /opt/homebrew/lib/python3.9/site-packages

Todo: there is still a note about the virtual env set in :checkhealth. see https://vi.stackexchange.com/questions/7644/use-vim-with-virtualenv/7654#7654


## pip
pip list
pip show <package>
pip install pypisearch


## pyenv
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

### $VIRTUAL_ENV
using `grt` on the following line will *only* show e.g.
/Users/at/.virtualenvs/test2
.. if nvim was launched *while a venv was active* ..
changing/setting the venv in a terminal-win will not change it inside of vim!
  echo $VIRTUAL_ENV
  ls

" Example of how to run a Python function:  ~/.vim/plugin/utils-stubs.vim#/Example%20of%20how


### python -m venv
make two virtual environments:
  python3 -m venv $HOME/.virtualenvs/test1
  python3 -m venv $HOME/.virtualenvs/test2
  source $HOME/.virtualenvs/test1/bin/activate
  pip install pillow
  source $HOME/.virtualenvs/test2/bin/activate
  pip install requests

These are the default packages installed in an environment:
     /Users/at/.virtualenvs/test2/lib/python3.10
    └──  site-packages
       ├──  distutils_hack
       ├──  distutils-precedence.pth
       ├──  pip
       ├──  pip-21.2.3.dist-info
       ├──  pkg_resources
       ├──  setuptools
       └──  setuptools-57.4.0.dist-info

This now shows the pillow packages installed:
/Users/at/.virtualenvs/test1/lib/python3.10/

And here are the requests packages:
/Users/at/.virtualenvs/test2/lib/python3.10/

Make a test.sh file:
VIRTUAL_ENV=$HOME/.virtualenvs/test1 $HOME/.virtualenvs/test1/bin/pyls

https://github.com/HallerPatrick/py_lsp.nvim
https://github.com/neovim/nvim-lspconfig/issues/500\#issuecomment-965824580
before_init = function(_, config)
    local p
    if vim.env.VIRTUAL_ENV then
        p = lsp_util.path.join(vim.env.VIRTUAL_ENV, "bin", "python3")
    else
        p = utils.find_cmd("python3", ".venv/bin", config.root_dir)
    end
    config.settings.python.pythonPath = p
end,

### null-ls
addresses python venv problems with:
{ prefer_local = ".venv/bin" }

### examining ~/.pyenv/
The created virtual env is represented by a folder here:
/Users/at/.pyenv/versions/

note that `py3nvim` is actually an alias into the 3.10.0
/Users/at/.pyenv/versions/3.10.0/envs/py3nvim/

/Users/at/.pyenv/versions/3.10.0/envs/py3nvim/bin/

The pyenv.cfg has interesting content (well)
/Users/at/.pyenv/versions/3.10.0/envs/py3nvim/pyvenv.cfg
      home = /Users/at/.pyenv/versions/3.10.0/bin
      include-system-site-packages = false
      version = 3.10.0

The installed packages seem to be ver short executable python scripts(?)
/Users/at/.pyenv/versions/3.10.0/envs/py3nvim/bin/flake8

### pyenv local
ceates a .python-vesion file:
/Users/at/.vim/.python-version.bak
used by ~/.zshrc#/#%20Test%20/

### conda
conda env list
conda activate numtest1
conda deactivate
conda create --name numtest1 numpy


## Virtual envs
### Paths
pyenv virtualenv: ~/.pyenv/versions
python -m venv  : ~/.virtualenvs
conda: /Users/at/.conda/environments.txt
miniconda: /Users/at/miniconda3/envs/
poetry: /Users/at/Library/Caches/pypoetry/virtualenvs


## Poetry
A dependency and build manager

## Install poetry
install:   curl -sSL https://install.python-poetry.org | python3 -
           curl -sSL https://install.python-poetry.org | python3 - --preview
           curl -sSL https://install.python-poetry.org | POETRY_PREVIEW=1 python3 -
           curl -sSL https://install.python-poetry.org | python3 - --git https://github.com/python-poetry/poetry.git@master
           poetry self update --preview
uninstall: curl -sSL https://install.python-poetry.org | python3 - --uninstall
           curl -sSL https://install.python-poetry.org | POETRY_UNINSTALL=1 python3 -
Install location: /Users/at/.local/bin


/Users/at/Documents/Temp/py/poet-test1/
/Users/at/Documents/Temp/py/poet-test1/pyproject.toml

### Poetry config
poetry config --list
  cache-dir = "/Users/at/Library/Caches/pypoetry"
  experimental.new-installer = true
  installer.parallel = true
  virtualenvs.create = true
  virtualenvs.in-project = null
  virtualenvs.path = "{cache-dir}/virtualenvs"  # /Users/at/Library/Caches/pypoetry/virtualenvs

## Basic usage
https://python-poetry.org/docs/basic-usage/
poetry new <name>
poetry init .. in an existing project
poetry add pendulum
poetry install
poetry update


### poetry run
Runs shell command or script with the projects virtual env!
poetry run python -V
poetry run python your_script.py
poetry run pytest/black

### virtual envs
poetry env info
  Virtualenv
  Python:         3.10.0
  Implementation: CPython
  Path:           /Users/at/Library/Caches/pypoetry/virtualenvs/poet-test1-XEqfEvfO-py3.10
  Valid:          True
  System
  Platform: darwin
  OS:       posix
  Python:   /Users/at/.pyenv/versions/3.10.0

poetry env info --path
  /Users/at/Library/Caches/pypoetry/virtualenvs/poet-test1-XEqfEvfO-py3.10

libs / packages installed:
/Users/at/Library/Caches/pypoetry/virtualenvs/poet-test1-XEqfEvfO-py3.10/lib/python3.10/

Activating manually
  source /Users/at/Library/Caches/pypoetry/virtualenvs/poet-test1-XEqfEvfO-py3.10/bin/activate

  source $(poetry env info --path)/bin/activate
  source `poetry env info --path`/bin/activate
  note that the \` \` have the same effect as $()!!
  after this you can use `deactivate`! .. the command is available in the venv only!!


https://python-poetry.org/docs/cli/

poetry show
poetry show pendulum
  name         : pendulum
  version      : 1.5.1
  description  : Python datetimes made easy.

  dependencies
   - python-dateutil =2.6.0.0,3.0.0.0
   - pytzdata =2018.3.0.0
   - tzlocal =1.5.0.0,2.0.0.0

poetry show --tree
  pendulum 1.5.1 Python datetimes made easy.
  ├── python-dateutil >=2.6.0.0,3.0.0.0
  │   └── six >=1.5
  ├── pytzdata >=2018.3.0.0
  └── tzlocal >=1.5.0.0,2.0.0.0
      └── pytz *
  pytest 5.4.3 pytest: simple powerful testing with Python
  ├── atomicwrites >=1.0
  ├── attrs >=17.4.0





