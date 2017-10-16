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
    
    if params[:video][:address] =~ URI::DEFAULT_PARSER.regexp[:ABS_URI]
      # Correct URL
      if params[:video][:name] == ""
        videoname = "Some Video"
      else
        videoname = params[:video][:name]
      end
      
      if params[:video][:description] == ""
        videodescription = "Comming Soon"
      else
        videodescription = params[:video][:description]
      end
      videoaddress = params[:video][:address]
      videotypes = params[:video][:checkedtype]
      
      # When the new video has only a new type
      # or no type is checked
      if videotypes.nil?
        if params[:video][:newtype] == ""
          videotypes = "Others"
        else
          videotypes = params[:video][:newtype]
        end
        # Create a new type if it does not exist
        if Type.find_by_name(videotypes).nil?
          Type.create(name: videotypes)
        end
      end
      
      # When the new video has several types including a new type
      if params[:video][:newtype] == ""
        videotypes[-1] = "Others"
        if Type.find_by_name(videotypes[-1]).nil?
          Type.create(name: videotypes[-1])
        end
      else
        videotypes[-1] = params[:video][:newtype]
        if Type.find_by_name(videotypes[-1]).nil?
          Type.create(name: videotypes[-1])
        end
      end
      
      # Append videotypes with "All"
      videotypes.push("All")
      
      # Add a new video if it does not exist
      if Vid.where(:address => videoaddress).empty?   
         Vid.create(name: videoname, address: videoaddress, 
           description: videodescription, :types => Type.where(:name => videotypes))
      end
      # Vid.create(name: videoname, address: videoaddress, 
      #    description: videodescription, :types => Type.where(:name => videotypes))
      
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
