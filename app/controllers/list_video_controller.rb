class ListVideoController < ApplicationController
  layout "my_layout"
  require "uri"
  def index
    @types = Type.all
    if @types.empty?
      Type.create(name: "All")
    end
    @types = Type.all
    
    @novid = Vid.find_by_name("Unknown Video")
    if @novid.nil?
      Vid.create(name: "Unknown Video", address: "https://www.youtube.com/embed/KkmNBWEfb24?ecver=2", 
        description: "Comming Soon")
      Vid.find_by_name("Unknown Video").types << Type.all
    end
    
    @typesexceptalls = @types[1..-1]
    @vids = Type.first.vids
    @typechosenid = @types.first.id
    @vidchosenid = @vids.first.id
    @vidembeddedurl = @vids.find_by_id(@vidchosenid).address
  end
  
  
  
  

  def show
    @types = Type.all
    @typesexceptalls = @types[1..-1]
    @vids = Type.find_by_id(params[:id]).vids
    @typechosenid = params[:id]
    if params[:vid_id].nil?
      @vidchosenid = @vids.first.id
    else
      @vidchosenid = params[:vid_id]
    end
    @vidembeddedurl = @vids.find_by_id(@vidchosenid).address
    respond_to do |format|
      format.js
      format.html {redirect_to root_path}
    end
  end
  
  
  

  def create
    
    # If the new information is invalid, we will use the following setup
    @types = Type.all
    @typesexceptalls = @types[1..-1]
    @vids = Type.first.vids
    @typechosenid = @types.first.id
    @vidchosenid = @vids.first.id
    @vidembeddedurl = @vids.find_by_id(@vidchosenid).address
    
    @is_it_successful = 'false'
    @notification_message = 'URL is invalid or the video had been added before. \n So, nothing has been changed!'
    
    # Check if "videoaddress" is an embedded youtube url or not
    # If not, convert it to an embedded one
    videoaddress = params[:video][:address]
    if !videoaddress.include?("embed")
      # if "videoaddress" is not an embedded url, then
      videoaddress = videoaddress.sub("/watch?v=", "/embed/")
    end
      
    # Check if URL is correct or not
    if (params[:video][:address] =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]) && (Vid.where(:address => videoaddress).empty?) 
      
      # Check if there is a name for the new video, if not, then name it "Some Video"
      if params[:video][:name] == ""
        videoname = "Some Video"
      else
        videoname = params[:video][:name]
      end
      
      # Check if there is a description for the new video, if not, then add it "Coming Soon"
      if params[:video][:description] == ""
        videodescription = "Comming Soon"
      else
        videodescription = params[:video][:description]
      end
      
      
      # The input type of the new video may be a collection of names or nil
      videotypes = params[:video][:checkedtype]
      
      # When the new video has only a new type
      # or no type is checked
      if videotypes.nil?
        videotypes = []
        if params[:video][:newtype] == ""
          videotypes << "Others"
          # Create a new type if it does not exist
          if Type.find_by_name("Others").nil?
            Type.create(name: "Others")
            @notification_message = 'The new video has been added successfully! \n However, no type is chosen \n The new video is now in the list of Others'
          end
        else
          videotypes << params[:video][:newtype]
          # Create a new type if it does not exist
          if Type.find_by_name(params[:video][:newtype]).nil?
            is_there_others = 'false'
            if !Type.find_by_name("Others").nil?
              Type.find_by_name("Others").delete
              is_there_others = 'true'
            end
            Type.create(name: params[:video][:newtype])
            @notification_message = 'The new video has been added successfully! \n We also has a new type of videos!'
            if is_there_others
              Type.create(name: "Others")
            end
          end
        end
      end
      
      # When the new video has several types
      if !videotypes.nil?
        newtype = params[:video][:newtype]
        if newtype != ""
          if newtype != "Others"
            if Type.find_by_name(newtype).nil?
              is_there_others = 'false'
              if !Type.find_by_name("Others").nil?
                Type.find_by_name("Others").delete
                is_there_others = 'true'
              end
              Type.create(name: newtype)
              @notification_message = 'The new video has been added successfully! \n We also has a new type of videos!'
              if is_there_others
                Type.create(name: "Others")
              end
              videotypes << newtype
            end
          else
            if Type.find_by_name("Others").nil?
              Type.create(name: "Others")
              @notification_message = 'The new video has been added successfully! \n We also has a new type of videos!'
            else
              @notification_message = 'The new video has been added successfully! \n However, no new type has been added!'
            end
          end
        end
      end
      
      # Append videotypes with "All"
      videotypes.push("All")
     
        
      # Delete "Others" first (and add later to make sure that "Others" is always the last)
      is_there_unknown_video = 'false'
      if !Vid.find_by_name("Unknown Video").nil?
       Vid.find_by_name("Unknown Video").delete
       is_there_unknown_video = 'true'
      end
       
      Vid.create(name: videoname, address: videoaddress, 
       description: videodescription, :types => Type.where(:name => videotypes))
         
      if is_there_unknown_video
       Vid.create(name: "Unknown Video", address: "https://www.youtube.com/embed/KkmNBWEfb24?ecver=2", 
         description: "Comming Soon")
       Vid.find_by_name("Unknown Video").types << Type.all
      end
      
      @is_it_successful = 'true'
    
       
      # The new video should be displayed immidiately with its first type
      @types = Type.all
      @typesexceptalls = @types[1..-1]
      
      @vids = Type.find_by_name(videotypes.first).vids
      @typechosenid = @types.find_by_name(videotypes.first).id
      @vidchosenid = @vids.find_by_name(videoname).id
      
      @vidembeddedurl = @vids.find_by_id(@vidchosenid).address
      
      
    end
    
    respond_to do |format|
      format.js 
      format.html 
    end
  end
end
