#!/usr/bin/env python
"""AckAck acknowledgements generator."""

import codecs
import logging
import os
import plistlib
import re
import sys
from argparse import ArgumentParser


VERSION = '4.1'


# Configure the logger
logging.basicConfig(stream=sys.stdout, level=logging.INFO, format="%(message)s")


def method_available(klass, method):
    """Checks if the provided class supports and can call the provided method."""
    return callable(getattr(klass, method, None))


class Generator:
    """Generates the acknowledgements."""

    def __init__(self, options):
        self.options = options

    def find_input_folders(self):
        """Finds the input folders based on the location of the Carthage folder."""

        # Find the Carthage Checkouts and CocoaPods Pods folder
        carthage_folder = self.find_folder(os.getcwd(), 'Carthage/Checkouts')
        cocoapods_folder = self.find_folder(os.getcwd(), 'Pods')

        # If they are found, add them
        input_folders = []
        if carthage_folder:
            input_folders.append(carthage_folder)
        if cocoapods_folder:
            input_folders.append(cocoapods_folder)

        self.options.input_folders = input_folders

    def find_output_folder(self):
        """Finds the output folder based on the location of the Settings.bundle."""

        # Find the Settings.bundle
        self.options.output_folder = self.find_folder(os.getcwd(), 'Settings.bundle')

    def find_folder(self, base_path, search):
        """Finds a folder recursively."""

        # First look in the script's folder
        if search.startswith(os.path.basename(base_path)) and os.path.isdir(base_path):
            return base_path
        if os.path.isdir(os.path.join(base_path, search)):
            return os.path.join(base_path, search)

        # Look in subfolders
        for root, dirs, _ in os.walk(base_path):
            for dir_name in dirs:
                if search.startswith(dir_name):
                    result = os.path.join(root, search)
                    if os.path.isdir(result):
                        return result

        parent_path = os.path.abspath(os.path.join(base_path, '..'))

        # Try parent folder if it contains a Cartfile
        if os.path.exists(os.path.join(parent_path, 'Cartfile')):
            return self.find_folder(parent_path, search)

        # Try parent folder if it contains a Podfile
        if os.path.exists(os.path.join(parent_path, 'Podfile')):
            return self.find_folder(parent_path, search)

        return None

    def generate(self):
        """Generates the acknowledgements."""
        options = self.options

        # Create the folder to store the licenses
        container_path = os.path.join(
            options.output_folder, options.container_name)
        if not os.path.exists(container_path):
            logging.info('Creating %s folder', options.container_name)
            os.makedirs(container_path)
        elif not options.no_clean:
            logging.info('Removing old license plists')
            self.remove_files(container_path, ".plist")

        # Scan the input folder for licenses
        logging.info('Searching licenses...')
        frameworks = {}

        for folder in options.input_folders:
            for root, dirs, files in os.walk(folder):
                # Sort the folder names for nicer output
                dirs.sort()

                for file_name in files:
                    # Ignore licenses in deep folders
                    relative_path = os.path.relpath(root, folder)
                    if relative_path.count(os.path.sep) >= options.max_depth:
                        continue

                    # Look for license files
                    if file_name.lower() in options.license_names:
                        # We found a framework's license
                        license_path = os.path.join(root, file_name)
                        framework_name = os.path.basename(os.path.dirname(license_path))

                        # Clean up the framework name and store the info
                        framework_name = self.clean_framework_name(framework_name)
                        frameworks[framework_name] = license_path

        # Did we find any licenses?
        if not frameworks:
            logging.info('No licenses found')

        # Find existing license plists
        old_framework_names = self.find_framework_plists(container_path)
        new_framework_names = list(frameworks.keys())
        all_framework_names = set(old_framework_names + new_framework_names)

        # Process license plists
        framework_names = sorted(list(all_framework_names))
        for framework_name in framework_names:
            # If the framework isn't based on a license just mention it
            if framework_name not in new_framework_names:
                logging.info('Tracking license plist for %s', framework_name)
                continue

            # Generate the paths
            license_path = frameworks[framework_name]
            plist_path = os.path.join(container_path, framework_name + '.plist')

            # Create or update the plist
            if os.path.exists(plist_path):
                logging.info('Updating license plist for %s', framework_name)
            else:
                logging.info('Creating license plist for %s', framework_name)

            self.create_license_plist(license_path, plist_path)

        # Create or update the acknowledgements plist
        plist_path = os.path.join(options.output_folder, options.plist_name + '.plist')
        if os.path.exists(plist_path):
            logging.info('Updating acknowledgements plist')
        else:
            logging.info('Creating acknowledgements plist')

        self.create_acknowledgements_plist(framework_names, options.container_name, plist_path)

    def create_license_plist(self, license_path, plist_path):
        """Generates a plist for a single license, start with reading the license."""

        # Read and clean up the text
        license_text = codecs.open(license_path, 'r', 'utf-8').read()
        license_text = license_text.replace('  ', ' ')
        license_text = re.sub(
            r'(\S)[ \t]*(?:\r\n|\n)[ \t]*(\S)', '\\1 \\2',
            license_text
        )

        # Remove control characters not allowed in plists
        license_text = re.sub(r'[\x00-\x08\x0b\x0c\x0e\x0f\x10-\x19\x1a-\x1f]', '', license_text)

        # Create the plist
        self.create_plist({
            'PreferenceSpecifiers': [{
                'Type': 'PSGroupSpecifier',
                'FooterText': license_text
            }]
        }, plist_path)

    def find_framework_plists(self, folder):
        """Finds frameworks names based on the plists in the specified folder."""
        frameworks = []

        for _, _, files in os.walk(folder):
            for file in files:
                if file.endswith(".plist"):
                    framework_name = os.path.splitext(file)[0]
                    framework_name = self.clean_framework_name(framework_name)
                    frameworks.append(framework_name)

        return sorted(frameworks)

    def create_acknowledgements_plist(self, frameworks, container_name, plist_path):
        """Generates a plist combining all the licenses."""
        contents = []

        # Walk through the frameworks
        for framework in sorted(frameworks):
            contents.append({
                'Type': 'PSChildPaneSpecifier',
                'File': container_name + '/' + framework, 'Title': framework
            })

        # Create the plist
        self.create_plist(
            {'PreferenceSpecifiers': contents},
            plist_path
        )

    def create_plist(self, content, path):
        """Creates a plist with the provided content at the specified path."""
        if method_available(plistlib, 'dump'):
            with open(path, 'wb') as handle:
                plistlib.dump(content, handle)
        else:
            plistlib.writePlist(content, path) # pylint: disable=deprecated-method

    def clean_framework_name(self, name):
        """Cleans up the framework name."""
        return name[:1].upper() + name[1:]

    def remove_files(self, folder, extension):
        """Removes files with a specific extension from a folder."""

        for root, _, files in os.walk(folder):
            for file_name in sorted(files):
                if file_name.endswith(extension):
                    full_path = os.path.join(root, file_name)
                    try:
                        os.remove(full_path)
                    except OSError:
                        logging.info('Could not remove %s', full_path)


def main():
    """Main entry point of application."""

    # Create a parser to parse the commandline arguments
    parser = ArgumentParser(
        prog='AckAck',
        description='Generates an acknowledgements plist from your Carthage / CocoaPods frameworks.',
        epilog='The script will try to find the input and output folders for you. '
        'This usually works fine if the script is in the project root or in a Scripts subfolder. '
        'Visit https://github.com/Building42/AckAck for more information.',
        add_help=False
    )

    parser.add_argument(
        '-i', '--input', dest='input_folders', nargs='*',
        help='the path to the input folder(s), e.g. Carthage/Checkouts'
    )

    parser.add_argument(
        '-o', '--output', dest='output_folder',
        help='the path to the output folder, e.g. MyProject/Settings.bundle'
    )

    parser.add_argument(
        '-p', '--plist-name', default='Acknowledgements',
        help="the name of the plist that points to the licenses (default: 'Acknowledgements')"
    )

    parser.add_argument(
        '-c', '--container-name',
        help="the name of the folder that will contain the licenses (default: 'Acknowledgements' or 'Licenses')"
    )

    parser.add_argument(
        '-l', '--license-names', nargs='*', default=['license', 'license.txt', 'license.md'],
        help="the case-insensitive license file names to look for (default: 'license', 'license.txt', 'license.md')"
    )

    parser.add_argument(
        '-d', '--max-depth', default=1, type=int,
        help='specify the maximum folder depth to look for licenses'
    )

    parser.add_argument(
        '-n', '--no-clean', action='store_true',
        help='do not remove existing license plists'
    )

    parser.add_argument(
        '-q', '--quiet', action='store_true',
        help='do not generate any output unless there are errors'
    )

    parser.add_argument(
        '-h', '--help', action='help',
        help='show this help message and exit'
    )

    parser.add_argument(
        '-v', '--version', action='version', version='%(prog)s ' + VERSION,
        help='show the version information and exit'
    )

    # Create the generator based on the commandline arguments
    options = parser.parse_args()
    generator = Generator(options)

    # Quiet mode?
    if generator.options.quiet:
        logging.getLogger().setLevel(logging.WARNING)

    # No input folder? Find it
    if not generator.options.input_folders:
        generator.find_input_folders()

    # Still no input folder?
    if not generator.options.input_folders:
        logging.error('Input folder(s) could not be detected, please specify one with -i or --input')
        sys.exit(2)
    else:
        # Are the input folders valid?
        for folder in generator.options.input_folders:
            if not os.path.isdir(folder):
                logging.error("Input folder %s doesn't exist or is not a folder", folder)
                sys.exit(2)

    # Log input folder(s)
    logging.info('Input folder(s): %s', ', '.join(generator.options.input_folders))

    # No output folder? Find it
    if not generator.options.output_folder:
        generator.find_output_folder()

    # Still no output folder?
    if not generator.options.output_folder:
        logging.error('Output folder could not be detected, please specify one with -o or --output')
        sys.exit(2)
    elif not os.path.isdir(generator.options.output_folder):
        logging.error("Output folder %s doesn't exist or is not a folder", generator.options.output_folder)
        sys.exit(2)

    # Log output folder
    logging.info('Output folder: %s', str(generator.options.output_folder))

    # Make sure the plist name is only a name without extension
    if not re.match('^[A-Za-z0-9_-]+$', generator.options.plist_name):
        logging.error('Plist name invalid, it should not contain any path components')
        sys.exit(2)

    # No container name?
    if not generator.options.container_name:
        # In older versions the folder would be named Licenses
        old_folder = os.path.join(generator.options.output_folder, 'Licenses')
        generator.options.container_name = 'Licenses' if os.path.isdir(old_folder) else 'Acknowledgements'

    # Make sure the license file names to match against are lowercased
    generator.options.license_names = list(map(str.lower, generator.options.license_names))

    # Generate the acknowledgements
    generator.generate()


# Main entry point
if __name__ == "__main__":
    main()
