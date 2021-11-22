
## Setting Up Repo
  * `git init` (in root folder)
  * `git clone <ulr>`

**git clone** `https://github.com/andreasthoelke/dotfiles`
will create a folder `dotfiles` with the following filestructure:
  `dotfiles`
  ├── .git
  │   ├── HEAD
  │   ├── config
  :   :
  ├── `.vim`
  │   ├── colors
  │   │   └── molokai.vim
  │   ├── screenshots
  │   │   ├── ScreenShot1.png
  │   │   └── ScreenShot2.png
  │   └── `utils`
  │       ├── purs-ide1.vim
  │       └── termin1.vim
  ├── .vimrc
  ├── .zshrc
  └── README.md

### Remote setup

If I did changes to a repo I cloned from Github ..
  - fork that repo on Github
  - then in the local repo overwrite the origin URL to your forked repo:
    * `git remote set-url origin https://github.com/andreasthoelke/vim-hoogle`
  - you may need to `git pull` from origin and then merge.

Link a local repo to a github repo:
  * `git remote add origin` https://github.com/andreasthoelke/somerepo.git
  * `git remote add upstream` ..
  * `git remote -v` to view remote repos
  * `git remote show` and `git remote show origin` to show infos


## Save Changes To Repo
  * create new file: `echo "test content dd" >> src/dd.txt`
  * `git add src/dd.txt` file to repo

## Find Search in deleted code
  * now just use: `Fdeleted someABC`
  * `git log -c -S'abc' | nvim -` , then `/abc` in vim. TODO could make this into one command using vim startup command (the search) using a shell var
      * could i use this with neovim remote to the output into the current vim instance?
  * `git log -c -S'missingtext' [pathToFile]` or `git log -p` and then `/missing code` in the 'less' app using `n`/`N` to navigate

## Make a git commit to dotfiles of .vimrc
  etc to https://github.com/andreasthoelke/dotfiles  
  Git Commit: (using Fugitive)
1. "Gstatus" then use "-" to stage/unstage a changed file.
2. Review Changes: "D" (diff) on the file to view what has changed compared to the last commit.
     Use "]c" to navigate and "do" in the right split to revert/undo a changed 'hunk' (go back to what was is in the last commit)
     Note: This is super useful to selectivly roll back a change in some functions while keeping other/newer changes in other parts of the code.
     Alternatively, the changes can also be review using Gitgutter (see 3. below)
3. Add notes for commit message to ~/.vim/notes/commit-nts1.txt
Git Commit: (using terminal)
1. open a terminal at "~" (root folder), "ls -a" confirms that ".vimrc" file is
at the users root directory
2. "git status" should show:
Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
  (use "git checkout -- <file>..." to discard changes in working directory)
        modified:   .vim/colors/molokai.vim
        modified:   .vim/utils/termin1.vim
        modified:   .vimrc
You can use <c-j>, <c-k> to scroll and "q" to quit the view.
3. Review changes to get an idea of a commit message. Use:
nmap <leader>gg :GitGutterToggle<cr>
nmap ]c <Plug>GitGutterNextHunk
nmap [c <Plug>GitGutterPrevHunk
you may use GitGutterUndoHunk (leader hr) to see what was changed
4. Use a temp buffer to make notes for the commit message
5. Run "git add .vimrc .vim/utils/termin1.vim .vim/colors/molokai.vim"
6. After confirming with "git status" again, with the commit message in the yank register, create the 
following line in the terminal (enter "git commit -m '" then paste the yanked text.
git commit -m "Spell command, use Stackage seach, HaskellProjectName, haskell- git- vim- process documentation in termin1"
7. Run "git push". Then the commit should show up here: glb on https://github.com/andreasthoelke/dotfiles/commits/master 
For a new repo: Link local repo to github remote repo:
"git remote add origin https://github.com/andreasthoelke/dotfiles.git", 
"git push -u origin master" `-u` add upstream tracking(!?)
"git pull --rebase origin" pull in changes from remote, put all local changes on top of it.

## Change Commit Message
  * `git commit --amend -m 'New commit text/message'`, then `git push --force` to update remote

## Git Branch Merge
In the following example "freatue1" is a "feature branch". the code for the feature
is just "feature1 implementation" here. After that feature is commited to the "freature1" branch first, it will then be merged into master.
 mkdir gitmerge2 && $_                                                             integ-term-changes
  gitmerge2  echo "base features" > file1                                          integ-term-changes
 git init                                                              integ-term-changes
Initialized empty Git repository in /Users/andreas.thoelke/Documents/temp/gitmerge2/.git/
 git add file1                                                                     master
 git commit -m "first commit"                                                      master
[master (root-commit) 5f02eef] first commit
 1 file changed, 1 insertion(+)
 create mode 100644 file1
 ⋯  Documents  temp  gitmerge2  git checkout -b feature1                                                          master
Switched to a new branch 'feature1'
 echo "feature1 implementation" >> file1                                  130   feature1
 cat file1                                                                       feature1
base features
feature1 implementation
 git status                                                                      feature1
 git add file1                                                                   feature1
 git commit -m "feature 1"                                                       feature1
[feature1 8674a08] feature 1
 1 file changed, 1 insertion(+)
 git checkout master                                                             feature1
Switched to branch 'master'
 cat file1                                                                         master
base features
 git merge feature1                                                                master
Updating 5f02eef..8674a08
Fast-forward
 file1 | 1 +
 1 file changed, 1 insertion(+)
 cat file1                                                                         master
base features
feature1 implementation

## Looking At A Past Commit

Look at the previous commit (HEAD~1):
 ~  .vim  utils  "git checkout HEAD~1"                                                                   int-termin-changes
HEAD is now at f3858c5 Gig commit, preparing release
 ~  .vim  utils                                                                                                   f3858c5
This has now created a tempoary branch. I could persist any commits I make in this temp branch to a
new branch using git checkout -b <new-branch-name>
Note that HEAD detached at f3858c5
You can just go back to the previous HEAD by checking out the branch again:
 ~  .vim  utils  git checkout optim-11-2018-1                                                              130   f3858c5
Previous HEAD position was f3858c5 Gig commit, preparing release
Switched to branch 'optim-11-2018-1'
 ~  .vim  utils  git branch                                                                               optim-11-2018-1
"git branch" shows that the temp branch is gone.
Use Diff Before Add To Stage: - "git diff" 
Unstage: - "git reset HEAD" or "git reset HEAD <filename>"
Erease Delete The Last Commit: - "git reset HEAD~1" This will delete the commit entry but keep the current code (as unstaged changes in relation to the previous (now current) commit).
Git Undo: - "git reset HEAD~1 --hard" will additionally checkout the previous branch and update/overwrite the working dir files! This is basically a real "undo". Note you still have to reload the files in vim.

Three Statemanagement Mechanisms: Working Directory |>>| Staged Snapshot |>>| Commit History


## Staging To Git Index:

Fugitive status: "<leader>gs", "<cr>" to view the file (nicely cancels the diff mode as well). 
"D" to get to diff mode.  Use ":Gwrite" on the working copy to stage the entire file. 
"u"/undo in the (left side) index version of the file will make the diff/difference appear again.  use "diffupdate" to update the diff
Use "Gwrite" from the index version of the file (left side of diff) to "OVERWRITE the working copy with what is currently in the index/stage (which may be what is in the commit)"
Alternatively you can "Gread" from the working copy to read from the index/stage and update the working copy to with it.
Staging Hunks Of Changes: With the cursor on a hunk on the right side of a diff (working copy) do
":diffput" or "dp" to put the change to the diff-split left buffer (into the index/stage buffer). Now do
":w" to write the index/stage buffer! Note that the file now shows up a "staged for commit" *and* as "unstaged change", as there are still changes in the file that are not staged.
also "diffget" or "do" ("optain") in the working copy will undo the hunk-change/ revert it back to what was is in the past commit.
"git diff" in the terminal compares the working copy with what is in the last commit .. vs. 
"git diff --cached" compared the working copy with what is in the current index/stage
"Gwrite" to just stages the current file. Basically "!git add %". ":Git add %" works but requires the buffer wipe action to close the neovim terminal that is run.
Note: In Gstatus you can diff the index/stage to the prev commit. And in the "Changes not staged .." section you can diff the working copy against the index/stage.
Use "c-w c" on the index/left split to get a proper working buffer back, after a Gdiff is reconciled and/or a commit finished with ":wq", 
Gitgutter signs update on save and relate to the last commit/ don't consider the index/stage
To update "Gstatus" preview window, you have to run the command again
"Gedit :%" to get the index/staged version of the current file into a (temp) buffer
"Gdiff" compares to the index/staged version of the current file. "Gwrite" on the index/stage/left
buffer will overwrte the changes in the working copy. Alternatively you could do "Gread" from the working tree/copy.
Gitgutter Stage Hunk: - "leader ha" "hunk add" stages a hunk, but the effect can not be seen in gitgutter.
Gitgutter Undo Hunk:  - "leader hr" rolls back the changed code segment to the *index/stage*, not to the last commit
Staging Partial Hunks: In the diff split on the working copy/right buffer, select a range of lines of a bigger hunk, then ":diffput" only these lines into the index/stage.


## Git Reset

Git reset "overwrites" the tree trees:
1. Move the branch HEAD via "--soft"
2. Make Index look like HEAD "--mixed"
3. Make Working Dir look like Index and HEAD "--hard"
From: https://git-scm.com/book/en/v2/Git-Tools-Reset-Demystified
Undo Last Commit: - "git reset HEAD~1 --soft" moves the branch (the branch HEAD and the global HEAD) to a previous commit, without
changing the index/stage or the working directory. From there you can just "add" to index and commit again to e.g. refine the commit message.
"git reset HEAD~ [--mixed]" Moves HEAD to the previous commit/snapshot *and* "updates the index" with the content of that commit/snapshot!
So this additionally "unstages" the changes of the last commit. This is a rollback to before I ran all my "git add" and "git commit" commands.
"git reset --hard HEAD~" additionally undos all the work/changes in the working directory! It basically goes back to the state of the last commit *and* thows away everything that has been done (working dir changes, staging of those and commit) since then.
Reset Index To HEAD: - "git reset HEAD" (implies --mixed) updates/resets the index/stage with the content of the HEAD commit/snapshot
Copy File In HEAD Snapshot To Index: - "git reset --mixed HEAD file.txt" or simply "git reset file.txt" - 
its basically unstaging that file. E.g. the opposite of "git add file.txt".
Commit An Old File Version Without Loosing Past Commits And Without Changing Working Dir: 
"git reset <commitID> -- file.txt" - this just copies that file version into the index (not the working dir!), then you can "commit" that index.
Patch Option: - "git add", "git reset" and "git checkout" accept the "--patch" option to stage/unstage/overwrite parts/hunks of a file/tree.
Squash Several Commits Into One: - "git reset --soft HEAD~2" will move the HEAD back to the last meaningful commit. 
But the working dir and Index are maintained and ready to be commited in one encompassing commit! The previous in-between commit can no longer be seen in the history.
Checkout Branch: is similar to "git reset --hard [branch]" - it moves HEAD to a commit and updates Index and Working dir.
However, "checkout" only updates (tries to "merge") unchanged files in the dir. Whereas "reset --hard" - "overwrites" files!
Update HEAD: .. also, "checkout" moves HEAD to *point to* (the current commit of/ BRANCH HEAD of) another branch, 
while "reset [branch]" will move the *branch* head (and the global HEAD) to a commit of that other branch!
Example : HEAD points to 'dev' branch. 
If we run "git reset master",    dev branch (current commit/branch HEAD) will be (pointing to) the same commit that master does!
If we run "git checkout master", the global HEAD will be moved to the branch HEAD of master. The Dev branch HEAD does not move.

### Summary
Checkout moves the global HEAD, Reset moves the branch HEAD.
         → Reset changes the branch HEAD (potentially including a commit from another branch) and moves the global HEAD to it.
Checkout File: - "git checkout [branch] -- file.txt" overwrites that file to the current working dir and writes it to the Index.
Who Does Reset And Checkout Affect: HEAD, Index, Workdir and is it WD Safe?
┌────────────────────────────┬──────┬───────┬──────────┬──────────┐
│                            │  HEAD│  Index│  	Workdir│  WD Safe?│
├────────────────────────────┼──────┼───────┼──────────┼──────────┤
│                Commit Level│      │       │          │          │
│     "reset --soft [commit]"│   REF│     NO│        NO│       YES│ only undo the commit, not staging or file changes
│            "reset [commit]"│   REF│    YES│        NO│       YES│ "reset HEAD~" undos the whole commit process (including staging)
│                            │      │       │          │          │ "reset master" let's you continue from the current state of the master branch
│     "reset --hard [commit]"│   REF│    YES│       YES│        NO│ complete overwrite
│         "checkout <commit>"│  HEAD│    YES│       YES│       YES│ will merge with workdir
│                  File Level│      │       │          │          │
│    "reset [commit] <paths>"│    NO│    YES│        NO│       YES│ only puts file into the index. usecase: integrate file from another commit with working dir version of that file: A diff with the fetched index let's you "dp" hunks from the working dir into the index.
│ "checkout [commit] <paths>"│    NO│    YES│       YES│        NO│ overwrite that file in the workdir!
└────────────────────────────┴──────┴───────┴──────────┴──────────┘
HEAD, Index,	Workdir, WD Safe?
Commit Level,,,,
reset --soft [commit], REF, NO, NO, YES
reset [commit], REF, YES, NO, YES
reset --hard [commit], REF, YES, YES, NO
checkout <commit>, HEAD, YES, YES, YES
File Level,,,,
reset [commit] <paths>, NO, YES, NO, YES
checkout [commit] <paths>, NO, YES, YES, NO


## Git Stash

- "git stash" takes working dir and Index, then performs "git reset --hard"
"git stash save “Your stash message”" (note these strange quotes here)
"stach apply", "git stash apply stash@{1}",
examples: - "git stash" then "git checkout -b new-branch HEAD~3"   # head back in time!  
"git stash apply" to a modified working dir shows merge conflicts. An easy way to test stashed changes is 
"git stash branch <brname>". It creates a new branch, checks out the commit you were on, reapplies stashed work there and drops the stach
Alternative: - "git commit -a -m 'stash'" to save my work and "git reset HEAD~1"
View Stash Content: - "stash list", "stash show" and "git stash show -p stash@{2}"
"git stash list --pretty=format:%gd" or "gitk --reflog"

## Alias
	co = checkout
  ci = commit
  st = status
  br = branch
  ap = add --patch
  unstage = reset HEAD --
  last = log -1 HEAD
  hist = log --pretty=format:\"%h %ad | %s%d [%an]\" --graph --date=short
  visual = !gitk

## Git Tags
  * "git tag -a v1.0.0 -m “Git process notes“", "git checkout v<tag>" to checkout a commit based on the related tag!
  * "git tagls" to view. (issue: this seems to appreviate) "git push --tags" to push tags to remote. "git tag -d v<tab>" to delete, then "git push -f --tags"
  * Process:
    * in gv copy the commit messages to release-notes1.txt
    * delete the end of the line after the message! 
    * include the version as headline, e.g. v1.0.3
    * copy into clipboard
    * merge branch to master first?
    * in the console do `git tag -a v1.0.4`
    * then in vim paste the bullit points and :wq
    * then `git push --tags`

view tags https://github.com/andreasthoelke/dotfiles/tags
TODO how to view the full tag/release notes? → change `git tagls`?

## Resolve merge conflicts

1. On the receiving branch (master) run “git merge <merge branch>”
In case of merge conflicts git will put “conflict markers” into conflicted files. These have to be resolved and removed.

2. In vim (turn off autosave). Gstatus lists these files under unmerged paths. Hit <cr> on a file to view it.

3. Find “=====“/ the conflict markers in the file. This is just to illustrate that the fugitive-vim-diff will now resolve these conflicts and remove the markers.

4. In the Gstatus window do “D” on the same file to view a tree-way diff
On the right side move the cursor to the first conflicted hunk (e.g. using “]c”).

  4. Alternatively, and I now prefer this, just go into the conflicted file and remove the markers/sections by hand! - Faster, less confusing and more transparent what is happening. TODO have a mapping that preselected the <<<< HEAD ..insert ... =====, so it can be deleted with one 'd', then jump the re related >>>> <branchname> line to delete this with "dd".

5. Do “dp”/diffput. The right and the middle pane should now look identical for that hunk/conflict. To accept the right panel (all conflicts) do "Gwrite" to write this to the index?

  Alternatively you can “dp” on the left side to keep what is on master

6. After all conflicts in that file have been resolved, Save the middle pane (working copy).

7. Then in Gstatus <cr> on the file again to see it without the diff-markup (don’t bother closing the diff, instead <cr> on the file in Gstatus!)

8. In this (working copy) file search for the “====“ markers, they should be gone.

9. Now (after you saved the file) in Gstatus “-“ on the file to add it to the index/state. (you can’t yet commit it, all conflicted files have to be resolved)

## Sync a fork

### Using github
  * on the github page of your fork it will show that there were upstream commits
    * click compare
    * change base to your fork
    * after the page refresh click compare between forks in the text above
    * change head to the upstream repo

### Using git
  * `git remote add upstream https://github.com/Yilin-Yang/vim-markbar.git`
  * `git remote -v` to view remote repos
  * `git fetch upstream` creates a new local branch that can be ..
  * `git merge upstream/master` merged into master.
  * note this caused an error last time I tried. even `--allow-unrelated-histories` dit not work
  * `gs` shows what needs to be done to still do a merge. basically merge conflict markups in some files have to be resolved manually.

## Open Github repo in browser
  * `glt`, `git remote -v` shows URL, then `c-\ n` to have termial text as normal buffer text
  * vis-select the url of the repo, the `glb` (`gx` does not work)

Easy to read/lear?
https://docs.github.com/en/github

