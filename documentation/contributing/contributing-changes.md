### Contributing Changes

When you make changes, Github Desktop will update with a list of all the changes you have made to the files since your last "commit"

![Changes Example](/documentation/readme-images/changes.png)

A "commit" is when you set your changes into your local repository. Basically, it's like making a progress "checkpoint", which can be reverted to at any point. You can commit your current changes by pressing the blue commit button underneath your changes. It's good practice to commit your changes every time you make good progress, and before you do something that could cause problems. Do note, that these commits are **not sent to the online repository** yet. When you have commits that aren't sent to the remote (online) repository, you'll see the "push origin" button near the top of the GUI

![Push Origin Example](/documentation/readme-images/push.png)

Pressing this will "push" your commits to the remote repository, ensuring they aren't lost, and letting other people see your changes. If you either work on multiple computers, or work with other people, you may see the button become "pull origin". Pressing this will download the changes to your machine, so you can work on them.

In the Gigagame repository, you cannot directly send your changes to the main branch. Instead, you'll have to make a branch for the changes you want to make, then make a pull request for adding those changes to the main project.

#### How Branches work

Branches are extremely important for working on changes to Gigagame. In git, branches are a way to separate work across many people, without running into conflicts when two people work on the project at the same time. For example, if I wanted to add an "Apple" item to the game, I could make a branch named "adding-apple-item". If I switch to that branch, and add the apple item to the game, my changes will only appear in the adding-apple-item branch. When I'm done adding the item, I can create a "Pull Request". Pull requests are a way to "pull" the changes you made back into the main branch, and therefore adding your changes to the game. When making a pull request, you can add a Title and Description for it, and these should generally reflect the changes you have made in that branch. In the Gigagame repository, once a pull request has been created, it cannot immediately be merged into the main branch. Instead, someone has to "review" your changes, and then approve them, to let it be merged. Anyone else in the Repository can approve pull requests.

To create a branch in Github Desktop, you can navigate to the "Branch" tab, and click "New Branch"

[![New Branch Example](/documentation/readme-images/branch-example.png)]

#### Creating Pull Requests

When you are ready to add your changes to the main branch, and you have no uncommitted changes, and you've pushed your changes, you'll be able to see a "Preview Pull Request" button on the main page. Pressing this will bring up a preview of all the changes in the branch, and pressing the blue "Create Pull Request" button. Pressing this will open up the Github repository in your web browser.

![Pull Request Button Example](/documentation/readme-images/pull-request.png)

You'll then see the "Open Pull Request" page for your current branch. Here is where you'll add the title and description of your pull request. Make sure to describe what changes you've made, so that other contributors know what to look for. When you are done writing those up, you can press the green "Create Pull Request" button to make the request!

![Create Pull Request Example](/documentation/readme-images/make-request.png)