# Seurat tutorial
This project provides a comprehensive guide to using Git, SLURM, 
and the biodata R library for working with High-Performance Computing (HPC) environments.

# Setup
## Git
1. Install Git following the [official git installation guide](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
2. COnfigure git
```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

## SLURM
1. Verify that SLURM is installed on the HPC cluster you are going to use.
2. Basic commands: familiarize with basic commands.
   1. Check [CPU managment](https://slurm.schedmd.com/cpu_management.html)

## R and seurat
1. Install R on the server. You may need it support to do it for you.
2. Install the required libraries.

# Working with git
 Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

 Check basic git commands at [git_help.bat](git_help.bat)

 # Working with slurm
 You can submit work creating a job script like `test.slurm`:
 ```bash
 #!/bin/bash
#SBATCH --job-name=my_job
#SBATCH --output=output.log
#SBATCH --error=error.log
#SBATCH --ntasks=1
#SBATCH --time=01:00:00

module load R
Rscript my_script.R
```
and submit the job with `sbatch test.slurm`.


Another approach is to use a interactive schedule. Check [server/main.sh](server/main.sh) for more details. Keep in mind that you should create a `.env` file with configuration at that location. This is sensible information that should never be shared nor commited. It should look something like:
```
# Ajustes de recursos
CPUS=1
TIME=01:00:00
MEM=4G
PARTITION=partititon


# Ajustes del script
R_MODULE=path-to-r-module
SCRIPT=path-to-file
```

You can check status of jobs with `squeue -u your-username`

# Seurat
Check [Seurat_tutorial.R](Seurat_tutorial.R)

