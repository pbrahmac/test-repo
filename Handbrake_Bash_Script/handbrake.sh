runpy3 () {
/usr/local/bin/python3 << 'EOF' - "$@"

import os
import sys
import subprocess

preset_json_path = os.path.normpath('/Users/parjanya/Documents/madHacks/Handbrake_Bash_Script/MyHEVCPreset.json')
preset_name = "MyHEVCPreset"
command = ["HandBrakeCLI", "--preset-import-file", preset_json_path, "-Z", preset_name]

def convert_directory(direc):
    global command
    os.chdir(direc)
    try:
        os.mkdir("Compressed")
    except OSError:
        print("Directory already exists.")
        exit(3)
    for file in os.listdir(direc):
        if file.endswith(".mp4") or file.endswith(".mov"):
            output_file = file[:-4] + "_compressed.mp4"
            command += ["-i", file, "-o", output_file]
            try:
                subprocess.check_call(command)
            except subprocess.CalledProcessError as e:
                print("Conversion unsuccessful: exit code " + str(e.returncode))
                exit(2)
    for file in os.listdir(direc):
        if file.endswith("_compressed.mp4"):
            current_path = os.getcwd() + "/" + file
            new_path = os.getcwd() + "/Compressed/" + file
            os.rename(current_path, new_path)
    print("Successfully encoded all videos in directory.")
    exit(0)

def convert_file(file_dir):
    global command
    os.chdir(os.path.dirname(file_dir))
    file = os.path.basename(file_dir)
    output_file = file[:-4] + "_compressed.mp4"
    command += ["-i", file, "-o", output_file]
    try:
        subprocess.check_call(command)
    except subprocess.CalledProcessError as e:
        print("Conversion unsuccessful: exit code " + str(e.returncode))
        exit(2)
    print("Successfully encoded file.")
    exit(0)

#----------------- MAIN CODE -----------------

current_dir = sys.argv[1]
if os.path.isdir(current_dir): #directories
    convert_directory(current_dir)
elif os.path.isfile(current_dir): #files
    convert_file(current_dir)
else:
    print("Invalid input.")
    exit(1)

}

runpy3 "$@"