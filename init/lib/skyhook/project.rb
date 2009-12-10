class Project
  
  attr_reader :name
  attr_reader :path
  attr_reader :repo
  attr_reader :revision
  attr_reader :status
  
  def initialize
    @status = {} if @status.nil?
    if File.exist?(@path)
      save_status if !load_status
    end
  end
  
  def active
    @status["active"] if @status.has_key?("active")
  end
  
  def boot
    init
    checkout
    activate
  end
  
  def update(*args)
    checkout(*args)
  end
  
  # def restart
  #   shell "touch #{@path}/r#{@status[:active]}/tmp/restart.txt"
  # end
  
  def init
    if !File.exist?(@path)
      shell "mkdir -p #{@path}"
    end
    if File.exist?("#{$projects_config_path}/#{@name}.conf")
      shell "rm #{$nginx_projects_config_path}/#{@name}.conf" if File.exist?("#{$nginx_projects_config_path}/#{@name}.conf")
      shell "cp #{$projects_config_path}/#{@name}.conf #{$nginx_projects_config_path}/#{@name}.conf"
    end
  end
  
  def has_latest?
    versions = get_available_versions
    if !@revision.nil? && versions.include?(@revision)
      return true
    end
    head = SVN.last_changed_rev(@repo)
    if !@status.has_key?("head") || @status["head"].nil? || @status["head"] != head
        save_status("head" => head)
    end
    if !versions.include?(head)
        return false
    end
    return true
  end

  def checkout(rev = nil)
    if File.exist?(@path)
      has_latest?
      rev = @revision if rev.nil? && !@revision.nil?
      version = (rev.nil? || rev.to_i > @status["head"] || rev.to_s.downcase == "head") ? @status["head"] : rev.to_i
      if !version.nil?
        rev_path = "#{@path}/r#{version}"
        if !File.exist?(rev_path)
          SVN.export @repo, rev_path, version
          return true
        end
        return nil
      end
    end
    return false
  end

  def activate(rev = nil)
    versions = get_available_versions
    version = nil
    if rev.nil? && !@revision.nil?
      version = @revision
    elsif rev.to_s.downcase == "head" || rev.nil?
      version = versions.last
    elsif versions.include?(rev.to_i)
      version = rev.to_i
    else
      version = versions.last
    end
    active = (@status.has_key?("active")) ? @status["active"] : nil
    return nil if version == active
    if !version.nil?
      shell "rm #{@path}/htdocs" if File.exist?("#{@path}/htdocs")
      shell "ln -s r#{version} #{@path}/htdocs"
      save_status("active" => version)
      return true
    end
    return false
  end
  
  def clean
    leave = 5 # number of version copies to keep
    versions = get_available_versions
    keep = []
    keep << @revision if !@revision.nil?
    keep << active if !active.nil? && !keep.include?(active)
    (leave-keep.size).times { versions.pop }
    versions.each do |version|
      if !keep.include?(version)
        shell "rm -rf #{@path}/r#{version}"
      end
    end
  end
  
  def load_status
    if File.exist?("#{@path}/status.yml")
      @status = YAML.load_file("#{@path}/status.yml")
      return true
    end
    return false
  end

  def save_status(input = {})
    @status = @status.merge(input)
    File.open("#{@path}/status.yml", "w") do |f|
      YAML.dump(@status, f)
    end
  end

  def get_available_versions
    dirs = []
    Dir.glob("#{@path}/r*").each do |item|
      dirs << $1.to_i if item =~ /^.*\/r(\d+)$/
    end
    return dirs.sort
  end

end