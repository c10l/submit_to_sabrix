submit_to_sabrix
================

A script to submit multiple Invoices to a given Sabrix instance.

Usage
-----

    submit_to_sabrix.rb [options] file1 file2 ...

    Options:

        -u, --url URL                    Post to URL
        -y, --yes-to-all                 Skip safeguards -- USE WITH CAUTION!
        -n, --no-to-all                  Respond NO to all safeguard validations (safe)
        -a, --no-audit                   Force IS_AUDITED to false
        -s, --suffix TEXT                Add TEXT to the end of the outdata filename
        -h, --help                       Display this screen

Notes
-----

There are some ugly things happening especially with includes and loads. They were necessary because I'm distributing the script as a .exe for Windows users.

To compile yourself, install the gem *ocra* and run this from the command line:

    ocra --no-enc submit_to_sabrix.rb app 