#!/usr/bin/env python3

import argparse
import logging
import os
import sys
import errno

class bcolors:
    cols = {
        "HEADER": '\033[95m',
        "BLUE": '\033[94m',
        "GREEN": '\033[92m',
        "WARNING": '\033[93m',
        "FAIL": '\033[91m',
        "ENDC": '\033[0m',
        "BOLD": '\033[1m',
        "UNDERLINE": '\033[4m'
    }

    @staticmethod
    def color(s, c="BLUE", b=False, u=False):
        decorators = bcolors.cols[c]
        if b:
            decorators += bcolors.cols["BOLD"]
        if u:
            decorators += bcolors.cols["UNDERLINE"]
        return "%s%s%s" % (decorators,s,bcolors.cols["ENDC"])

def parse_options():
    parser = argparse.ArgumentParser(prog="dotlinker", description="Create and remove symbolic links to dotfiles. Default behavior is to create symbolic links.", add_help=True)
    parser.add_argument("-d", "--debug", action="store_true", help="set logging to debug")
    parser.add_argument("-q", "--quiet", action="store_true", help="set logging to quiet")
    parser.add_argument("-r", "--remove", action="store_true", help="remove links")
    parser.add_argument("-f", "--force", action="store_true", help="force removal or creation")
    parser.add_argument("-k", "--kill", action="store_true", help="exit if an error occurs")
    return parser.parse_args()

def setup_logging(args):
    if args.quiet:
        lg_level = logging.WARN
    elif args.debug:
        lg_level = logging.DEBUG
    else:
        lg_level = logging.INFO
    logging.basicConfig(level=lg_level)

def main():
    args = parse_options()
    setup_logging(args)
    blacklist = ["p.enc", ".git", "link.py"]
    for x in [ x for x in os.listdir(".") if x not in blacklist ]:
        if args.remove:
            try:
                logging.info("going to remove %s" % x)
                os.remove(os.path.expanduser("~") + "/%s" % x)
            except OSError as e:
                logging.error("Could not remove %s" % x)
                if args.kill:
                    sys.exit()
        else:
            try:
                logging.info("going to create symlink for %s" % x)
                logging.info("using %s as the target and %s as the new link" % (os.path.abspath(x), os.path.expanduser("~") + "/%s" % x))
                os.symlink(os.path.abspath(x), os.path.expanduser("~") + "/%s" % x)
            except OSError as e:
                if not args.force:
                    logging.error("%s already exists, use --force if you want to overwrite it" % x)
                elif e.errno == errno.EEXIST:
                    if os.path.isdir(os.path.expanduser("~") + "/%s" % x):
                        if os.path.islink(os.path.expanduser("~") + "/%s" % x):
                            os.remove(os.path.expanduser("~") + "/%s" % x)
                        else:
                            os.rmdir(os.path.expanduser("~") + "/%s" % x)
                    else:
                        os.remove(os.path.expanduser("~") + "/%s" % x)
                    os.symlink(os.path.abspath(x), os.path.expanduser("~") + "/%s" % x)
                    if args.kill:
                        sys.exit()

try:
    main()
except KeyboardInterrupt:
    print("\n" + bcolors.color("Caught Keyboard Interrupt. Exiting.", "WARNING", b=True))
