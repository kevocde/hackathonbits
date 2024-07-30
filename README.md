<div align="center">
<a href="https://github.com/kevocde/bits-hackaton">
	<img src="https://www.bitsamericas.com/sites/default/files/logo-bits.png" alt="Logo" width="100">
</a>
  <h2 align="center">Hackathon 2024</h2>
  <p align="center">
    Proposed solution for the <strong>Bits' Hackathon</strong> 2024.
    <br />
    <br />
    <a href="https://kevocde.github.io/bits-hackaton" target="_blank">View Demo</a>
    ·
    <a href="https://github.com/kevocde/bits-hackaton/issues">Report Bug</a>
    ·
    <a href="https://github.com/kevocde/bits-hackaton/issues">Request Feature</a>
  </p>
</div>

## 📖 About the repo
This is the proposed solution by [@kevocde](https://github.com/kevocde) for the two challenges given in the Bits' Hackathon 2024.

## 🌅 The challenges
### 🖥 Bash skills
#### Requirements
- Create a GitHub repository and expose this via Rest API
- Create a ShellScript to connect by GitHub Rest API and list all the branches and put those in a file with the next structure: `branch_name/last_commit_time - author_name`
- Later of create that repository, the script should remove all branches by the next conditions:
	- The branch isn't protected by GitHub
	- The branch don't have changes since two days ago
- Later, create other script, which creates automatically a pull request, later of request the next information:
	- pull request title: validate that it contains at least 5 words and ends with numeral symbol (#) and 4 numbers.
	- Origin branch
	- Target branch
- The additional description of the commit should be contains at least 10 words too
### 🚢 Containers & bash
#### Requirements
- Create a script to automate con building of a container with:
	- Create `Dockerfile` for a web app in (whatever you want to use).
	- Include a tool for do debug.
	- Create the script to build the image
- Create a script to automate the deploy of the container
	- Create a script to execute a Docker image, expose the ports needed to access to the web app.
	- Ensure the right container running and accessible status to the web app.
- Create a script to automate the container management
	- Develop a script to run, stop and restart a container
	- Create script for monitoring the container, showing the use of resources (cpu and memory), and the logs of the application.
- Create a script to clean a container and images
	- Write a script to delete the unused containers and images to free up space.

## Solution
### Bash skills
First of all, the designed solution just will have a one point of access (just a file: challenge_1.sh) and all the next options will be accesible via the first parameter like: `./challenge_1.sh action ...other arguments`.

#### 1. Export all the branches

