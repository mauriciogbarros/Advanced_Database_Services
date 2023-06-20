Get list of branches:
- git branch
- git branch -a: list both remote-tracking and local branches

To change branches:
- git checkout <branch_name>

To create a new branch:
- git branch <new_branch_name>

To create a new branch and switch to the new branch:
- git checkout -b <new_branch_name>

To stage a file that will be committed:
- git add [filename]

Common usages and options for git add
- git add <path>: stage a specific directory or file.
- git add . : stage all files (not listed in .gitignore) in the entire repository.

To commit staged files:
- git commit -m "descriptive commit message"
- git commit -am "descriptive commit message": in addition to commit, allows skipping the staging phase.

To upload local branch commits to corresponding remote branch.
- git push.

To push a new branch to remote repository
- git push -u origin [branch]

To delete a local branch (switch to another branch first)
- git branch -d [branch_name]

To delete a remote branch
- git push remote_name -d remote_branch_name
- ex.: git push origin -d q10_gleison