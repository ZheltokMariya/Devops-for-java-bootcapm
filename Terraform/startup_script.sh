!/bin/bash

# Add Docker's official GPG key:
apt apt-get update
apt-get install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the Docker repository to Apt sources:
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
  tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update

# Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo apt-get update && sudo apt -y install apache2
apt -y install php libapache2-mod-php

sudo cat <<EOF | tee /etc/apache2/mods-enabled/dir.conf
        <IfModule mod_dir.c>
            DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
        </IfModule>
EOF

sudo mv /var/www/html/index.html /var/www/html/index.php

sudo cat <<EOF | tee /var/www/html/index.php
    <!DOCTYPE html>
    <html lang="en">

    <body>
    <h1>Hello World!</h1>
    <h2>Operation system:</h2>

    <div>
        <?php
            echo "<p><strong>Operating System:</strong> " . php_uname('s') . "</p>";
            echo "<p><strong>Version:</strong> " . php_uname('v') . "</p>";
        ?>
    </div>

    </body>
    </html>
EOF

sudo service apache2 restart