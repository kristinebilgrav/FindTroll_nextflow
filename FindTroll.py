import sys
import argparse
import os
import yaml
import re

"""


"""
def get_output_dir(config):
    """
    writes working-dir path in config
    """
    working_dir = None
    for line in open(config):
        param=line.split("=")
        if "working_dir" in param[0]:
            working_dir= re.split('\"|\'',param[1])[1]

    return working_dir

def retrieve_status():
    """
    finds status
    """

def worker():
    """

    """

def print_yaml():
    """

    """

def read_yaml(working_dir):
    """
    reads yaml file to find?
    """

    status={}
    if os.path.exists( os.path.join(working_dir,"tracker.yml") ):
        with open(os.path.join(working_dir,"tracker.yml"), 'r') as stream:
            status=yaml.load(stream)
    return status

def check_lock(working_dir):
        """
        checks that dir not locked
        by other process
        """

        if os.path.isfile(os.path.join(working_dir,"lock")):
            print ("error: the ouput directory is locked! Choose another output directory, or wait for the ongoing analysis to finish")
            print ("If the analysis crashed, remove the lock file and restart the analysis")
            quit()

parser = argparse.ArgumentParser("FindTroll",add_help=False)
parser.add_argument('--bam', type=str,help="analyse the bam file")
parser.add_argument("--folder", type=str,help="analyse every bam file within a folder")
parser.add_argument('--output', type=str,default=None,help="the output is stored in this folder, default output folder is fetched from the config file")
parser.add_argument("--config",type=str, default=None,help="the config file")
#parser.add_argument("--restart",action="store_true",help="restart module: perform the selected restart on the specified folder")
args, unknown = parser.parse_known_args()
programDirectory = os.path.dirname(os.path.abspath(__file__))

#analyse one single bam file
if args.bam:
    """
    defines arguments beloning to
    """
    parser = argparse.ArgumentParser("FindTroll core module",add_help=False)
    parser.add_argument('--bam', type=str,help="analyse the bam file")
    parser.add_argument('--output', type=str,default=None,help="the output is stored in this folder")
    parser.add_argument("--config",type=str, required=True,default=None,help="the location of the config file(default= the same folder as the FindTroll-core script")
    args = parser.parse_args()

    #gets config file and finds output dir
    if not args.output:
        args.output=get_output_dir(args.config)
    check_lock(args.output)

    #checks that file is not already analyzed
    status=read_yaml(args.output)
    prefix=args.bam.split("/")[-1].replace(".bam","")
    if not prefix in status:
        status[prefix]={}
        status[prefix]["bam_file"]=args.bam
        status[prefix]["status"]="SUBMITTED"

        status=worker([{"bam":args.bam,"mode":"full"}],args,status)
        print_yaml(status,args.output)
    else:
        print ("Error: the bam file is already analysed, either restart the analysis using restart, or use an other working directory")


#analyse all bamfiles within a folder(recursive searching)
elif args.folder:
    parser = argparse.ArgumentParser("FindTroll core module",add_help=False)
    parser.add_argument("--folder", type=str,help="analyse every bam file within a folder using FindSV")
    parser.add_argument('--output', type=str,default=None,help="the output is stored in this folder")
    parser.add_argument("--config", required=True, type=str, default=None,help="the config file")
    args = parser.parse_args()

    #get output dir
    if not args.output:
        args.output=get_output_dir(args.config)
    status=read_yaml(args.output)
    check_lock(args.output)

    #get bam files in folder
    bam_files=[]
    for root, dirnames, filenames in os.walk(args.folder):
        for filename in fnmatch.filter(filenames, '*.bam'):
            bam=os.path.join(root, filename)
            prefix=bam.split("/")[-1].replace(".bam","")
            if not prefix in status:
                status[prefix]={}
                status[prefix]["bam_file"]=bam
                status[prefix]["status"]="SUBMITTED"
                bam_files.append(bam)

    if bam_files:

        bam_files=",".join(bam_files)
        status=worker([{"bam":bam_files,"mode":"full"}],args,status)
        print_yaml(status,args.output)

    else:
        print ("error: no new bam files was found, use the restart module if you wish to restart any sample")


else:
        parser.print_help()
