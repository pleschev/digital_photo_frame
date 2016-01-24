require 'mail'
require 'tempfile'
require 'mini_magick'
require 'rufus-scheduler'

imap_user_name = ENV['IMAP_USER_NAME']
imap_password = ENV['IMAP_PASSWORD']
lcd_resolution = ENV['LCD_RESOLUTION']

images_location = '/data'
seconds_on_each_photos = 5

fbi_command = "fbi -noverbose -vt 2 -timeout #{seconds_on_each_photos} -random --blend 200 -m #{lcd_resolution} --autozoom -device /dev/fb0 -once #{images_location}/*"

puts "Photo gallery started"

Mail.defaults do
  retriever_method :imap, :address    => "imap.gmail.com",
                          :port       => 993,
                          :user_name  => imap_user_name,
                          :password   => imap_password,
                          :enable_ssl => true
end

Thread.new do
	loop { 
		begin
			#TODO: If there are no images, display instructions on how to send photos to be displayed

			puts "Executing fbi command [#{fbi_command}]"
			system(fbi_command)
			
			puts "Waiting for all fbi processes to finish"
			#Can't wait on pid, as fbi spawns subprocesses
			while `ps aux | grep fb[i]` != "" do
				sleep(0.01)
			end
			puts "fbi finished"
	    rescue => e
	    	puts "Unable to run fbi because #{e.message}"
	      	sleep(5)
	   	end
	}
end

scheduler = Rufus::Scheduler.new(:overlap => false)
scheduler.every '60s' do
	puts "Checking mail"

	Mail.find_and_delete(:what => :first, :count => 100, :order => :asc) do |message|

		puts "Message received from #{message.from} #{message.message_id}"

		begin
			message.attachments.each do |attachment|
				if (attachment.content_type.start_with?('image/'))
				    filename = attachment.filename

				    file = Tempfile.new(['original', filename])
				    file.write(attachment.body.decoded)
				    file.close
				    puts "Original image saved to #{file.path}"

				    scaled_image_filename = "#{images_location}/#{Time.now.to_i}_#{filename}"
					image = MiniMagick::Image.open(file.path)
					image.auto_orient
					image.resize lcd_resolution
					image.write scaled_image_filename

					puts "Scaled image saved to #{scaled_image_filename}"
		  		end
			end
			puts "Message deleted"
	    rescue => e
	    	puts "Unable to save data for #{filename} because #{e.message}"
	      	message.skip_deletion
	    end
	end	
end
scheduler.join
