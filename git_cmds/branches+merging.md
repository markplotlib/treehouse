Course: [Git Branches and Merging](https://teamtreehouse.com/library/git-branches-and-merging)

# Branches

A branch is just a pointer to a particular commit.

The history for a branch is determined by the commits themselves. 
Every commit has a "parent", that is, another commit that it's based on.

`git log` looks at each commit, then moves to its parent.
This is true even for commits on a new branch. The commit's parent may be a commit that another branch points to.

## Avoiding Poor Practice 

Making commits to the `master` branch is *widely considered to be a bad idea*. 
Most developers treat the `master` branch as code that has been *thoroughly tested*
and is always ready to deploy to customers. If you've just finished some code that isn't 
thoroughly tested and ready to share, it shouldn't be committed to the master branch.

## Another Topic Branch

A "topic" is defined as "a matter dealt with in a book or article". 
e.g., adding a new feature to a program.

You want to check out the `master` branch before creating any topic branches. 
It's a good idea to ensure your topic branch is based on the `master` branch, 
if you're planning to merge it back into `master`. 

## Viewing Differences Between Branches

What if you forgot what's on a branch?  Suppose you've gotten pulled away for a week. Or suppose it's not even your branch, but one created by a collaborator. 
Branches can be transferred to other repositories, and you're going to need a convenient way to see what's on those branches.

### diff between branches

`git diff master testing`

* You aren't resricted to the branch that's currently checked out.

* * e.g., `git diff alternate-branch1 alternate-branch2`

* When you type only one branch name, Git will compare the contents of the working directory that you're in, to that branch.


### diff between commits

Since a branch is just a pointer to a specific commit, you can use `diff` between two SHAs or two branches.

`git diff [earlier SHA] [later SHA]`

`git log -p`
You can see individual changes that went into this commit.

Notes:

On many systems, Git is configured to use the vi text editor by default. 
You may want to familiarize yourself with [basic vi commands](https://kb.iu.edu/d/adxz).