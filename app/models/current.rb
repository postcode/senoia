class Current

  def self.user
    Thread.current[:current_user]
  end

  def self.user=(user)
    Thread.current[:current_user] = user
  end
  
end
