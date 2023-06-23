import os
import ctypes
import platform

curr_dir = os.getcwd()

if (platform.system() == 'Windows'):
    osConfDir = os.getenv('APPDATA')
else:
    print('This is not a windows machine, update the script to work with this as well.')


def lnk(src, dst, target_is_directory=False):
    flags = 1 if target_is_directory else 0
    if ctypes.windll.kernel32.CreateSymbolicLinkW(dst, src, flags) == 0:
        raise ctypes.WinError()

comb = os.path.join

class LinkFile:
    def __init__(self, origin, destination, type="file"):
        self.origin = origin
        self.destination = destination
        self.type = type

class helix:
    # def __init__(self):
        
    def install(self):
        #Link helix 
        try:
            os.mkdir(comb(osConfDir,'helix'))
        except FileExistsError:
            pass
        try:
            lnk(comb(curr_dir, 'helix', 'config.toml'),comb(osConfDir,'helix','config.toml'))
        except FileExistsError:
            pass        
        try:
            lnk(comb(curr_dir, 'helix','languages.toml'),comb(osConfDir,'helix','languages.toml'))
        except FileExistsError:
            pass         
        try:
            lnk(comb(curr_dir, 'helix','themes'),comb(osConfDir,'helix','themes'), True)
        except FileExistsError:
            pass         
hx = helix()
hx.install()

