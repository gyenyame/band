module MetaWeblogStructs
  class Post < ActionWebService::Struct
    member :postId, :string
    member :title, :string
    member :link, :string
    member :dateCreated, :time
    member :description, :string
    member :categories, [:string]
  end
end

class MetaWeblogApi < ActionWebService::API::Base
  inflect_names false
  
  api_method :getCategories,
    :expects => [{:blogId => :string},
      {:username => :string},
      {:password => :string}],
    :returns => [[:string]]
    
  api_method :newPost,
    :expects => [
      {:blogId => :string},
      {:username => :string},
      {:password => :string},
      {:content => MetaWeblogStructs::Post},
      {:publish => :bool}
      ],
    :returns => [:string]
    
    api_method :getPost,
      :expects => [{:postId => :string}, 
        {:username => :string},
        {:password => :string}],
      :returns => [MetaWeblogStructs::Post]
      
    api_method :getRecentPosts,
      :expects => [{:blogId => :string},
        {:username => :string},
        {:password => :string},
        {:numberOfPosts => :int}],
      :returns => [[MetaWeblogStructs::Post]]
      
    api_method :editPost,
      :expects => [{:postId => :string},
        {:struct => MetaWeblogStructs::Post},
        {:publish => :int}],
      :returns => [:bool]
end

def buildPost(post)
  MetaWeblogStructs::Post.new(
    :dateCreated => post.created_at || '',
    :postId => post.id.to_s,
    :description => post.body,
    :title => post.title
  )
end

def parseComposer(post)
  @composer = "" 
  post = "" if post.nil?
  
  new_post = post.sub(/Composer:.+?[<\n]/) do |c|    
    @composer = c.sub("Composer:","")
    if @composer.match(/<$/)
      @composer = @composer.gsub(/[<>]/,"").strip
      "<"
    else
      ""
    end
  end  
  {:body => new_post, :composer => @composer}
end

class MetaWeblogLyricsService < ActionWebService::Base
  web_service_api MetaWeblogApi
  
  def newPost(blogId, username, password, content, publish)
    @user = User.authenticate(username, password)
    unless @user.nil?
      song = parseComposer(content['description'])
      p = Lyric.new(:title => content['title'], 
        :body => song[:body],
        :composer => song[:composer])
      p.created_by = @user.id
      p.save ? p.id.to_s : 'Error: post cannot be created'
    end
  end
  
  def getPost(postId, username, password)
    @user = User.authenticate(username, password)
    unless @user.nil?
      post = Lyric.find(postId)
      
      buildPost(post)
    end
  end
  
  def getRecentPosts(blogId, username, password, numberOfPosts)
    @user = User.authenticate(username, password)
    unless @user.nil?
      Lyric.find(:all, :order => "created_at DESC",
        :limit => numberOfPosts).collect do |p|
          buildPost(p)
        end
    end
  end
  
  def editPost(postId, username, password, content, publish)      
    @user = User.authenticate(username, password)
    unless @user.nil?
      post = Lyric.find(postId)
      post.attributes = {:body => content['description'].to_s,
        :title => content['title'].to_s}
      post.save
      true
    end
  end
  
  def getCategories(blogId, username, password)
    @user = User.authenticate(username, password)
    unless @user.nil?
      []
    end
  end
end