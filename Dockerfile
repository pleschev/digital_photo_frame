FROM resin/rpi-raspbian:jessie

# Dependencies to:
# - Download my_init
# - Convert images
# - Display images
# - my_init dependency
# - photo_frame.rb script dependency

RUN apt-get update && \             
	apt-get install -y \            
	curl \                          
	imagemagick \                   
	fbi \                           
	python3 \                       
	ruby1.9.1 ruby-dev libssl-dev \ 
	&& rm -rf /var/lib/apt/lists/*

# gem dependencies for photo_frame.rb
RUN gem install mail mini_magick rufus-scheduler

ADD . /App

# my_init used to ensure zombie fbi processes are cleaned up
RUN curl -SL https://raw.githubusercontent.com/phusion/baseimage-docker/master/image/bin/my_init > /sbin/my_init
RUN chmod +x /sbin/my_init

CMD ["/sbin/my_init", "--skip-startup-files", "--skip-runit", "ruby", "/App/photo_frame.rb"]