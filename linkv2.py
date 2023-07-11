import os
import ctypes
import platform
import subprocess
import shutil

def link(src,dest,folder):
    if platform.system() == 'Windows':
        if folder == True:
            subprocess.run(['cmd','/c','mklink','/J',dest,src],shell=True)
        else:
            os.link(src,dest)
    elif platform.system() == 'Linux':
        if folder == true:
            os.symlink(src,dest)
        else:
            os.link(src,dest)
    

class LinkFile:
    # 'type' can be: 'file', 'dir', 'msg'
    def __init__(self, origin_parts, destination_parts, type="file",message = None):
        self.type = type
        if not type == 'msg':
            self.origin = os.path.join(*origin_parts)
            self.destination = os.path.join(*destination_parts)
            self.target_is_directory = True if type == "dir" else False
            self.message = message
        else:
            self.origin = None
            self.destination = None
            self.target_is_directory = None
            self.message = message
    def rm(self):
        if not self.type== 'msg':
            if os.path.islink(self.destination):
                os.unlink(self.destination)
            elif os.path.exists(self.destination):
                if self.target_is_directory:
                    shutil.rmtree(self.destination)
                else:
                    os.remove(self.destination)

    def lnk(self):
        if not self.type == 'msg':
            link(self.origin,self.destination,self.target_is_directory)
        else:
            print('MESSAGE:    '+self.message)


class Program:
    def __init__(self, name, files):
        self.name = name
        self.files = files

    def install(self):
        for file in self.files:
            if file.type == 'msg':
                print('MESSAGE:    ' + file.message)
            else:
                try:
                    if not os.path.exists(os.path.dirname(file.destination)):
                        os.makedirs(os.path.dirname(file.destination))
                    if os.path.exists(file.destination):
                        file.rm()
                    file.lnk()
                    print('INFO   :    Linked to this directory: ' + file.destination)
                except FileExistsError:
                    print('WARNING:    This file already exists: ' + file.destination)
                    pass


def main():
    curr_dir = os.getcwd()

    if platform.system() == 'Windows':
        osConfDir = os.getenv('APPDATA')
        print("INFO   :    Platform is Windows, config directory is set to %APPDATA%")
    elif platform.system() == 'Linux':
        osConfDir = os.getenv('HOME') + '/.config'
        print("INFO   :    Platform is Linux, config directory is set to '$HOME/.config'")
    else:
        print('ERROR  :    This is not a windows machine, update the script to work with this as well.')
    print()
    
    answer = input("This script will overwrite the folders as well. Don't run it if you aren't sure what you're doing. Do you want to proceed? (y/n)")
    if answer.lower() != "y":
        print('Script execution aborted. Good choice!')
    
    helix_files = [
        LinkFile([curr_dir, 'helix', 'config.toml'], [osConfDir,'helix','config.toml']),
        LinkFile([curr_dir, 'helix', 'languages.toml'], [osConfDir,'helix','languages.toml']),
        LinkFile([curr_dir, 'helix', 'themes'], [osConfDir,'helix','themes'], 'dir'),
        LinkFile(None,None,'msg',"The 'runtime' folder is still needed for completeness, this only links my customizations. (But it should not require manual intervention, thanks to helix installation.)")
    ]

    helix = Program('helix', helix_files)
    helix.install()


if __name__ == "__main__":
    main()