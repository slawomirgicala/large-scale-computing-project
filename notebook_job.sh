#!/bin/bash

#SBATCH --job-name=jupyter_notebook_launch
#SBATCH --output=jupyter-%j.log 
#SBATCH --error=jupyter-%j.err

# Load module with python and jupyter notebook
module purge
module load plgrid/tools/python-intel/3.5.3

# Get available port for notebook and tunneling to your local machine
NOTEBOOK_PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()');
TUNNEL_PORT=$(python -c 'import socket; s=socket.socket(); s.bind(("", 0)); print(s.getsockname()[1]); s.close()');
echo "NOTEBOOK_PORT='$NOTEBOOK_PORT'"

# Tunneling
ssh -R$TUNNEL_PORT:localhost:$NOTEBOOK_PORT ui.cyfronet.pl -N -f

echo "FWDSSH='ssh -L$NOTEBOOK_PORT:localhost:$TUNNEL_PORT $(whoami)@ui.cyfronet.pl -N'"

# Start the notebook
unset XDG_RUNTIME_DIR
jupyter-notebook --no-browser --no-mathjax --port=$NOTEBOOK_PORT
