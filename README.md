# Mini CI

If you are looking for lightweight and simple solution for CI then you found it :)


## The idea

The normal continuous integrate/deploy system usually be triggered by post-receive (After the code come to remote repo)

I want the code is tested before go to remote repository

and

Real-time test on every push

Then it should be: local machine => mini ci  => remote repo (bitbucket|github...)

If there is any error, the mini ci server will cancel your push

Every push on any branch will trigger `build.sh` which will you script it to make it do anything you want.

### Deployment 

If you push on production/staging branch it will trigger the `deploy.sh` script which do anything you want (Because you will script it :) )

Every push to these branches will trigger `build.sh` also. And it will not call `deploy.sh` if test is failed. 


## Then what?

All you need is script `build.sh` to build your application and `deploy.sh` to deploy

## Usage 

After everything is tested (`build.sh` and `deploy.sh`): 

- You need a server to be a mini ci server. Eg. ci.yourcompany.com

- Create a user named `git`

- Make your server push code to end repo (bitbucket|github|googlecode...) without password
 
- Run `setup.sh <your-working-directory> <your-end-repo>` Eg. `./setup.sh /home/git/ci-workspace/my-project ssh://git@bitbucket/jandjerry.com/ci-test.git`

- Your git repo to ci server will appear on screen. Eg. `ssh://git@ci.yourcompany.com//home/git/ci-workspace/my-project/main/repo.git`

That's all 

## Final 

- I don't have good English, so let try your best to understand this file

- Because of reason above, feel free to send a PR

- Feel free to fork, edit, redistribute.... or do anything you want because I don't understand licence types
 
- It's will be great if I got your pull requests to improve this :) 