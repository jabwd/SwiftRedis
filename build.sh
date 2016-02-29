echo "=> Downloading hiredis from GitHub..."
git submodule init
cd hiredis
make > /dev/null
sudo make install > /dev/null
echo "hiredis is now installed."
