class SVN

  def self.checkout(repo, target = "", revision = nil)
    self.checkout_or_export(:checkout, repo, target, revision)
  end
  
  def self.co(repo, target = "", revision = nil)
    self.checkout_or_export(:co, repo, target, revision)
  end
  
  def self.export(repo, target = "", revision = nil)
    self.checkout_or_export(:export, repo, target, revision)
  end
  
  def self.up(revision = nil, target = "")
    rev = parse_revision(revision)
    shell "svn up #{rev} #{target}"
  end
  
  def self.revision(repo)
    self.info(repo)["Revision"].to_i
  end
  
  def self.last_changed_rev(repo)
    self.info(repo)["Last Changed Rev"].to_i
  end
  
  def self.info(path)
    data = `svn info #{path}`.split(/\n\r|\n|\r/)
    info = {}
    data.each do |item|
      info[$1.strip] = $2.strip if item =~ /(.+?)\:(.+)/
    end
    return info
  end
  
private
  
  def self.checkout_or_export(method, repo, target = "", revision = nil)
    if ["export", "co", "checkout"].include?(method.to_s)
      rev = parse_revision(revision)
      shell "svn #{method.to_s} #{rev} #{repo} #{target}"
      return true
    end
    return false
  end
  
  def self.parse_revision(revision)
    (!revision.to_s.match(/^\d+$/).nil?) ? "-r#{revision.to_s.match(/^\d+$/).to_s}" : ""
  end
  
end