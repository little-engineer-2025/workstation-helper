# Customize firefox configuration
if [ -e ~/.mozilla/firefox ]; then
  for profile in ~/.mozilla/firefox/*; do
    [ ! -d $profile ] && continue
    cp -vf "files/home/.mozilla/firefox/user.js" $profile/user.js 
  done
fi


