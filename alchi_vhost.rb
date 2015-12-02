#sudo rm livingunx.com fuitter.sushant.com me.demo1.sushant.com unx.sushant.com teamunx.sushant.com u.sushant.com sus.com sushant.com
require 'fileutils'
#put the link to your host file
open('/etc/hosts') do |f|
  matches = []
  vhosts = []
  f.readlines.each do |lines|
    matches << lines if lines =~ /.*.com/
  end
  #depending upon your vhost you may need to configure here
  matches.each do |val|
    val.split.each do |x|
      vhosts << x if x =~ /.*.com/
    end
  end
  vhosts.each do |domain|
    #configure the directory of your sites-available
    unless File.file? "/etc/nginx/sites-available/#{domain}"
      #include path to sites-available and sites-enabled directory
      File.symlink  "/etc/nginx/sites-available/#{domain}", "/etc/nginx/sites-enabled/#{domain}"
      open("/etc/nginx/sites-available/#{domain}", 'w') do |g|
        g << "server { \n"
        g << "\tlisten 80 default_server;\n"
        g << "\tlisten [::]:80 default_server ipv6only=on;\n"
        g << "\troot /usr/share/nginx/html;\n"
        g << "\tindex index.html index.htm;\n"
        g << "\tserver_name localhost;\n"
        g << "\tlocation / {\n"
        g << "\t\ttry_files $uri $uri/ =404;\n"
        g << "\t}\n"
        g << "}\n"
        g << "server {\n"
        g << "\tpassenger_ruby /path/to/ruby;\n"
        g << "\trails_env development;\n"
        g << "\tlisten 80;\n"
        g << "\tserver_name #{domain};\n"
        g << "\troot /usr/share/nginx/html/#{domain}/public;\n"
        g << "\tpassenger_enabled on;\n"
        g << "}\n"
      end
      #set the correct path to your web access directory
      %x(rails new /usr/share/nginx/html/"#{domain}")
    end
  end
end
%x(service nginx restart)
