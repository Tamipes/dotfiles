#!/usr/bin/env python3

import os
import ctypes
import platform
import subprocess
import shutil
Linux = 'Linux'
Windows = 'Windows'

def link(src,dest,folder):
    if platform.system() == Windows:
        if folder == True:
            subprocess.run(['cmd','/c','mklink','/J',dest,src],shell=True)
        else:
            os.link(src,dest)
    elif platform.system() == Linux:
        if folder == True:
            os.symlink(src,dest)
        else:
            os.symlink(src,dest)
    

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
    def exist_dest(self):
        exists = (os.path.islink(self.destination) or os.path.exists(self.destination)) 
        return exists

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
        if not os.path.exists(os.path.dirname(self.destination)):
            os.makedirs(os.path.dirname(self.destination))

        if not self.type == 'msg':
            link(self.origin,self.destination,self.target_is_directory)
        else:
            print('MESSAGE:    '+self.message)

    def is_dest_link_origin(self):
        installed = False
        if os.path.islink(self.destination) and self.exist_dest():
            installed = os.readlink(self.destination) == self.origin
        return installed


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
                    if file.is_dest_link_origin():
                        print(f'INFO   :    Already installed: {file.destination}' )
                        continue
                    if file.exist_dest():
                        print('WARNING:    A different file already exits ... removing: '+self.destination)
                        file.rm()
                    file.lnk()
                    print('INFO   :    Linked to this file: ' + file.destination)
                except FileExistsError:
                    print('ERROR  :    This file already exists: ' + file.destination)
                    pass


def main():
    curr_dir = os.getcwd()

    if platform.system() == Windows:
        osConfDir = os.getenv('APPDATA')
        print("INFO   :    Platform is Windows, config directory is set to %APPDATA% -> " +osConfDir )
    elif platform.system() == Linux:
        print("INFO   :    Platform is Linux")
        osConfDir = os.getenv('HOME') + '/.config'
        if "root" in osConfDir:
            print("User detected as root, assuming this is install to root is undesirable.")
            print("Instead you will be prompted to choose a user in /home.")
            answer = input("Do you want to proceed? (y/n)")
            print()
            if answer.lower() == "y":
                allUsers = next(os.walk(r'/home'))[1]

                print("-1 - Chose custom directory")
                i = 0
                for user in allUsers:
                    print(f"{i} - {user} (/home/{user})")
                    i = i + 1
                print()
                print("Chose a number from the list abbove to install to that directory, the mainly used directories")
                print("are '.config/' and some files as '.bashrc'.")
                answer = input("Number: ")
                if int(answer) >= 0 and int(answer) < len(allUsers) :
                    osConfDir = f"/home/{allUsers[int(answer)]}"
                elif int(answer) == -1:
                    answer = input("The user dir is:")
                    osConfDir = answer
                else:
                    print("bad nubmer, exiting")
                    return
            print()
        print("INFO   :    Config directory is set to -> "+osConfDir )
    else:
        print('ERROR  :    This is not a windows or linux machine, update the script to work with this as well.')
        return 0
    print()

    print("This script will overwrite the folders as well. Don't run it if you aren't sure what you're doing.")
    answer = input("Do you want to proceed? (y/n): ")
    if answer.lower() != "y":
        print('Script execution aborted. Good choice!')
        return
    
    programs = [
        # Program('Fastfetch', [
        #     LinkFile([curr_dir, 'fastfetch_presets', 'tami'], ['/usr/share/fastfetch/presets', 'tami'])
        # ]),
        Program('Bash', [
            LinkFile([curr_dir,'bash','.bashrc'],[osConfDir,'..' , '.bashrc'])]),
        Program('Kitty', [
            LinkFile([curr_dir, 'kitty'], [osConfDir, 'kitty'], 'dir')
        ]),
        Program('Ricemood', [
            LinkFile([curr_dir, 'ricemood'], [osConfDir, 'ricemood'], 'dir')
        ]),
        Program('Fish', [
            LinkFile([curr_dir, 'fish'], [osConfDir, 'fish'], 'dir')
        ]),
        Program('Tmux', [
            LinkFile([curr_dir, 'tmux.conf'], [osConfDir, 'tmux', 'tmux.conf'])
        ]),
        Program('Helix', [
            LinkFile([curr_dir, 'helix', 'config.toml'], [osConfDir, 'helix', 'config.toml']),
            LinkFile([curr_dir, 'helix', 'languages.toml'], [osConfDir, 'helix', 'languages.toml']),
            LinkFile([curr_dir, 'helix', 'themes'], [osConfDir, 'helix', 'themes'], 'dir'),
            LinkFile([curr_dir, 'helix', 'runtime', 'queries', 'arduino'], [osConfDir, 'runtime', 'queries', 'arduino'], 'dir')
        ]),
        Program('Cmus', [
            LinkFile([curr_dir, 'cmus', 'autosave'], [osConfDir, 'cmus', 'autosave'])
        ]),
        Program('i3', [
            LinkFile([curr_dir, 'i3', 'config'], [osConfDir, 'i3', 'config'])
        ]),
        Program('picom', [
            LinkFile([curr_dir, 'picom', 'picom.conf'], [osConfDir, 'picom', 'picom.conf'])
        ]),
        Program('polybar', [
            LinkFile([curr_dir, 'polybar', 'launch.sh'], [osConfDir, 'polybar', 'launch.sh']),
            LinkFile([curr_dir, 'polybar', 'config.ini'], [osConfDir, 'polybar', 'config.ini'])
        ]),
        Program('rofi', [
            LinkFile([curr_dir, 'rofi', 'theme.rasi'], [osConfDir, 'rofi', 'theme.rasi']),
            LinkFile([curr_dir, 'rofi', 'rounded-common.rasi'], [osConfDir, 'rofi', 'rounded-common.rasi']),
            LinkFile([curr_dir, 'rofi', 'config.rasi'], [osConfDir, 'rofi', 'config.rasi'])
        ]),
        Program('starship', [
            LinkFile([curr_dir, 'starship.toml'], [osConfDir, 'starship.toml'])
        ])
    ]

    for program in programs:
        print(f'--- Installing: {program.name} ---')
        program.install()

    print("Script execution completed. All required links created.")


if __name__ == "__main__":
    main()
