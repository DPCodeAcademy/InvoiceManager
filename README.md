# InvoiceManager


## Common rules

 * ### swift code style

    Our swift coding style shall follow the site below. 

    https://github.com/github/swift-style-guide (
    [日本語](https://github.com/jarinosuke/swift-style-guide/blob/master/README_JP.md) / [Versão em Português do Brasil](https://github.com/fernandocastor/swift-style-guide/blob/master/README-PTBR.md) )

    We will modify the past code when refactoring later, but for the code you are about to commit, please follow the rule.


 * ### commit message
    All of our committed messages follow the rules of the website below. Please make sure everyone reads through all the instructions.
    https://www.freecodecamp.org/news/how-to-write-better-git-commit-messages/


    Good Ex.) 
        
        feat: improve performance with lazy load implementation for images
        
        chore: update npm dependency to latest version
        
        Fix bug preventing users from submitting the subscribe form
        
        Update incorrect client phone number within footer body per client request
        

    Bad Ex.) 
    
        fixed bug on landing page


## Documentations
#### [Wire Frame](https://whimsical.com/invoice-app-ver2-BypBsk8vL7E974tA1eNNK4)
#### [Class diagram](https://lucid.app/lucidchart/500e2def-3f59-4970-a968-aade24b623cd/edit?page=HWEp-vi-RSFO&invitationId=inv_ce951a1e-e74e-4fbf-b519-c98c86999b43#)

#### [Sequence diagram](https://sequencediagram.org/index.html#initialData=C4S2BsFMAIEkDsBuB7EBjGBBACt6BaaAZUgEcBXSeDaAERAEMBzAJwYFsAoTgBwZdBoQfeMGgBVAM6QWvfoOENR0TDx5yB6RcoDiyZEygrssDQpFiAouwYhw0bC2SIQAExncpM-AD5VPAC5oAHl4aABhcHQAa2hgZGhJECYwkDCAdzAAC2g9AyNMNDRkclFOLxYAHnx8fyCAJUhXEBZINDFyaRY4hLzDSABySWgAIyd0rugGcmAsqkEGUGR4cq7fPoKTIMtRGWg0VvdRRnBJTn9q-A2sLehG4HIWMMQGKNce6Koe6AAzGceYK0KJBJMAzv5fHViPFWh8vmlgDJ4K9wABPc5qdb6frGWBBEjwd5Ayig77XCKvKiufi46AAeh0lgAKt8fpBgGgcijoJBEPNhnxJEl4ExoC83nCwj9kN1ZjA0I9Wsp2MtZhieJdyTg8Xd2Y8wlFScgfjy+aJhj8nOx9pTCfx1ZC1AFwnM0LFpd1mj82UqMMMRuz0pAvgqWEqxOBkGhXtBqcAGFNCb92ZymrHFgwAHTQAA68HCDGksZA3pkVD90HYMiYMDA2bzBaLrmQIPgAzEkAAHiBSZHo-Y4wwADTQGvwGSLGAJ8fpWOQH7TcARqMxw1iY3QZAjABWbTB0Eys2THLm70HmdWMkuUKIWWQs5A7B4MrE-apNMkB2DK0vLEdgRCMJIhib5H2fAQbSgO1ZAqa8nQkYVRT7Vce3XE0t13dpJBHSQ71nBVQWQKtujXRIvyoTw1j8eCSCgdpN3HfZOniYjfitaA11-OCANve8mMI1j3HjOxhk-VoKN-f8glCfYojdb5pBgFVYSE2xTi4mobzw6A0hQdAYA9Jiw3mStVRyVSRMo7xqIAmS0Dk2J4h5ZoxF01AaERJ9wEnDStL4powB0pB3JgTyeG8xEyPEn8KikwCIgchSqSCvSMAdGygh0KgJ0i7BaAAMV+OxQoSaQk0WeNU3eNIeRsOx0usNSHCcFx3BYTL2VHbK2ERd48sKn5isTd4yqJMgSTEQVEKKownMgOr7FGvYeBatwPCsv8Mvi4D5Jq6RiiTeMRmgAAKSwzWAABKXz4KkNIkJXexSI3DC92wxJtN5EzSLE78Nri2i9wYmAvuUS0iLiOYONQjTahoz6LrnYTTiiv7JK2uzEpqgAqbHws6E6AGpLtx0YZniFZYM0+H-Jc00TM-U9yCMX6KKpuHbLCTo9hGBh5KclbeRAEpRPI+AcIYPkpnAexOSUGthmmFjFnQFF0X+jGgKxsJ9uWd4jtOohyHYGwWFRa6qbqO6RQ4x7oaNdCdzenDtMkY3TdRTcTXswtpAFPZQXII4xFZlYgA)

#### [Use case diagram](https://lucid.app/lucidchart/42aeef8e-ee93-4c03-bfe4-1b626cbbc714/edit?beaconFlowId=40D92E1BDEB4F447&invitationId=inv_0795ee36-c282-4642-8948-c423241fc240&page=0_0#?referringapp=slack)


## How to pull request

### Step 1: Clone local repository
`$ git clone https://github.com/DPCodeAcademy/InvoiceManager.git`

### Step 2: Create a branch
`git branch <branchname>`

Name the branch <branchname> according to the following naming convention.
 * Additional features, prefix it with "feature/".

    Ex.) "feature/addTitle".
    
 * fixing bugs, prefix it with "fix/".
 
    Ex.) "fix/addTitle"

### Step 3: Implement your code & commit
1. Open project.
2. Implement your code.
3. Commit

`git add .`

`git commit -m "description"`

### Step 4: Update the branch
`git pull origin main`

### Step 5: Test localy
In your local environment, make sure that you can build, debug, and check that there are no problems.
For the screen layout, Please run at least the following iPhone models and make sure the text is readable.

iPhone 8 (4.7''), iPhone 11 (6.1''), iPhone 13 Pro Max (6.7'')

![Screen Shot 2022-07-18 at 10 11 33 AM](https://user-images.githubusercontent.com/90675874/179566418-97783b35-cfd3-435f-b90c-7d3250ea544a.png)


### Step 6: Send a pull request
`git push -u origin <branchname>`
Pull Request from remote repository. [README](https://help.github.com/articles/creating-a-pull-request-from-a-fork/)
