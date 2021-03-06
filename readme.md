# JobPipline
This is the repository for the solution to FAISAL coop pre-interview exercise.

## Idea
After the user upload the email address and the jobs (bash scripts here) to be processed, the web UI (HTML NodeJS) would collect the jobs (script files) and store them in the pending folder. Assuming we have 5 threads and each thread allows 6 serial jobs. To emulate multi-threading processing in bash, we created 5 folders each maintaining a 6-job queue.

The main script (script.sh) which would be run by cron daemon is responsible for assigning pending jobs to the five threads/folders with the earliest created job being assigned first. Also, the five threads/folders are sorted in decreasing order of currently available positions and the one with the largest amount of available slots would be assigned with the first job and so on. We keep assigning jobs to these threads until either all pending jobs are assigned or all five threads/folders are filled with six jobs already.

Then as we start the monitor (monintor.sh), five worker processes (five instances of worker.sh) would be start running. Each worker process monitors one thread/folder. When there are files presenting in the corresponding folder, the worker process would execute the first job come into the folder and then send the result back to the user provided email address. Note that the five worker processes are running simultaneously as backgrond processes.



## Usage
Make sure all scripts and folders are as they present in the github repo when you download it to your local computer and try not to move any of them.

### WebUI
Move to ``` src ``` directory and type ``` npm install ``` in your command line. Then type ``` nodemon ``` (make sure you have nodemon installed on your local machine) and the server would start running on your local machine. You can then type ``` localhost:3000 ``` in your browser and the UI would show up.

### Script
Copy the content in crontab to your local crontab file. To edit your local crontab file, enter ``` crontab -e ``` in your command line. The setting here basically asks cron to execute ``` script.sh ``` every minute.

To start the monitor ``` cd ``` to the directory where your local copy of ``` monitor.sh ``` locates and start running the script by ``` ./monitor.sh t``` where t is the time in seconds that you would like the worker processes to rest after each round of execution. The monitor script would run infinitely and if you want to terminate the monitor and worker processes just do ``` Ctrl-c ``` in your command line.
