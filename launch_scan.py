import logging
import os
import subprocess
import sys

logger = logging.getLogger(__name__)

API_KEY = os.environ.get('INPUT_OSTORLAB_API_KEY', None)
SCAN_TITLE = os.environ.get('INPUT_SCAN_TITLE', None)
PLAN = os.environ.get('INPUT_PLAN', 'free')
TYPE = os.environ.get('INPUT_TYPE', None)
FILE = os.environ.get('INPUT_FILE', None)


class GithubCIScan:
    api_key: str
    scan_title: str
    plan: str
    type: str
    file: str

    def __init__(self):
        print(API_KEY is None)
        if API_KEY is None:
            set_failed("Api key is required")
        else:
            self.api_key = API_KEY
            self.scan_title = SCAN_TITLE
            self.plan = PLAN
            self.type = TYPE
            self.file = FILE

    def _sub_command(self):
        return ['ostorlab',
                'ci-scan',
                'run',
                f'--api-key={self.api_key}',
                f'--title={self.scan_title}',
                f'--plan={self.plan}",'
                f'--type={self.type}',
                f'--file={self.file}',
                ]

    def star_scan(self):
        try:
            subprocess.run(self._sub_command(), check=True)
        except subprocess.CalledProcessError:
            set_failed("Error happened")


def set_output(name: str, value: str):
    print(f'::set-output name={name}::{value}')


def set_failed(message):
    print(message)
    sys.exit(1)


def main():
    subprocess.run(['ls'], check=True)
    ci_scan_data = GithubCIScan()
    # ci_scan_data.star_scan()


if __name__ == '__main__':
    main()
