#!/bin/bash
yum update -y
yum install -y httpd.x86_64
systemctl start httpd.service
systemctl enable httpd.service
cat << 'EOF' > /var/www/html/index.html
<!DOCTYPE html>
<html>
<body>

<h1>Welcome to Jenkins training</h1>
<p>This is our first jenkins job</p>

</body>
</html>
EOF