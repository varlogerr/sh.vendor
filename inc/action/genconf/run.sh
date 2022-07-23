sed -e 's/{vendor_version}/'"${DEFAULTS[vendor_version]}"'/g' \
  -e 's#{vendor_dir}#'"${DEFAULTS[vendor_dir]}"'#g' \
  "${KEEPER[tooldir]}/tpl/vendor.conf"
