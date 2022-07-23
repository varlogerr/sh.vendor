# Vendor

## Usage

In most cases you'll want to use this tool when creating other tools. Demo usage:

```sh
cd '<your-project-dir>'
git clone https://github.com/varlogerr/toolbox.sh.vendor.git ./vendor/vendor
cd ./vendor/vendor
git checkout <latest-tag>
cd -
# add vendor `.bin` directory to your path
PATH="./vendor/.bin:${PATH}"
# initialize the project
./vendor/vendor/bin/vendor.sh --init .
# install dependencies. after initialization
# there will be only vendor itself as a dependency
./vendor/vendor/bin/vendor.sh
# now you can use `vendor.sh` command
vendor.sh --help
```
